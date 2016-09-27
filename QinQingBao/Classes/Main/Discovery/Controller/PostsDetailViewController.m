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

@interface PostsDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,UITextViewDelegate,UIScrollViewDelegate>
{
    UIWebView *_webView;
    
    CGFloat cellHeight;
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
    
    self.pageNum = 1;
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH - 60) style:UITableViewStylePlain];
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
    self.replyBar = [[UIView alloc] initWithFrame:CGRectMake(0, MTScreenH - 54, MTScreenW, 54)];
    self.replyBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.replyBar];
    
    UITextView *txtView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, MTScreenW - 80, 34)];
    txtView.layer.borderColor = HMColor(235, 235, 235).CGColor;
    txtView.layer.borderWidth = 1.0f;
    txtView.layer.cornerRadius = 8.0f;
    txtView.delegate = self;
    txtView.font = [UIFont systemFontOfSize:15];
    [self.replyBar addSubview:txtView];
    self.replayTextView = txtView;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(MTScreenW - 60, 10, 50, 34)];
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
    UIImage *img = [UIImage imageNamed:@"titlebar_delete"];
    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *delItem = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(delItemClick:)];
    
    img = [UIImage imageNamed:@"title_share_icon_normal"];
    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(shareItemClick:)];
    
    UIButton *authorBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 25)];
    [authorBtn setTitle:@"楼主" forState:UIControlStateNormal];
    authorBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    authorBtn.layer.cornerRadius = 5.0f;
    authorBtn.layer.borderColor = HMColor(198, 150, 102).CGColor;
    authorBtn.layer.borderWidth = 1.0f;
    [authorBtn setTitleColor:HMColor(198, 150, 102) forState:UIControlStateNormal];
    [authorBtn addTarget:self action:@selector(authorItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *authorItem = [[UIBarButtonItem alloc] initWithCustomView:authorBtn];
    self.navigationItem.rightBarButtonItems = @[delItem,shareItem,authorItem];
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
            
            if (self.detailData)
                [self showInWebView];
        }
        cell.textLabel.text = @"add";
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
        cell.textLabel.text = [NSString stringWithFormat:@"评论数 %@",@8];
        return cell;
    }
    else{
        PostsCommentCell *cell = [PostsCommentCell createCellWithTableView:tableView];
        
        CommentModel *model = self.commentDatas[indexPath.row - 1];
        cell.commentModel = model;
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
    [body appendFormat:@"<div class=\"title\">%@</div>",self.detailData.subject];
    [body appendFormat:@"<div class=\"time\">%@ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img width=\"16\" height=\"10\" src=\"%@\"> %@ </div>",self.detailData.dateline,[[NSBundle mainBundle] URLForResource:@"yd_icon.png" withExtension:nil],self.detailData.views];
    [body appendString:self.detailData.message];
    
    
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
        [imgHtml appendFormat:@"<img onload=\"%@\" width=\"%f\" height=\"%f\" src=\"%@\">",onload,width,height,detailImgModel.src];
        // 结束标记
        [imgHtml appendString:@"</div>"];
        // 替换标记
        [body replaceOccurrencesOfString:detailImgModel.ref withString:imgHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
    }
    return body;
}


#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
    CGRect newFrame = webView.frame;
    newFrame.size.height = actualSize.height;
    webView.frame = newFrame;
    
    cellHeight = newFrame.size.height;
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
    
    SWYPhotoBrowserViewController *photoBrowser = [[SWYPhotoBrowserViewController alloc] initPhotoBrowserWithImageURls:[arr copy] currentIndex:currentIdx placeholderImageNmae:@"placeholderImage"];
    [self.navigationController presentViewController:photoBrowser animated:YES completion:nil];
}


#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat replayTextHeight = textView.contentSize.height;
    
    if (replayTextHeight < 34) {
        replayTextHeight = 34;
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
/**
 *  获取帖子详情数据
 */
-(void)getDetailData
{
    [CommonRemoteHelper RemoteWithUrl:URL_Get_articledetail parameters: @{@"tid" : @13,
                                                                          @"client":@"ios",
                                                                          @"key" : [SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key ?  [SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key : @"" }
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         self.detailData = [DetailPostsModel objectWithKeyValues:[dict objectForKey:@"datas"]];
                                         [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                 }];
}

/**
 *  加关注与取消关注，add是加关注，del是取消关注
 */
- (void)attentionAction
{
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

- (void)supportAction
{
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
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD removeFromSuperview];
        [NoticeHelper AlertShow:@"请求出错了" view:nil];
    }];
}

- (void)loadCommonlist
{
    NSDictionary *params = @{
                             @"tid":self.itemdata.tid,
                             @"p":@(self.pageNum),
                             @"page":@5,
                             @"client":@"ios",
                             @"key":[SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key
                             };
    
    [CommonRemoteHelper RemoteWithUrl:URL_Get_Commonlist parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {

        [self.tableview.footer endRefreshing];
        
        id codeNum = [dict objectForKey:@"code"];
        if([codeNum integerValue] > 0)//如果返回的是NSString 说明有错误
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        else
        {
            
            NSArray *arr = [CommentModel objectArrayWithKeyValuesArray:dict[@"datas"]];
            [self.commentDatas addObjectsFromArray:arr];
            [self.tableview reloadData];
            self.pageNum++;
            
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
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Reply_post parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {

        [HUD removeFromSuperview];
        id codeNum = [dict objectForKey:@"code"];
        if([codeNum integerValue] > 0)//如果返回的是NSString 说明有错误
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        else
        {
           
            
            [NoticeHelper AlertShow:dict[@"datas"][@"message"] view:nil];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD removeFromSuperview];
        [NoticeHelper AlertShow:@"请求出错了" view:nil];
    }];
}

- (void)replyMessage:(UIButton *)sender
{
    NSString *replyContent = self.replayTextView.text;
    if (replyContent.length < 10) {
        return [NoticeHelper AlertShow:@"评价字数不得小于10个" view:nil];
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
    NSDictionary *params = @{
                             @"tid":self.detailData.tid,
                             @"client":@"ios",
                             @"key":[SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key
                             };
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Delete_thread parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
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
            [self.navigationController popToViewController:self animated:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD removeFromSuperview];
        [NoticeHelper AlertShow:@"请求出错了" view:nil];
    }];
}

- (void)shareItemClick:(UINavigationItem *)item
{
    
}

- (void)authorItemClick:(UIButton *)item
{
    
}

@end
