//
//  SystemViewController.m
//  GPSNavDemo
//
//  Created by 董徐维 on 15/3/10.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "ProfileViewController.h"


#import "AboutViewController.h"
#import "FamilyViewController.h"
#import "SettingViewController.h"
#import "OrderTableViewController.h"
#import "AccountViewController.h"
#import "PersonalDataViewController.h"
#import "LoginViewController.h"
#import "GoodsHeadViewController.h"
#import "ClassificationViewController.h"
#import "GoodsTableViewController.h"
#import "ConfirmViewController.h"
#import "MTCouponsViewController.h"
#import "AddressTableViewController.h"
#import "GoodsViewController.h"
#import "GoodsTypeViewController.h"
#import "MyMesageViewController.h"

#import "BalanceViewController.h"


#define imageHeight 140

@interface ProfileViewController ()


@end

@implementation ProfileViewController
{
    NSURL *iconUrl;
    NSString *username;
    NSString *key;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self initTableviewSkin];
    
    [self setupGroups];
    
    //    清除图片缓存
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    
    username = [SharedAppUtil defaultCommonUtil].userVO.member_id;
    key = [SharedAppUtil defaultCommonUtil].userVO.key;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getUserIcon];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)checkLogin
{
    LoginViewController *login = [[LoginViewController alloc] init];
    login.backHiden = YES;
    [self.navigationController pushViewController:login animated:NO];
}

#pragma mark 初始化界面

/**
 *  设置tableView属性
 */
-(void)initTableviewSkin
{
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionFooterHeight = HMStatusCellMargin;
    self.tableView.sectionHeaderHeight = 0;
    //上左下右的值
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    
    //添加监听者
//    [self.tableView addObserver: self forKeyPath: @"contentOffset" options: NSKeyValueObservingOptionNew context: nil];
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.title = @"我的";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _zoomImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headbg.png"]];
    _zoomImageview.frame = CGRectMake(0, 0, self.view.width, imageHeight - 20);
    //高度改变 宽度也跟着改变
    //    _zoomImageview.contentMode = UIViewContentModeScaleAspectFill;
    self.tableView.tableHeaderView = _zoomImageview;
    
    [_zoomImageview setUserInteractionEnabled:YES];//使添加其上的button有点击事件
    
    //设置autoresizesSubviews让子类自动布局
    _zoomImageview.autoresizesSubviews = YES;
    
    _iconImageview = [[UIImageView alloc]initWithFrame:CGRectMake((MTScreenW - 80)/2, 30, 80, 80)];
    _iconImageview.clipsToBounds = YES;
    _iconImageview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
    [_iconImageview sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
    _iconImageview.layer.cornerRadius = _iconImageview.height/2;
    _iconImageview.layer.masksToBounds = YES;
    [_zoomImageview addSubview:_iconImageview];
}

# pragma  mark 设置数据源
/**
 *  初始化模型数据
 */
- (void)setupGroups
{
    //每次刷新数据源的时候需要将数据源清空
    [self.groups removeAllObjects];
    
    //重置数据源
    [self setupGroup0];
    [self setupGroup10];
    [self setupGroup5];
    [self setupFooter];
    
    //刷新表格
    [self.tableView reloadData];
}

- (void)setupFooter
{
    // 1.创建按钮
    UIButton *logout = [[UIButton alloc] init];
    
    // 2.设置属性
    logout.titleLabel.font = [UIFont systemFontOfSize:16];
    [logout setTitle:@"退出当前帐号" forState:UIControlStateNormal];
    [logout setTitleColor:HMColor(255, 10, 10) forState:UIControlStateNormal];
    [logout setBackgroundImage:[UIImage resizedImage:@"common_card_background"] forState:UIControlStateNormal];
    [logout setBackgroundImage:[UIImage resizedImage:@"common_card_background_highlighted"] forState:UIControlStateHighlighted];
    [logout addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    
    // 3.设置尺寸(tableFooterView和tableHeaderView的宽度跟tableView的宽度一样)
    logout.height = 50;
    self.tableView.tableFooterView = logout;
}

- (void)setupGroup0
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    HMCommonArrowItem *myData = [HMCommonArrowItem itemWithTitle:@"个人资料" icon:@"pc_user.png"];
    myData.destVcClass = [BalanceViewController class];
    
    HMCommonArrowItem *newFriend = [HMCommonArrowItem itemWithTitle:@"我的优惠券" icon:@"pc_accout.png"];
    newFriend.destVcClass = [MTCouponsViewController class];
    
    HMCommonArrowItem *offline = [HMCommonArrowItem itemWithTitle:@"我的亲友" icon:@"pc_family.png"];
    offline.destVcClass = [FamilyViewController class];

    group.items = @[myData,newFriend,offline];
}

- (void)setupGroup1
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    HMCommonArrowItem *newFriend = [HMCommonArrowItem itemWithTitle:@"我的优惠券" icon:@"pc_accout.png"];
    
    newFriend.destVcClass = [MTCouponsViewController class];
    
    group.items = @[newFriend];
    
}

