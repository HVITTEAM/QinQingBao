//
//  SendMsgViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/9/11.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "SendMsgViewController.h"
#import "SelfmsgCell.h"
#import "OthermsgCell.h"

#import "YCXMenu.h"
#import "BBSPersonalModel.h"
#import "PriletterlistModel.h"

#define contentViewHeight 60

@interface SendMsgViewController ()<UITextViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView * inputContentView;
    UITextView *textfield;
    UITableView *tableview;
    
    NSMutableArray *priletterDatas;
}
@property (nonatomic , strong) NSMutableArray *items;

@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation SendMsgViewController


-(instancetype)init
{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

#pragma mark - setter/getter
- (NSMutableArray *)items {
    if (!_items) {
           _items = [@[[YCXMenuItem menuItem:@"加入黑名单"
                                    image:nil
                                      tag:100
                                 userInfo:nil],
                    [YCXMenuItem menuItem:@"删除聊天记录"
                                    image:nil
                                      tag:101
                                 userInfo:nil],
                    ] mutableCopy];
    }
    return _items;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageNum = 1;
    
    priletterDatas = [[NSMutableArray alloc] init];

    [self loadNotificationCell];
    
    [self initTable];
    
    [self initView];
    
    [self initNavigation];
    
    [self getPrivateletterList];
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [rightBtn addTarget:self action:@selector(navgationHandler) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateHighlighted];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.navigationItem.rightBarButtonItem = rightBarBtn;
}

-(void)navgationHandler
{
    [YCXMenu setTintColor:[UIColor darkGrayColor]];
    [YCXMenu showMenuInView:[UIApplication sharedApplication].keyWindow.rootViewController.view fromRect:CGRectMake(self.view.frame.size.width - 55, self.navigationController.navigationBar.height + 10, 50, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item) {
        NSLog(@"%@",item);
    }];
}

-(void)initTable
{
    tableview = [[UITableView alloc ] initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH - contentViewHeight)];
    tableview.tableFooterView = [[UIView alloc] init];
    tableview.delegate = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.dataSource = self;
    tableview.backgroundColor = HMGlobalBg;
    tableview.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:tableview];
    [tableview setContentOffset:CGPointMake(0, tableview.height) animated:NO];
    __weak typeof(self) weakSelf = self;
    tableview.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadMoreDatas];
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return priletterDatas.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
//    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    return cell.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelfmsgCell *selfcell = [tableView dequeueReusableCellWithIdentifier:@"MTSelfmsgCell"];
    OthermsgCell *othercell = [tableView dequeueReusableCellWithIdentifier:@"MTOthermsgCell"];

    PriletterlistModel *model = priletterDatas[indexPath.row];
    
    if ([[SharedAppUtil defaultCommonUtil].bbsVO.BBS_Member_id isEqualToString:model.authorid])
    {
        if (!selfcell) {
            selfcell = [SelfmsgCell selfmsgCell];
        }
        [selfcell initWithContent:model.message icon:model.avatar];
        return selfcell;
    }
    else
    {
        if (!othercell) {
            othercell = [OthermsgCell othermsgCell];
        }
        [othercell initWithContent:model.message icon:model.avatar];
        return othercell;
    }
}


