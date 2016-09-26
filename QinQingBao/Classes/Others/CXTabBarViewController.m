//
//  CXTabBarViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/9/9.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CXTabBarViewController.h"

#import "HealthMonitorViewController.h"
#import "NewHomeViewController.h"

#import "CXHomeViewController.h"

#import "PrivateProfileViewController.h"
#import "RootViewController.h"
#import "LoginViewController.h"
#import "MallRootViewControlelr.h"

#import "DiscoveryViewController.h"
#import "CXTabBar.h"

#import "PublicProfileViewController.h"

#import "CXComposeViewController.h"
#import "CompleteInfoController.h"

#import "BHBPopView.h"


@interface CXTabBarViewController ()<UITabBarControllerDelegate,CXTabBarDelegate>
@property (nonatomic, weak) UIViewController *lastSelectedViewContoller;

@end

@implementation CXTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
    
    [self addAllChildVC];
    
    // 创建中间的tabbar
    [self addCustomTabBar];
    
    //注册寸欣账户登录信息超时监听
    [MTNotificationCenter addObserver:self selector:@selector(loginTimeoutHanlder:) name:MTLoginTimeout object:nil];
    
    //注册注销监听
    [MTNotificationCenter addObserver:self selector:@selector(loginTimeoutHanlder:) name:MTLoginout object:nil];
    
    //注册重新登录成功监听
    [MTNotificationCenter addObserver:self selector:@selector(reloginHanlder:) name:MTReLogin object:nil];
    
    //注册需要登录监听
    [MTNotificationCenter addObserver:self selector:@selector(needLoginoutHanlder:) name:MTNeedLogin object:nil];
    
    //注册需要登录论坛健康
    [MTNotificationCenter addObserver:self selector:@selector(needLoginoutHanlder:) name:MTCompleteInfo object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

/**
 *  添加所有的子控制器
 */
- (void)addAllChildVC
{
    NewHomeViewController *home = [[NewHomeViewController alloc] init];
    [self addOneChlildVc:home title:@"首页" imageName:@"first_normal.png" selectedImageName:@"first_selected.png"];
    self.lastSelectedViewContoller = home;
    
    DiscoveryViewController *discover = [[DiscoveryViewController alloc] init];
    [self addOneChlildVc:discover title:@"发现" imageName:@"tabbar_discover" selectedImageName:@"tabbar_discover_selected"];
    
    MallRootViewControlelr *mall = [[MallRootViewControlelr alloc] init];
    [self addOneChlildVc:mall title:@"商城" imageName:@"shop_normal.png" selectedImageName:@"shop_selected.png"];
    
    PrivateProfileViewController *profile = [[PrivateProfileViewController alloc] init];
    [self addOneChlildVc:profile title:@"我的" imageName:@"third_normal.png" selectedImageName:@"third_selected.png"];
}

/**
 *  创建自定义tabbar
 */
- (void)addCustomTabBar
{
    // 创建自定义tabbar
    CXTabBar *customTabBar = [[CXTabBar alloc] init];
    customTabBar.tabBarDelegate = self;
    // 更换系统自带的tabbar
    [self setValue:customTabBar forKeyPath:@"tabBar"];
}

/**
 *  添加一个子控制器
 *
 *  @param childVc           子控制器对象
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)addOneChlildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 设置标题
    childVc.title = title;
    
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageWithName:imageName];
    
    // 设置tabBarItem的普通文字颜色
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置tabBarItem的选中文字颜色
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[NSForegroundColorAttributeName] = HMColor(95, 117, 75);
    [childVc.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageWithName:selectedImageName];
    if (iOS7) {
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    childVc.tabBarItem.selectedImage = selectedImage;
    
    // 添加为tabbar控制器的子控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
    
    self.tabBar.translucent = NO;
}

#pragma mark UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UINavigationController *)viewController
{
    UIViewController *vc = [viewController.viewControllers firstObject];
    if ([vc isKindOfClass:[NewHomeViewController class]]) {
        if (self.lastSelectedViewContoller == vc) {
            
        } else {
            
        }
    }
    self.lastSelectedViewContoller = vc;
}

#pragma mark - CXTabBarDelegate
- (void)tabBarDidClickedPlusButton:(CXTabBar *)tabBar
{
    if ([SharedAppUtil checkLoginStates])
    {
        [BHBPopView showToView:self.view andImages:@[@"images.bundle/healthNews_icon",@"images.bundle/heart_brain_icon",@"images.bundle/fatigue_icon",@"images.bundle/reduceWeight_icon"] andTitles:@[@"健康资讯",@"心脑血管",@"易疲劳",@"减肥瘦身"] andSelectBlock:^(BHBItem *item) {
            // 弹出发微博控制器
            CXComposeViewController *compose = [[CXComposeViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:compose];
            [self presentViewController:nav animated:YES completion:nil];
        }];
    }
}


#pragma mark - NSNotification Center

/**
 * 登录信息超时处理事件(登出)
 */
-(void)loginTimeoutHanlder:(NSNotification *)notification
{
    [SharedAppUtil defaultCommonUtil].userVO = nil;
    [ArchiverCacheHelper saveObjectToLoacl:[SharedAppUtil defaultCommonUtil].userVO key:User_Archiver_Key filePath:User_Archiver_Path];
    
    UINavigationController *navlogin = [SharedAppUtil defaultCommonUtil].tabBar.viewControllers[3];
    //    [navlogin popToRootViewControllerAnimated:YES];
    PrivateProfileViewController *login = navlogin.viewControllers[0];
    [login initHeadView];
}

/**
 * 重新登录成功处理事件
 */
-(void)reloginHanlder:(NSNotification *)notification
{
    UINavigationController *navlogin = [SharedAppUtil defaultCommonUtil].tabBar.viewControllers[3];
    PrivateProfileViewController *login = navlogin.viewControllers[0];
    [login initHeadView];
}

/**
 * 需要验证身份才能进行下一步操作
 */
-(void)needLoginoutHanlder:(NSNotification *)notification
{
    LoginViewController *login = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
    login.backHiden = NO;
}

/**
 * 注册需要登录论坛健康
 */
-(void)needCompleteHanlder:(NSNotification *)notification
{
    // 完善论坛资料
    CompleteInfoController *conplete = [[CompleteInfoController alloc] init];
    [self presentViewController:conplete animated:YES completion:nil];
}

@end
