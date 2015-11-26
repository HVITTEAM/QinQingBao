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

#import "RootViewController.h"


#define imageHeight 140

@interface ProfileViewController ()


@end

@implementation ProfileViewController
{
    NSURL *iconUrl;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self initTableviewSkin];
    
    //    清除图片缓存
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupGroups];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self getUserIcon];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark 初始化界面

///** 屏蔽tableView的样式 */
//- (id)init
//{
//    return [self initWithStyle:UITableViewStylePlain];
//}

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

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    CGFloat y = scrollView.contentOffset.y;//根据实际选择加不加上NavigationBarHight（44、64 或者没有导航条）
//    if (y < -imageHeight) {
//        CGRect frame = _zoomImageview.frame;
//        frame.origin.y = y;
//        frame.size.height =  -y;//contentMode = UIViewContentModeScaleAspectFill时，高度改变宽度也跟着改变
//        _zoomImageview.frame = frame;
//    }
}


#pragma mark MBTwitterScrollDelegate
-(void) recievedMBTwitterScrollEvent
{
    [self performSegueWithIdentifier:@"showPopover" sender:self];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)index
//设定cell的高度Path
{
    return 50;
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
    [self setupGroup1];
    [self setupGroup2];
    [self setupGroup3];
    [self setupGroup4];
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
    
    HMCommonArrowItem *myData;
    
    // 2.设置组的所有行数据
    myData = [HMCommonArrowItem itemWithTitle:@"个人资料" icon:@"pc_accout.png"];
    myData.destVcClass = [PersonalDataViewController class];
    myData.operation = ^{
    };
    group.items = @[myData];
}

- (void)setupGroup1
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    HMCommonArrowItem *newFriend;
    
    // 2.设置组的所有行数据
    newFriend = [HMCommonArrowItem itemWithTitle:@"我的账号" icon:@"pc_accout.png"];
    newFriend.destVcClass = [AccountViewController class];
    newFriend.operation = ^{
    };
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
    newFriend.operation = ^{
    };
    
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
    HMCommonArrowItem *offline = [HMCommonArrowItem itemWithTitle:@"我的家属" icon:@"pc_family.png"];
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
    group.items = @[album];
}

# pragma  mark 退出当前账号

-(void)loginOut
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"退出登录"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:@"确定退出当前账号？"
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
                                             RootViewController *rootView = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
                                             UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootView];
                                             [self presentViewController:nav animated:NO completion:nil];
                                             //[MTControllerChooseTool setLoginViewController];
                                         }
                                         [HUD removeFromSuperview];
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"发生错误！%@",error);
                                         [HUD removeFromSuperview];
                                         [self.view endEditing:YES];
                                         [MTControllerChooseTool setRootViewController];
                                     }];
        
    }
}

#pragma mark -- 与后台数据交互模块
/**
 *  获取数据
 */
-(void)getUserIcon
{
    if ([SharedAppUtil defaultCommonUtil].userVO == nil) {
        return;
    }
    [CommonRemoteHelper RemoteWithUrl:URL_GetUserInfor parameters: @{@"id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                                                                     @"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                     @"client" : @"ios"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         [NoticeHelper AlertShow:@"获取失败!" view:self.view];
                                     }
                                     else
                                     {
                                         NSDictionary *di = [dict objectForKey:@"datas"];
                                         if ([di count] != 0)
                                         {
                                             NSString *url = (NSString*)[di objectForKey:@"member_avatar"];
                                             iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://ibama.hvit.com.cn/shop/data/upload/shop/avatar/%@",url]];
                                         }
                                         [_iconImageview sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.view endEditing:YES];
                                 }];
}

@end