-(void)initView
{
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share.png"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = self.otherInfo.author;
    
    inputContentView = [[UIView alloc] initWithFrame:CGRectMake(0, MTScreenH - contentViewHeight, MTScreenW, contentViewHeight)];
    inputContentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:inputContentView];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 0.5)];
    topLine.backgroundColor = [UIColor colorWithRGB:@"dddddd"];
    [inputContentView addSubview:topLine];
    
    textfield = [[UITextView alloc] initWithFrame:CGRectMake(20, 10, MTScreenW - 100, 40)];
    textfield.layer.borderWidth = 0.5f;
    textfield.font = [UIFont systemFontOfSize:16];
    textfield.layer.cornerRadius = 6;
    textfield.returnKeyType =UIReturnKeySend;
    textfield.backgroundColor = [UIColor whiteColor];
    textfield.layer.borderColor = [[UIColor colorWithRGB:@"dddddd"] CGColor];
    textfield.delegate = self;
    //    textfield.placeholder  = @"  我来说两句.....";
    [inputContentView addSubview:textfield];
    
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(textfield.frame) + 10, 14, 60, 30)];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitle:@"发送" forState:UIControlStateSelected];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn setBackgroundColor:[UIColor  colorWithRGB:@"94bf36"]];
    sendBtn.layer.cornerRadius = 4;
    [inputContentView addSubview:sendBtn];
    [sendBtn addTarget:self action:@selector(sendPrivateletterAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

#pragma mark - 键盘处理事件

-(void)loadNotificationCell
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    // 根据老的 frame 设定新的 frame
    CGRect newTextViewFrame = inputContentView.frame;
    newTextViewFrame.origin.y = keyboardRect.origin.y - inputContentView.frame.size.height;
    
    CGRect newTableViewFrame = self.view.frame;
    newTableViewFrame.size.height = newTableViewFrame.size.height - keyboardRect.size.height - contentViewHeight;
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    NSValue *animationCurveObject = [userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSUInteger animationCurve;
    [animationCurveObject getValue:&animationCurve];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve];
    inputContentView.frame = newTextViewFrame;
    tableview.frame = newTableViewFrame;
    
    if (priletterDatas.count > 0) {
        [tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:priletterDatas.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }

    [UIView commitAnimations];
}
//键盘消失时的处理，文本输入框回到页面底部。
- (void)keyboardWillHide:(NSNotification *)notification
{
    
    NSDictionary* userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    NSValue *animationCurveObject =[userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSUInteger animationCurve;
    [animationCurveObject getValue:&animationCurve];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve];
    
    CGRect newTextViewFrame = inputContentView.frame;
    newTextViewFrame.origin.y = MTScreenH - inputContentView.frame.size.height;
    inputContentView.frame = newTextViewFrame;

    CGRect newTableViewFrame = self.view.frame;
    newTableViewFrame.size.height = MTScreenH - contentViewHeight;
    tableview.frame = newTableViewFrame;
    if (priletterDatas.count > 0) {
    [tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:priletterDatas.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    [UIView commitAnimations];
}

#pragma mark - 网络相关
/**
 *  获取私信数据
 */
- (void)getPrivateletterList
{
    //判断是否登录
    if (![SharedAppUtil checkLoginStates]) {
        return;
    }
    
    NSDictionary *params = @{
                             @"key":[SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key,
                             @"client":@"ios",
                             @"authorid":self.authorid,
                             @"p": @(self.pageNum),
                             @"page":@"20",
                             };
    [CommonRemoteHelper RemoteWithUrl:URL_Get_priletterlist parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        [tableview.header endRefreshing];
        id codeNum = [dict objectForKey:@"code"];
        if([codeNum integerValue] > 0)//如果返回的是NSString 说明有错误
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        else
        {
            NSArray *ar = [PriletterlistModel objectArrayWithKeyValuesArray:dict[@"datas"]];
            [priletterDatas addObjectsFromArray:ar];
            self.pageNum ++;
            [tableview reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [tableview.header endRefreshing];
        [NoticeHelper AlertShow:@"请求出错了" view:nil];
    }];
}

/**
 *  加载更多数据
 */
- (void)loadMoreDatas
{
    [self getPrivateletterList];
}

/**
 *  发送私信
 */
- (void)sendPrivateletterAction:(UIButton *)sender
{
    //判断是否登录
    if (![SharedAppUtil checkLoginStates]) {
        return;
    }
    
    NSString *msg = textfield.text;
    if (msg.length <= 0) {
        return [NoticeHelper AlertShow:@"请输入内容" view:nil];
    }
    
    NSDictionary *params = @{
                             @"key":[SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key,
                             @"client":@"ios",
                             @"authorid":self.authorid,
                             @"message": msg,
                             };
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Send_priletter parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
        [HUD removeFromSuperview];
        id codeNum = [dict objectForKey:@"code"];
        if([codeNum integerValue] > 0)//如果返回的是NSString 说明有错误
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        else
        {
            [NoticeHelper AlertShow:dict[@"successMsg"] view:nil];
            textfield.text = nil;
            
            //重新获取私信
            self.pageNum = 1;
            [priletterDatas removeAllObjects];
            [self getPrivateletterList];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [NoticeHelper AlertShow:@"请求出错了" view:nil];
    }];
}

@end
