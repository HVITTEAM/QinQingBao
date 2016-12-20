//
//  ReportDetailViewController.m
//  QinQingBao
//
//  Created by shi on 2016/10/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ReportDetailViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WebCell.h"

@interface ReportDetailViewController ()<AVSpeechSynthesizerDelegate,UIWebViewDelegate>
{
    UIButton *speakBtn;
    
    NSInteger timesec;
    
    NSTimer *timer;
    
    AVSpeechSynthesizer *synthesizer;
    AVSpeechUtterance *utterance;
    
}

@property (strong, atomic) NSMutableArray *pdfFilePaths;

@property (assign, atomic) NSInteger numberOfDownloadFile;

@property (strong, nonatomic) NSString *finalPDFPath;

@property (strong, nonatomic) NSOperationQueue *queue;

@property (strong, nonatomic) UIWebView *webView;
@end

@implementation ReportDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWebView];
    
    [self initSpeachView];
    
    [self uploadReadStatusWithReportId:self.wr_id fmno:self.fmno];
}

-(void)initSpeachView
{
    // 1.创建按钮
    speakBtn = [[UIButton alloc] initWithFrame:CGRectMake(MTScreenW - 100, MTScreenH - 160, 64, 64)];
    
    [speakBtn setBackgroundImage:[UIImage resizedImage:@"voice1"] forState:UIControlStateNormal];
    [speakBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:speakBtn];
    
    // 创建嗓音，指定嗓音不存在则返回nil
    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    
    // 创建语音合成器
    synthesizer = [[AVSpeechSynthesizer alloc] init];
    synthesizer.delegate = self;
    // 实例化发声的对象
    utterance = [AVSpeechUtterance speechUtteranceWithString:_speakStr];
    utterance.voice = voice;
    utterance.rate = AVSpeechUtteranceDefaultSpeechRate;
}

-(void)play:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    if (btn.selected == NO){
        [timer invalidate];
        [synthesizer pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        [speakBtn setBackgroundImage:[UIImage resizedImage:@"voice1"] forState:UIControlStateNormal];
    }
    else{
        if(synthesizer.isPaused)
            [synthesizer continueSpeaking];
        else
        {
            
            [synthesizer speakUtterance:utterance];
        }
        
        [self setBtnBkgImg:btn];
    }
    
}

-(void)setBtnBkgImg:(UIButton *)btn
{
    timesec = 1;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
}

