//
//  PostsDetailViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/9/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "PostsDetailViewController.h"
#import "DetailPostsModel.h"
#import "PostsDetailUserCell.h"
#import "PostsDetailDZCell.h"
#import "PostsCommentCell.h"

@interface PostsDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,UITextViewDelegate>
{
    DetailPostsModel *detailData;
    
    UIWebView *_webView;
    
    UITableView *tableview;
    
    CGFloat cellHeight;
}


@property (strong, nonatomic) UIView *replyBar;

@property (strong, nonatomic) UITextView *replayTextView;

@property (strong, nonatomic) UIButton *replyBtn;

@property (assign, nonatomic) CGFloat keyBoardHeight;

@end

@implementation PostsDetailViewController


-(instancetype)init
{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH - 60) style:UITableViewStylePlain];
    tableview.delegate =self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = HMGlobalBg;
    [self.view addSubview:tableview];
    
//    [self getDetailData];
    
    self.replyBar = [[UIView alloc] initWithFrame:CGRectMake(0, MTScreenH - 60, MTScreenW, 60)];
    self.replyBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.replyBar];
    
    UITextView *txtView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, MTScreenW - 80, 40)];
    txtView.layer.borderColor = HMColor(235, 235, 235).CGColor;
    txtView.layer.borderWidth = 1.0f;
    txtView.layer.cornerRadius = 8.0f;
    txtView.delegate = self;
    txtView.font = [UIFont systemFontOfSize:15];
    [self.replyBar addSubview:txtView];
    self.replayTextView = txtView;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(MTScreenW - 60, 10, 50, 40)];
    btn.backgroundColor = HMColor(148, 191, 54);
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:@"回复" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 8.0f;
    [self.replyBar addSubview:btn];
    self.replyBtn = btn;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 1)];
    line.backgroundColor = HMColor(235, 235, 235);
    [self.replyBar addSubview:line];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)getDetailData
{
    [CommonRemoteHelper RemoteWithUrl:URL_Get_articledetail parameters: @{
                                                                          @"tid" : self.itemdata.tid
                                                                          }
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         detailData = [DetailPostsModel objectWithKeyValues:[dict objectForKey:@"datas"]];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                 }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 60;
        
    }else if (indexPath.section == 0 && indexPath.row == 1){
        return cellHeight;
    }else if (indexPath.section == 0 && indexPath.row == 2){
        return 110;
        
    }else if (indexPath.section == 1 && indexPath.row == 0){
        return 40;
    }

    return [self tableView:tableview cellForRowAtIndexPath:indexPath].height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
       PostsDetailUserCell *cell = [PostsDetailUserCell createCellWithTableView:tableview];
        cell.postsDetailData = detailData;
        return cell;
       
    }else if (indexPath.section == 0 && indexPath.row == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sss"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"sss"];
            
            _webView = [[UIWebView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 100)];
            _webView.delegate = self;
            _webView.scrollView.bounces = NO;
            _webView.scrollView.showsHorizontalScrollIndicator = NO;
            _webView.backgroundColor  = [UIColor redColor];
            _webView.scrollView.scrollEnabled = NO;
            [_webView sizeToFit];
            [cell addSubview:_webView];
            [self showInWebView];
        }
        cell.textLabel.text = @"add";
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 2){
        PostsDetailDZCell *cell = [PostsDetailDZCell createCellWithTableView:tableview];
        return cell;
    }else if (indexPath.section == 1 && indexPath.row == 0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleCell"];
            cell.textLabel.textColor = HMColor(153, 153, 153);
            cell.textLabel.font = [UIFont systemFontOfSize:14];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"评论数 %@",@8];
        return cell;
    }
    else{
        PostsCommentCell *cell = [PostsCommentCell createCellWithTableView:tableview];
        [cell layoutCell];
        return cell;
    }
}

#pragma mark - 拼接html语言
- (void)showInWebView
{
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendFormat:@"<link rel=\"stylesheet\" href=\"%@\">",[[NSBundle mainBundle] URLForResource:@"SXDetails.css" withExtension:nil]];
    [html appendString:@"</head>"];
    
    [html appendString:@"<body>"];
    [html appendString:[self touchBody]];
    [html appendString:@"</body>"];
    
    [html appendString:@"</html>"];
    
    [_webView loadHTMLString:html baseURL:nil];
}