- (void)setupGroup2
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    HMCommonArrowItem *newFriend;
    // 2.设置组的所有行数据
    newFriend = [HMCommonArrowItem itemWithTitle:@"我的服务" icon:@"pc_service.png"];
    newFriend.destVcClass = [OrderTableViewController class];
    group.items = @[newFriend];
}


- (void)setupGroup3
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    HMCommonArrowItem *collect = [HMCommonArrowItem itemWithTitle:@"关于APP" icon:@"app.png"];
    collect.destVcClass = [AboutViewController class];
    group.items = @[collect];
}

- (void)setupGroup4
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    HMCommonArrowItem *offline = [HMCommonArrowItem itemWithTitle:@"我的亲友" icon:@"pc_family.png"];
    offline.destVcClass = [FamilyViewController class];
    group.items = @[offline];
}

- (void)setupGroup5
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    HMCommonArrowItem *album = [HMCommonArrowItem itemWithTitle:@"系统设置" icon:@"pc_setup.png"];
    album.destVcClass = [SettingViewController class];
    
    // 2.设置组的所有行数据
    HMCommonArrowItem *collect = [HMCommonArrowItem itemWithTitle:@"关于APP" icon:@"app.png"];
    collect.destVcClass = [AboutViewController class];
    
    group.items = @[album,collect];
}

- (void)setupGroup10
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    HMCommonArrowItem *car = [HMCommonArrowItem itemWithTitle:@"我的商品" icon:@"shop_selected.png"];
    car.destVcClass = [GoodsTypeViewController class];
    
    
    HMCommonArrowItem *newFriend = [HMCommonArrowItem itemWithTitle:@"我的服务" icon:@"pc_service.png"];
    newFriend.destVcClass = [OrderTableViewController class];
    
    HMCommonArrowItem *msg = [HMCommonArrowItem itemWithTitle:@"我的消息" icon:@"ic_msg.png"];
    msg.destVcClass = [ MyMesageViewController class];
    
    group.items = @[newFriend,car,msg];
}


# pragma  mark 退出当前账号

-(void)loginOut
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"确定退出当前账号？"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:@"确定"
                                                    otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [CommonRemoteHelper RemoteWithUrl:URL_Logout parameters: @{@"id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                                                                   @"client" : @"ios",
                                                                   @"key" : [SharedAppUtil defaultCommonUtil].userVO.key}
                                     type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                         [HUD removeFromSuperview];
                                         id codeNum = [dict objectForKey:@"code"];
                                         if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                         {
                                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                             [alertView show];
                                         }
                                         else
                                         {
                                             [SharedAppUtil defaultCommonUtil].userVO = nil;
                                             [ArchiverCacheHelper saveObjectToLoacl:[SharedAppUtil defaultCommonUtil].userVO key:User_Archiver_Key filePath:User_Archiver_Path];
                                             
                                             [MTControllerChooseTool setloginOutViewController];
                                         }
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"发生错误！%@",error);
                                         [HUD removeFromSuperview];
                                         [self.view endEditing:YES];
                                         [MTControllerChooseTool setRootViewController];
                                     }];
    }
}

/**
 * 清空手机端访问网页的cookie
 **/
-(void)clearCookies
{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
}

#pragma mark -- 与后台数据交互模块
/**
 *  获取数据
 */
-(void)getUserIcon
{
    if ([SharedAppUtil defaultCommonUtil].userVO == nil)
        return;
    [CommonRemoteHelper RemoteWithUrl:URL_GetUserInfor parameters: @{@"id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                                                                     @"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                     @"client" : @"ios"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         NSDictionary *di = [dict objectForKey:@"datas"];
                                         if ([di count] != 0)
                                         {
                                             NSString *url = (NSString*)[di objectForKey:@"member_avatar"];
                                             iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Icon,url]];
                                         }
                                         [_iconImageview sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.view endEditing:YES];
                                 }];
}

@end
