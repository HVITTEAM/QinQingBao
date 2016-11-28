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
#import "DetailPostsModel.h"
#import "DetailImgModel.h"

#import "CommentModel.h"

#import "SWYPhotoBrowserViewController.h"
#import "PublicProfileViewController.h"

#define kReplyTextViewHeight 34
#define kReplyBarHeight (kReplyTextViewHeight + 20)
#define kNoPostsPrompt @"帖子被火星人带走了!"

@interface PostsDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,UITextViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate>
{
    UIWebView *_webView;
    
    CGFloat cellHeight;
    
    UIView *palceView;
    
    UIButton *authorBtn;
}

@property (strong, nonatomic) UITableView *tableview;

@property (strong, nonatomic) UIView *replyBar;

@property (strong, nonatomic) UITextView *replayTextView;

@property (strong, nonatomic) UIButton *replyBtn;

@property (strong, nonatomic) UILabel *replyPlaceholdeLb;

@property (assign, nonatomic) CGFloat keyBoardHeight;
/**帖子详情数据*/
@property (strong, nonatomic) DetailPostsModel *detailData;
/**评论数据源*/
@property (strong, nonatomic) NSMutableArray *commentDatas;
/**被回复评论的IndexPath,如果回复的是楼主,则设置为nil*/
@property (strong, nonatomic) NSIndexPath *replyCommentIdx;

@property (assign, nonatomic) NSInteger pageNum;

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
    self.extendedLayoutIncludesOpaqueBars = YES;

    self.pageNum = 1;
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH - kReplyBarHeight) style:UITableViewStylePlain];
    self.tableview.delegate =self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = HMGlobalBg;
    [self.view addSubview:self.tableview];
    self.tableview.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDatas)];
    
    [self setupNaviBar];
    
    [self setupReplyBar];
    
    [self getDetailData];
    
    [self loadCommonlist];
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

- (NSMutableArray *)commentDatas
{
    if (!_commentDatas) {
        _commentDatas = [[NSMutableArray alloc] init];
    }
    return _commentDatas;
}

#pragma mark - 界面创建
/**
 *  创建回复工具栏
 */
- (void)setupReplyBar
{
    self.replyBar = [[UIView alloc] initWithFrame:CGRectMake(0, MTScreenH - kReplyBarHeight, MTScreenW, kReplyBarHeight)];
    self.replyBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.replyBar];
    
    UITextView *txtView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, MTScreenW - 80, kReplyTextViewHeight)];
    txtView.layer.borderColor = HMColor(235, 235, 235).CGColor;
    txtView.layer.borderWidth = 1.0f;
    txtView.layer.cornerRadius = 8.0f;
    txtView.delegate = self;
    txtView.font = [UIFont systemFontOfSize:15];
    [self.replyBar addSubview:txtView];
    self.replayTextView = txtView;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(MTScreenW - 60, 10, 50, kReplyTextViewHeight)];
    btn.backgroundColor = HMColor(148, 191, 54);
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:@"回复" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 8.0f;
    [btn addTarget:self action:@selector(replyMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.replyBar addSubview:btn];
    self.replyBtn = btn;
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectOffset(self.replayTextView.frame, 5, 0)];
    lb.textColor = [UIColor lightGrayColor];
    lb.font = [UIFont systemFontOfSize:15];
    lb.text = @"回复:楼主";
    [self.replyBar addSubview:lb];
    self.replyPlaceholdeLb = lb;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 1)];
    line.backgroundColor = HMColor(235, 235, 235);
    [self.replyBar addSubview:line];
    
    //默认回复楼主
    self.replyCommentIdx = nil;
}