-(void)timerFireMethod:(NSTimer *)theTimer
{
    if (timesec == 3)
    {
        timesec = 1;
    }
    else
    {
        timesec ++;
    }
    
    [speakBtn setBackgroundImage:[UIImage resizedImage:[NSString stringWithFormat:@"voice%ld",(long)timesec]] forState:UIControlStateNormal];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [timer invalidate];
    if(synthesizer.isSpeaking)
        [synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    synthesizer = nil;
    utterance = nil;
}


#pragma mark AVSpeechSynthesizerDelegate
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance;
{
    CX_Log(@"语音解读完毕");
    speakBtn.selected = NO;
    [timer invalidate];
    [speakBtn setBackgroundImage:[UIImage resizedImage:@"voice1"] forState:UIControlStateNormal];
}

/**
 *  检测报告状态变更 未读改为已读  read为0:解读报告操作 1:干预方案操作
 */
- (void)uploadReadStatusWithReportId:(NSString *)reportId fmno:(NSString *)fmno
{
    NSMutableDictionary *params = [@{
                                     @"client":@"ios",
                                     @"key":[SharedAppUtil defaultCommonUtil].userVO.key
                                     }mutableCopy];
    params[@"fmno"] = fmno;
    params[@"report_id"] = reportId;
    params[@"read"] = @"0";
    
    [CommonRemoteHelper RemoteWithUrl:URL_Readed parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)initWebView
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    self.webView = webView;
    
    self.numberOfDownloadFile = 0;
    
    self.queue = [[NSOperationQueue alloc] init];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    for (int i = 0; i < self.urlArr.count; i++) {
        NSURL *url = [[NSURL alloc] initWithString:self.urlArr[i]];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
        AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if ([responseObject isKindOfClass:[NSData class]]) {
                [self handleResultWith:(NSData *)responseObject idx:i];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [NoticeHelper AlertShow:@"文件不存在请重试" view:nil];
            [self.queue cancelAllOperations];
            [self removeTempPDFsWithPaths:self.pdfFilePaths];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
        [self.queue addOperation:op];
    }
}

- (void)setUrlArr:(NSArray *)urlArr
{
    _urlArr = urlArr;
    
    self.pdfFilePaths = [[NSMutableArray alloc] init];
    for (int i = 0; i < _urlArr.count; i++) {
        [self.pdfFilePaths addObject:[NSNull null]];
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

#pragma mark - 私有方法
/**
 *  每个PDF文件下载成功后的处理
 */
- (void)handleResultWith:(NSData *)pdfData idx:(int)i
{
    @synchronized (self) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [paths firstObject];
        NSString *pdfPath = [NSString stringWithFormat:@"%@/%d.pdf",documentPath,i];
        
        NSLog(@"%@",documentPath);
        
        bool result = [pdfData writeToFile:pdfPath atomically:YES];
        
        if (result) {
            self.numberOfDownloadFile++;
            [self.pdfFilePaths replaceObjectAtIndex:i withObject:pdfPath];
        }
        
        //全部下载完成
        if (self.numberOfDownloadFile == self.urlArr.count) {
            //合并pdf
            self.finalPDFPath = [self joinPDF:self.pdfFilePaths];
            
            //删除临时的pdf
            [self removeTempPDFsWithPaths:self.pdfFilePaths];
            
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:self.finalPDFPath]];
            [self.webView loadRequest:request];
        }
    }
}

/**
 *  合并PDF文件
 */
- (NSString *)joinPDF:(NSArray *)listOfPaths
{
    
    NSString *fileName = [NSString stringWithFormat:@"finalPDF.pdf"];
    NSString *pdfPathOutput = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    CFURLRef pdfURLOutput = (  CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:pdfPathOutput]);
    NSInteger numberOfPages = 0;
    CGContextRef writeContext = CGPDFContextCreateWithURL(pdfURLOutput, NULL, NULL);
    
    for (NSString *source in listOfPaths) {
        
        CFURLRef pdfURL = (  CFURLRef)CFBridgingRetain([[NSURL alloc] initFileURLWithPath:source]);
        CGPDFDocumentRef pdfRef = CGPDFDocumentCreateWithURL((CFURLRef) pdfURL);
        numberOfPages = CGPDFDocumentGetNumberOfPages(pdfRef);
        
        CGPDFPageRef page;
        CGRect mediaBox;
        
        for (int i=1; i<=numberOfPages; i++) {
            
            page = CGPDFDocumentGetPage(pdfRef, i);
            mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
            CGContextBeginPage(writeContext, &mediaBox);
            CGContextDrawPDFPage(writeContext, page);
            CGContextEndPage(writeContext);
        }
        
        CGPDFDocumentRelease(pdfRef);
        CFRelease(pdfURL);
    }
    
    CFRelease(pdfURLOutput);
    
    CGPDFContextClose(writeContext);
    CGContextRelease(writeContext);
    
    return pdfPathOutput;
}

/**
 *  删除临时PDF文件
 */
- (void)removeTempPDFsWithPaths:(NSArray *)paths
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    for (id filePath in paths) {
        if (![filePath isKindOfClass:[NSString class]]) {
            continue;
        }
        
        if ([manager fileExistsAtPath:filePath]) {
            [manager removeItemAtPath:filePath error:NULL];
        }
    }
}

- (void)dealloc
{
    //删除pdf
    [self removeTempPDFsWithPaths:self.pdfFilePaths];
    if (self.finalPDFPath.length > 0) {
        [self removeTempPDFsWithPaths:@[self.finalPDFPath]];
    }
}

@end
