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


#define imageHeight 120

@interface ProfileViewController ()


@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self initTableviewSkin];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupGroups];
    
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark 初始化界面

/** 屏蔽tableView的样式 */
- (id)init
{
    return [self initWithStyle:UITableViewStylePlain];
}

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
    self.tableView.contentInset = UIEdgeInsetsMake(imageHeight, 0, 0, 0);
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.title = @"个人中心";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _zoomImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pc_bg.png"]];
    _zoomImageview.frame = CGRectMake(0, -imageHeight, self.view.width, imageHeight);
    //高度改变 宽度也跟着改变
    //    _zoomImageview.contentMode = UIViewContentModeScaleAspectFill;
    [self.tableView addSubview:_zoomImageview];
    
    [_zoomImageview setUserInteractionEnabled:YES];//使添加其上的button有点击事件
    
    //设置autoresizesSubviews让子类自动布局
    _zoomImageview.autoresizesSubviews = YES;
    
    _backBtn = [[UIButton alloc] init];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"default_common_navibar_prev_normal.png"] forState:UIControlStateNormal];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"default_common_navibar_prev_highlighted.png"] forState:UIControlStateHighlighted];
    // 设置按钮的尺寸为背景图片的尺寸
    _backBtn.size = _backBtn.currentBackgroundImage.size;
    _backBtn.x = 10;
    _backBtn.y = 30;
    //    [_zoomImageview addSubview:_backBtn];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    _iconImageview = [[UIImageView alloc]initWithFrame:CGRectMake((MTScreenW - 80)/2, 10, 80, 80)];
    _iconImageview.image = [UIImage imageNamed:@"head.png"];
    _iconImageview.clipsToBounds = YES;
    _iconImageview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
    [_zoomImageview addSubview:_iconImageview];
    
    _circleImageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, imageHeight - 30, 40, 40)];
    _circleImageview.backgroundColor = [UIColor redColor];
    _circleImageview.layer.cornerRadius = 7.5f;
    _circleImageview.image = [UIImage imageNamed:@"avatar.png"];
    _circleImageview.clipsToBounds = YES;
    _circleImageview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
    //    [_zoomImageview addSubview:_circleImageview];
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(60, imageHeight - 20, 280, 20)];
    _label.textColor = [UIColor whiteColor];
    _label.text = @"个人中心";
    _label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//自动布局，自适应顶部
    //    [_zoomImageview addSubview:_label];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat y = scrollView.contentOffset.y;//根据实际选择加不加上NavigationBarHight（44、64 或者没有导航条）
    if (y < -imageHeight) {
        CGRect frame = _zoomImageview.frame;
        frame.origin.y = y;
        frame.size.height =  -y;//contentMode = UIViewContentModeScaleAspectFill时，高度改变宽度也跟着改变
        _zoomImageview.frame = frame;
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
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
                                             [MTControllerChooseTool setLoginViewController];
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
@end