- (void)setupNaviBar
{
    self.navigationItem.title = @"";
    
    UIImage *img = [UIImage imageNamed:@"titlebar_delete"];
    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *delItem = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(delItemClick:)];
    
    img = [UIImage imageNamed:@"title_share_icon_normal"];
    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(shareItemClick:)];
    
    authorBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 25)];
    [authorBtn setTitle:@"楼主" forState:UIControlStateNormal];
    authorBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    authorBtn.layer.cornerRadius = 5.0f;
    authorBtn.layer.borderColor = HMColor(198, 150, 102).CGColor;
    authorBtn.layer.borderWidth = 1.0f;
    
    [authorBtn setTitleColor:HMColor(198, 150, 102) forState:UIControlStateNormal];
    [authorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [authorBtn setBackgroundColor:[UIColor whiteColor]];
    
    [authorBtn addTarget:self action:@selector(authorItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *authorItem = [[UIBarButtonItem alloc] initWithCustomView:authorBtn];
    
    // 只能删除自己的帖子
    if ([SharedAppUtil defaultCommonUtil].bbsVO && [[SharedAppUtil defaultCommonUtil].bbsVO.BBS_Member_id isEqualToString:self.itemdata.authorid])
    {
        self.navigationItem.rightBarButtonItems = @[delItem,shareItem,authorItem];
    }
    else
    {
        self.navigationItem.rightBarButtonItems = @[shareItem,authorItem];
    }
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
    return self.commentDatas.count + 1;
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
    
    return [self tableView:self.tableview cellForRowAtIndexPath:indexPath].height;
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
    __weak typeof (self) weakSelf = self;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        PostsDetailUserCell *cell = [PostsDetailUserCell createCellWithTableView:tableView];
        cell.postsDetailData = self.detailData;
        cell.attentionBlock = ^{
            [weakSelf attentionAction];
        };
        cell.portraitClickBlock = ^(NSString *authorId){
            PublicProfileViewController *view = [[PublicProfileViewController alloc] init];
            view.uid = authorId;
            [weakSelf.navigationController pushViewController:view animated:YES];
        };
        
        return cell;
        
    }else if (indexPath.section == 0 && indexPath.row == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sss"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"sss"];
            
            _webView = [[UIWebView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 10)];
            _webView.delegate = self;
            _webView.scrollView.bounces = NO;
            _webView.scrollView.showsHorizontalScrollIndicator = NO;
            _webView.backgroundColor  = [UIColor redColor];
            _webView.scrollView.scrollEnabled = NO;
            [_webView sizeToFit];
            [cell addSubview:_webView];
            
            if (self.detailData)
                [self showInWebView];
        }
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 2){
        PostsDetailDZCell *cell = [PostsDetailDZCell createCellWithTableView:tableView];
        cell.postsDetailData = self.detailData;
        cell.dianZanBlock = ^{
            [weakSelf supportAction];
        };
        return cell;
        
    }else if (indexPath.section == 1 && indexPath.row == 0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleCell"];
            cell.textLabel.textColor = HMColor(153, 153, 153);
            cell.textLabel.font = [UIFont systemFontOfSize:14];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"评论数 %@",self.itemdata.replies];
        return cell;
    }
    else{
        PostsCommentCell *cell = [PostsCommentCell createCellWithTableView:tableView];
        
        if (self.commentDatas.count > 0)
        {
            CommentModel *model = self.commentDatas[indexPath.row - 1];
            cell.commentModel = model;
        }
        
        cell.indexpath = indexPath;
        cell.dianZanBlock = ^(NSIndexPath *idx){
            [weakSelf support_replyAction:idx];
        };
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row != 0) {
        self.replyCommentIdx = indexPath;
        CommentModel *model = self.commentDatas[indexPath.row - 1];
        self.replyPlaceholdeLb.text = [NSString stringWithFormat:@"回复:%@",model.author];
        self.replayTextView.text = nil;
        self.replyPlaceholdeLb.hidden = NO;
        [self.replayTextView becomeFirstResponder];
    }
    
}

#pragma mark - 拼接html语言
- (void)showInWebView
{
    NSString *HtmlString = [self touchBody];
    
    CX_Log(@"开始加载html");

    NSString *tempPath = [[NSBundle mainBundle]pathForResource:@"temp" ofType:@"html"];
    
    NSString *tempHtml = [NSString stringWithContentsOfFile:tempPath encoding:NSUTF8StringEncoding error:nil];
    CX_Log(@"结束加载html");

    tempHtml = [tempHtml stringByReplacingOccurrencesOfString:@"{{Content_holder}}" withString:HtmlString];
    
    NSString *basePath = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:basePath];
    
    CX_Log(@"开始loadHTMLString");

    [_webView loadHTMLString:tempHtml baseURL:baseURL];
}

