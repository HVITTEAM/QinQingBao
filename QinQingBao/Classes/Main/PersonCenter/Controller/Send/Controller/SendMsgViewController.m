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

#define contentViewHeight 60

@interface SendMsgViewController ()<UITextViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView * inputContentView;
    UITextView *textfield;
    UITableView *tableview;
    
    NSArray *arr;
}
@property (nonatomic , strong) NSMutableArray *items;

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
    
    [self loadNotificationCell];
    
    arr = @[@"Hi",@"你好",@"如果只是静",@"态显示textView的内容为设",@"置的行间距，执行如下代码置的行间距，执行如下代码.快件在【杭州下城集散中心】已装车，准备发往 【杭州西湖兰庭公寓营业点!",@"你好大华十大的d",@"置的行间距，执行如下代码",@"撒的次数a",@"和哈哈哈哈哈哈哈哈哈",@"和你说的爱上对方即可a",@"ableVi是我的",@"那好吧",@"再见",@"bye",@"bye bye"];
    
    [self initTable];
    
    [self initView];
    
    [self initNavigation];
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
    return 15;
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

    if (indexPath.row %2 == 0)
    {
        if (!selfcell) {
            selfcell = [SelfmsgCell selfmsgCell];
        }
        [selfcell initWithContent:arr[indexPath.row] icon:nil];
        return selfcell;
    }
    else
    {
        if (!othercell) {
            othercell = [OthermsgCell othermsgCell];
        }
        [othercell initWithContent:arr[indexPath.row] icon:nil];
        return othercell;
    }
}


-(void)initView
{
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share.png"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"王博士";
    
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
    [tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
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
    [tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];

    [UIView commitAnimations];
}


@end
