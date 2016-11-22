//
//  ReportDetailViewController.m
//  QinQingBao
//
//  Created by shi on 2016/10/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ReportDetailViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ReportDetailViewController ()<UIWebViewDelegate,AVSpeechSynthesizerDelegate>
{
    UIButton *speakBtn;
    
    NSInteger timesec;
    
    NSTimer *timer;
    
    AVSpeechSynthesizer *synthesizer;
    AVSpeechUtterance *utterance;
}

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation ReportDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    
    NSURL *url = [[NSURL alloc] initWithString:self.urlstr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.timeoutInterval = 60;
    
    [self.webView loadRequest:request];
    
    [self initSpeachView];
}

-(void)setUrlstr:(NSString *)urlstr
{
    _urlstr = urlstr;
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)initSpeachView
{
    // 1.创建按钮
    speakBtn = [[UIButton alloc] initWithFrame:CGRectMake(MTScreenW - 100, MTScreenH - 100, 64, 64)];
    
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
    utterance.rate = 0.5;
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

@end