- (NSString *)touchBody
{
    CX_Log(@"开始加载body");
    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"<div class=\"title\">%@</div>",self.detailData.subject];
    
    [body appendFormat:@"<div class=\"time\"><span style=\"display: inline-block;line-height: 20px;height: 20px;\">%@</span><div style=\"height: 20px;padding-left: 3px;padding-right: 3px;display: inline-block;padding-top: 5px;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <img width=\"16\" height=\"10\" src=\"%@\">&nbsp;%@</div><div style=\"float: right;height: 20px;padding-left: 3px;padding-right: 3px;display: inline-block;background: #fbf8f5;border: 1px solid F0EAE5;border-radius: 4px;padding-top: 2px;\"><img width=\"12\" height=\"12\" src=\"%@\"> &nbsp;%@</div><div style=\"clear: both;\"></div></div>",self.detailData.dateline,[[NSBundle mainBundle] URLForResource:@"yd_icon.png" withExtension:nil],self.detailData.views,[[NSBundle mainBundle] URLForResource:@"qz_icon.png" withExtension:nil],self.detailData.forum_name];
    
    [body appendFormat:@"<div id=\"myid\" class=\"message\">%@</div>",self.detailData.message];

    // 遍历img
    for (DetailImgModel *detailImgModel in self.detailData.img) {
        NSMutableString *imgHtml = [NSMutableString string];
        
        // 设置img的div
        [imgHtml appendString:@"<div class=\"img-parent\">"];
        
        // 数组存放被切割的像素
        NSArray *pixel = [detailImgModel.pixel componentsSeparatedByString:@"*"];
        CGFloat width = [[pixel firstObject]floatValue];
        CGFloat height = [[pixel lastObject]floatValue];
        // 判断是否超过最大宽度
        CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width * 0.96;
        if (width > maxWidth) {
            height = maxWidth / width * height;
            width = maxWidth;
        }
        
        NSString *onload = @"this.onclick = function() {"
        "  window.location.href = 'sx:src=' +this.src;"
        "};";
        [imgHtml appendFormat:@"<img onload=\"%@\" width=\"%f\" height=\"%f\" data-original=\"%@\">",onload,width,height,detailImgModel.src];
        // 结束标记
        [imgHtml appendString:@"</div>"];
        // 替换标记
        [body replaceOccurrencesOfString:detailImgModel.ref withString:imgHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
    }
    CX_Log(@"结束加载body");

    return body;
}


#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CX_Log(@"结束loadHTMLString");
    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
    CGRect newFrame = webView.frame;
    newFrame.size.height = actualSize.height;
    webView.frame = newFrame;
    cellHeight = newFrame.size.height;
    
    [palceView removeFromSuperview];
    [self.tableview reloadData];
}

#pragma mark - ******************* 将发出通知时调用
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    NSRange range = [url rangeOfString:@"sx:src="];
    if (range.location != NSNotFound) {
        NSInteger begin = range.location + range.length;
        NSString *src = [url substringFromIndex:begin];
        [self imgageClick:src];
        return NO;
    }
    return YES;
}

#pragma mark - ******************** 图片点击方法
- (void)imgageClick:(NSString *)src
{
    CX_Log(@"点击图片");
    
    NSInteger currentIdx = 0;
    NSMutableArray *arr= [[NSMutableArray alloc] init];
    for (DetailImgModel *item in self.detailData.img)
    {
        if ([src isEqualToString:item.src] )
        {
            currentIdx = [self.detailData.img indexOfObject:item];
        }
        [arr addObject:item.src];
    }
    
    SWYPhotoBrowserViewController *photoBrowser = [[SWYPhotoBrowserViewController alloc] initPhotoBrowserWithImageURls:[arr copy] currentIndex:currentIdx placeholderImageNmae:@"advplaceholderImage"];
    [self.navigationController presentViewController:photoBrowser animated:YES completion:nil];
}


#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat replayTextHeight = textView.contentSize.height;
    
    if (replayTextHeight < kReplyTextViewHeight) {
        replayTextHeight = kReplyTextViewHeight;
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
    
    //设置Placeholde文本
    if (textView.text.length <=0) {
        self.replyPlaceholdeLb.hidden = NO;
    }else{
        self.replyPlaceholdeLb.hidden = YES;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.replayTextView.text.length <= 0) {
        self.replyPlaceholdeLb.text = @"回复:楼主";
        self.replyCommentIdx = nil;
    }
    
    [self.view endEditing:YES];
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
        self.tableview.frame = tableFrame;
        self.replyBar.frame = replyBarFrame;
    } completion:^(BOOL finished) {
        if (self.replyCommentIdx) {   //存在,说明是对评论进行回复,让该条评论可见
            [self.tableview scrollToRowAtIndexPath:self.replyCommentIdx atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
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
        self.tableview.frame = tableFrame;
        self.replyBar.frame = replyBarFrame;
    }];
}