- (NSString *)touchBody
{
    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"<div class=\"title\">%@</div>",@"我的标题"];
    [body appendFormat:@"<div class=\"time\">%@</div>",@"时间"];
    [body appendString:@"<p>　　近日王楠老公郭斌发微博称：遇到一些欺负人近日王楠老公郭斌发微博称：遇到一些欺负人的事总是很难缓过劲，曾经的九一八！整个国家被一个比咱小太多的Sb国家从头到脚羞辱欺负的到家了！我是去过日本却从不用它包括电器之內的 任何产品！甚至在日本住酒店很小人地把水都打开，还觉得解气！其实这没用！咱得多方位加油！加油！</p><!--IMG#0--><p>　　王楠转发了此条微博手动点赞：这就是郭同学，永远这么直接，我手动点赞！永远不要忘记曾经的九一八！<br/></p><!--IMG#0--><p>　　然而有网友表示，王楠老公郭斌先前微博照片中，手上戴着的正好就是日本品牌G-SHOCK手表。<br/></p><!--IMG#0--><p>　　郭斌手上的G-SHOCK是CASIO手表的品牌之一，具有耐用、防水等特点。<br/></p><p> 特别声明：本文为网易自媒体平台“网易号”作者上传并发布，仅代表该作者观点。网易仅提供信息发布平台。</p>"];
    
    
    NSMutableString *imgHtml = [NSMutableString string];
    
    // 设置img的div
    [imgHtml appendString:@"<div class=\"img-parent\">"];
    
    // 数组存放被切割的像素
    //        NSArray *pixel = [detailImgModel.pixel componentsSeparatedByString:@"*"];
    CGFloat width = 690;
    CGFloat height = 1127;
    // 判断是否超过最大宽度
    CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width * 0.96;
    if (width > maxWidth) {
        height = maxWidth / width * height;
        width = maxWidth;
    }
    
    NSString *onload = @"this.onclick = function() {"
    "  window.location.href = 'sx:src=' +this.src;"
    "};";
    [imgHtml appendFormat:@"<img onload=\"%@\" width=\"%f\" height=\"%f\" src=\"%@\">",onload,width,height,@"http://dingyue.nosdn.127.net/aGMZtB5xhSw=P18ZTdlxOz7VjftxEvzU9CiE=3NcPq4YJ1474254066396compressflag.jpg"];
    // 结束标记
    [imgHtml appendString:@"</div>"];
    // 替换标记
    [body replaceOccurrencesOfString:@"<!--IMG#0-->" withString:imgHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
    
    return body;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
    CGRect newFrame = webView.frame;
    newFrame.size.height = actualSize.height;
    webView.frame = newFrame;
    
    cellHeight = newFrame.size.height;
    [tableview reloadData];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat replayTextHeight = textView.contentSize.height;
    
    if (replayTextHeight < 40) {
        replayTextHeight = 40;
    }else if (replayTextHeight >= 80){
        replayTextHeight = 80;
    }

    CGRect replayBarFrame = CGRectMake(0, MTScreenH - replayTextHeight - 20 - self.keyBoardHeight , MTScreenW, replayTextHeight + 20);
    CGRect replayTextFrame = CGRectMake(10, 10, MTScreenW - 80, replayTextHeight);
    
    
    [UIView animateWithDuration:0.3f animations:^{
        self.replyBar.frame = replayBarFrame;
        self.replayTextView.frame = replayTextFrame;
    }];
    
    if (replayTextHeight < 80) {
        [textView setContentOffset:CGPointZero animated:YES];
    }

}

#pragma mark - 键盘相关
/**
 *  键盘出现
 */
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = notification.userInfo;
    CGFloat animationTime = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyframe = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardH = keyframe.size.height;
    self.keyBoardHeight = keyBoardH;

    CGRect replyBarFrame = self.replyBar.frame;
    replyBarFrame.origin.y = MTScreenH - keyBoardH - replyBarFrame.size.height;
    
    CGRect tableFrame = CGRectMake(0, 0, MTScreenW, MTScreenH - keyBoardH - replyBarFrame.size.height);
    
    [UIView animateWithDuration:animationTime animations:^{
        tableview.frame = tableFrame;
        self.replyBar.frame = replyBarFrame;
    }];
    
}

/**
 *  键盘隐藏
 */
- (void)keyboardWillHide:(NSNotification *)notification
{
    self.keyBoardHeight = 0;
    
    NSDictionary *info = notification.userInfo;
    CGFloat animationTime = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    CGRect replyBarFrame = self.replyBar.frame;
    replyBarFrame.origin.y = MTScreenH - replyBarFrame.size.height;
    
    CGRect tableFrame = CGRectMake(0, 0, MTScreenW, MTScreenH - replyBarFrame.size.height);
    
    [UIView animateWithDuration:animationTime animations:^{
        tableview.frame = tableFrame;
        self.replyBar.frame = replyBarFrame;
    }];
}

@end