#pragma mark - 网络相关

-(UIView *)getPalceView
{
    palceView = [[UIView alloc] initWithFrame:self.view.bounds];
    palceView.backgroundColor = [UIColor whiteColor];
    
    // 添加转圈圈
    UIActivityIndicatorView *av =[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
    av.center=self.view.center;
    [av setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [av setBackgroundColor:[UIColor whiteColor]];
    [av startAnimating];
    [palceView addSubview:av];
    
    return palceView;
}

/**
 *  获取帖子详情数据
 */
-(void)getDetailData
{
    [self.view addSubview:[self getPalceView]];
    CX_Log(@"开始加载帖子详情");
    
    NSMutableDictionary *params = [@{@"tid" : self.itemdata.tid,
                                     @"client":@"ios"
                                     }mutableCopy];
    params[ @"key"] = [SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key;
    
    [CommonRemoteHelper RemoteWithUrl:URL_Get_articledetail parameters:params
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     CX_Log(@"帖子详情加载完成");
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum integerValue] > 0)
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:kNoPostsPrompt delegate:self cancelButtonTitle:@"返回" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         self.detailData = [DetailPostsModel objectWithKeyValues:[dict objectForKey:@"datas"]];
                                         [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [NoticeHelper AlertShow:@"网络出错,请重试" view:nil];
                                 }];
}

/**
 *  加关注与取消关注，add是加关注，del是取消关注
 */
- (void)attentionAction
{
    //判断是否登录
    if (![SharedAppUtil checkLoginStates]) {
        return;
    }
    
    NSString *type = @"add";
    if ([self.detailData.is_home_friend integerValue] != 0) {
        type = @"del";
    }
    
    NSDictionary *params = @{
                             @"action":type,
                             @"uid": [SharedAppUtil defaultCommonUtil].bbsVO.BBS_Member_id,
                             @"rel":self.detailData.authorid,
                             @"client":@"ios",
                             @"key":[SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key
                             };
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Get_attention_do parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
        [HUD removeFromSuperview];
        id codeNum = [dict objectForKey:@"code"];
        if([codeNum integerValue] > 0)//如果返回的是NSString 说明有错误
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        else
        {
            if ([type isEqualToString:@"add"]) {
                self.detailData.is_home_friend = @"1";
            }else{
                self.detailData.is_home_friend = @"0";
            }
            
            NSString *str = [[dict objectForKey:@"datas"] objectForKey:@"message"];
            [NoticeHelper AlertShow:str view:nil];
            [self.tableview reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD removeFromSuperview];
        [NoticeHelper AlertShow:@"请求出错了" view:nil];
    }];
}

/**
 *  点赞帖子
 */
- (void)supportAction
{
    //判断是否登录
    if (![SharedAppUtil checkLoginStates]) {
        return;
    }
    
    //目前只能点赞,不能取消
    NSString *doType = @"add";
    if ([self.detailData.is_recommend integerValue] != 0) {
        return [NoticeHelper AlertShow:@"您已点赞" view:nil];
    }
    
    NSDictionary *params = @{
                             @"uid": [SharedAppUtil defaultCommonUtil].bbsVO.BBS_Member_id,
                             @"tid":self.detailData.tid,
                             @"dowhat":doType,
                             @"client":@"ios",
                             @"key":[SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key
                             };
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Get_support_thread parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
        [HUD removeFromSuperview];
        id codeNum = [dict objectForKey:@"code"];
        if([codeNum integerValue] > 0)//如果返回的是NSString 说明有错误
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        else
        {
            if ([doType isEqualToString:@"add"]) {
                self.detailData.is_recommend = @"1";
            }else{
                self.detailData.is_recommend = @"0";
            }
            
            self.detailData.count_recommend = dict[@"datas"][@"recommend_add"];
            
            NSString *str = [[dict objectForKey:@"datas"] objectForKey:@"message"];
            [NoticeHelper AlertShow:str view:nil];
            [self.tableview reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD removeFromSuperview];
        [NoticeHelper AlertShow:@"请求出错了" view:nil];
    }];
}

/**
 *  点赞评论
 */
- (void)support_replyAction:(NSIndexPath *)idx
{
    //判断是否登录
    if (![SharedAppUtil checkLoginStates]) {
        return;
    }
    
    CommentModel *model = self.commentDatas[idx.row - 1];
    
    NSString *doType = @"against";
    if ([model.is_support isEqualToString:@"0"]) {
        doType = @"support";
    }
    
    NSDictionary *params = @{
                             @"tid":self.detailData.tid,
                             @"pid":model.pid,
                             @"uid": [SharedAppUtil defaultCommonUtil].bbsVO.BBS_Member_id,
                             @"dowhat":doType,
                             @"client":@"ios",
                             @"key":[SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key
                             };
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Support_reply parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
        [HUD removeFromSuperview];
        id codeNum = [dict objectForKey:@"code"];
        if([codeNum integerValue] > 0)//如果返回的是NSString 说明有错误
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        else
        {
            NSString *type = dict[@"datas"][@"dowhat"];
            if ([type isEqualToString:@"support"]) {
                model.is_support = @"1";
            }else{
                model.is_support = @"0";
            }
            
            model.support = dict[@"datas"][@"support"];
            [self.tableview reloadData];
            
            [self addheats];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD removeFromSuperview];
        [NoticeHelper AlertShow:@"请求出错了" view:nil];
    }];
}

- (void)loadCommonlist
{
    NSMutableDictionary *params = [@{@"host" : authorBtn.selected ? @"1" : @"0",
                                     @"tid":self.itemdata.tid,
                                     @"p":@(self.pageNum),
                                     @"page":@10,
                                     @"client":@"ios", }mutableCopy];
    params[@"key"] =  [SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key;
    
    [CommonRemoteHelper RemoteWithUrl:URL_Get_Commonlist parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
        [self.tableview.footer endRefreshing];
        
        id codeNum = [dict objectForKey:@"code"];
        if([codeNum integerValue] > 0)//如果返回的是NSString 说明有错误
        {
            if ([codeNum integerValue] == 17001)
            {
                [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
                return CX_Log(@"评论数据为空");
            }
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        else
        {
            
            NSArray *arr = [CommentModel objectArrayWithKeyValuesArray:dict[@"datas"]];
            if (arr.count > 0) {
                [self.commentDatas addObjectsFromArray:arr];
                [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
                self.pageNum++;
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableview.footer endRefreshing];
        [NoticeHelper AlertShow:@"请求出错了" view:nil];
    }];
    
}

/**
 *  评论帖子或评论帖子的评论
 */
- (void)reply_post:(NSDictionary *)params
{
    [self.view endEditing:YES];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Reply_post parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
        [HUD removeFromSuperview];
        id codeNum = [dict objectForKey:@"code"];
        if([codeNum integerValue] > 0)//如果返回的是NSString 说明有错误
        {
            if ([codeNum integerValue] == 17001 && self.commentDatas.count > 0)
            {
                return [self.tableview showNonedataTooltip];
            }
            else if ([codeNum integerValue] == 17001)
            {
                return CX_Log(@"评论数据为空");
            }
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        else
        {
            [NoticeHelper AlertShow:dict[@"datas"][@"message"] view:nil];
            
            //恢复回复工具栏大小
            self.replayTextView.text = nil;
            self.replyPlaceholdeLb.hidden = NO;
            self.replyBar.frame = CGRectMake(0, MTScreenH - kReplyBarHeight, MTScreenW, kReplyBarHeight);
            self.replayTextView.frame = CGRectMake(10, 10, MTScreenW - 80, kReplyTextViewHeight);
            self.tableview.frame = CGRectMake(0, 0, MTScreenW, MTScreenH - kReplyBarHeight);
            
            //重新获取评论
            self.pageNum = 1;
            [self.commentDatas removeAllObjects];
            [self loadCommonlist];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD removeFromSuperview];
        [NoticeHelper AlertShow:@"请求出错了" view:nil];
    }];
}

- (void)replyMessage:(UIButton *)sender
{
    //判断是否登录
    if (![SharedAppUtil checkLoginStates]) {
        return;
    }
    
    NSString *replyContent = self.replayTextView.text;
    if (replyContent.length < 1) {
        return [NoticeHelper AlertShow:@"请输入评价内容" view:nil];
    }
    
    NSMutableDictionary *params = nil;
    if (self.replyCommentIdx) { //说明是对评论进行回复
        CommentModel *model = self.commentDatas[self.replyCommentIdx.row - 1];
        params = [@{
                    @"tid":self.detailData.tid,
                    @"uid": [SharedAppUtil defaultCommonUtil].bbsVO.BBS_Member_id,
                    @"message":self.replayTextView.text,
                    @"reppid":model.pid,
                    @"replyname":model.author,
                    @"replytime":model.dateline,
                    @"authorid":model.authorid,
                    @"client":@"ios",
                    @"key":[SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key
                    }mutableCopy];
        
        NSUInteger location = model.commen.newcommon.length < 50?model.commen.newcommon.length:50;
        params[@"replyquote"] = [model.commen.newcommon substringToIndex:location];
    }else{
        params = [@{
                    @"fid":self.detailData.fid,
                    @"tid":self.detailData.tid,
                    @"uid": [SharedAppUtil defaultCommonUtil].bbsVO.BBS_Member_id,
                    @"message":self.replayTextView.text,
                    @"authorid":self.detailData.authorid,
                    @"client":@"ios",
                    @"key":[SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key
                    }mutableCopy];
    }
    
    [self.view endEditing:YES];
    [self reply_post:params];
}

/**
 *  下拉刷新
 */
- (void)loadMoreDatas
{
    [self loadCommonlist];
}

#pragma mark - 导航栏事件
- (void)delItemClick:(UINavigationItem *)item
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定删除该帖子，删除后将无法恢复" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"确定",nil];
    [alertView show];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSDictionary *params = @{@"tid":self.detailData.tid,
                                 @"client":@"ios",
                                 @"key":[SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key};
        
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [CommonRemoteHelper RemoteWithUrl:URL_Get_delete_thread parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
            
            [HUD removeFromSuperview];
            id codeNum = [dict objectForKey:@"code"];
            if([codeNum integerValue] > 0)//如果返回的是NSString 说明有错误
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
            }
            else
            {
                if (self.deletePostsSuccessBlock) {
                    self.deletePostsSuccessBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [HUD removeFromSuperview];
            [NoticeHelper AlertShow:@"请求出错了" view:nil];
        }];
    }
    
    //找不到帖子时
    if ([alertView.message isEqualToString:kNoPostsPrompt]) {
        if (self.deletePostsSuccessBlock) {
            self.deletePostsSuccessBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}



/**
 *  分享文章
 */
- (void)shareItemClick:(UINavigationItem *)item
{
    NSString * url = self.detailData.share_url;
    NSString *str = self.detailData.avatar;
    NSArray* imageArray = @[str];
    
    if (imageArray) {
        //1、创建分享参数（必要）
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:self.detailData.message
                                         images:imageArray
                                            url:[NSURL URLWithString:url]
                                          title:self.detailData.subject
                                           type:SSDKContentTypeAuto];
        // 定制微信好友的分享内容
        [shareParams SSDKSetupWeChatParamsByText:self.detailData.jiequmessage title:self.detailData.subject url:[NSURL URLWithString:url] thumbImage:nil image:[UIImage imageNamed:str] musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];// 微信好友子平台
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:@[
                                         // 不要使用微信总平台进行初始化
                                         @(SSDKPlatformTypeQQ),
                                         @(SSDKPlatformSubTypeWechatSession),
                                         @(SSDKPlatformSubTypeWechatTimeline),
                                         ]
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               [self addheats];

                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
}


// 只看楼主
- (void)authorItemClick:(UIButton *)item
{
    item.selected = !item.selected;
    if (item.selected)
    {
        [item setBackgroundColor:HMColor(198, 150, 102)];
        [NoticeHelper AlertShow:@"只看楼主" view:nil];
    }
    else
    {
        [item setBackgroundColor:[UIColor whiteColor]];
        [NoticeHelper AlertShow:@"查看全部" view:nil];
    }
    
    [self.commentDatas removeAllObjects];
    self.pageNum = 1;
    [self loadCommonlist];
}

/**
 *  增加帖子热度
 */
- (void)addheats
{
    //判断是否登录
    if ([SharedAppUtil defaultCommonUtil].userVO == nil)
        return ;
    else if ([SharedAppUtil defaultCommonUtil].bbsVO == nil)
        return ;
    
    NSDictionary *params = @{@"tid":self.detailData.tid,
                             @"client":@"ios",
                             @"key":[SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key};
    
    [CommonRemoteHelper RemoteWithUrl:URL_Addheats parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
        id codeNum = [dict objectForKey:@"code"];
        if([codeNum integerValue] > 0)//如果返回的是NSString 说明有错误
        {
            return CX_Log(@"评论数据为空");
        }
        else
        {
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [NoticeHelper AlertShow:@"请求出错了" view:nil];
    }];
}

@end
