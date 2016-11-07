//
//  SettingViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/8/25.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutViewController.h"
#import "FeedbackViewController.h"
#import "MsgAndPushViewController.h"


@interface SettingViewController ()<UIAlertViewDelegate,UIActionSheetDelegate>
{
    UIButton *logout;
}
@property(assign,nonatomic)BOOL tapLoginOutButton;      //是否点击了退出按钮

@end

@implementation SettingViewController

-(instancetype)init
{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self setupGroups];
    
    //注册重新登录成功监听
    [MTNotificationCenter addObserver:self selector:@selector(reloginHanlder) name:MTReLogin object:nil];
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.title = @"系统设置";
    self.view.backgroundColor = HMGlobalBg;
    
    [self setupFooter];
}

- (void)setupFooter
{
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 70)];
    bgview.backgroundColor = [UIColor clearColor];
    
    logout = [[UIButton alloc] init];
    logout.frame = CGRectMake(20, 15, MTScreenW - 40, 45);
    logout.titleLabel.font = [UIFont systemFontOfSize:16];
    if ([SharedAppUtil defaultCommonUtil].userVO == nil)
        [logout setTitle:@"登录" forState:UIControlStateNormal];
    else
        [logout setTitle:@"退出当前帐号" forState:UIControlStateNormal];
    [logout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logout setBackgroundColor:HMColor(251, 176, 59)];
    logout.layer.cornerRadius = 6.0f;
    [logout addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:logout];
    
    self.tableView.tableFooterView = bgview;
}

/**
 *  登录成功之后
 */
-(void)reloginHanlder
{
    [self setupFooter];
    [self.navigationController popViewControllerAnimated:YES];
}


# pragma  mark 设置数据源
/**
 *  初始化模型数据
 */
- (void)setupGroups
{
    //每次刷新数据源的时候需要将数据源清空
    [self.groups removeAllObjects];
    
    [self setupGroup0];
    
    [self setupGroup1];
    
    //刷新表格
    [self.tableView reloadData];
}

- (void)setupGroup0
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    // 设置组的所有行数据
    HMCommonArrowItem *version = [HMCommonArrowItem itemWithTitle:@"清除缓存" icon:@"nil"];
    version.subtitle = [NSString stringWithFormat:@"%.1fM",[self filePath]];
    version.operation = ^{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:[NSString stringWithFormat:@"缓存大小为%@,确定要清除吗？",[NSString stringWithFormat:@"%.1fM",[self filePath]]]
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        [alertView show];
    };
    
    HMCommonArrowItem *advice = [HMCommonArrowItem itemWithTitle:@"设置" icon:@"nil"];
    advice.operation = ^{
        [NoticeHelper AlertShow:@"此功能暂尚未启用,敬请期待" view:self.view];
    };
    
    HMCommonArrowItem *updata = [HMCommonArrowItem itemWithTitle:@"消息通知" icon:@"nil"];
    updata.destVcClass = [MsgAndPushViewController class];
    
    group.items = @[updata,version];
}

- (void)setupGroup1
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    // 设置组的所有行数据
    HMCommonArrowItem *version = [HMCommonArrowItem itemWithTitle:@"意见反馈" icon:@"nil"];
    version.destVcClass = [FeedbackViewController class];
    
    HMCommonArrowItem *advice = [HMCommonArrowItem itemWithTitle:@"关于app" icon:@"nil"];
    advice.destVcClass = [AboutViewController class];
    
    HMCommonItem*updata = [HMCommonItem itemWithTitle:@"检查更新" icon:nil];
    updata.subtitle = kAppVersion;
    
    group.items = @[version,advice];
}

// 显示缓存大小
-(float)filePath
{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    return [ self folderSizeAtPath :cachPath];
}

//计算一下 单个文件的大小
- (long)fileSizeAtPath:( NSString *) filePath
{
    NSFileManager * manager = [ NSFileManager defaultManager ];
    if ([manager fileExistsAtPath :filePath])
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    return 0 ;
}

//遍历文件夹获得文件夹大小，返回多少 M

- (float) folderSizeAtPath:( NSString *) folderPath
{
    NSFileManager * manager = [ NSFileManager defaultManager ];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    return folderSize/( 1024.0 * 1024.0 );
}

// 清理缓存
- (void)clearFile
{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
    NSLog ( @"cachpath = %@" , cachPath);
    for ( NSString * p in files)
    {
        NSError * error = nil ;
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path])
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
    }
    [NoticeHelper AlertShow:@"释放成功" view:self.view];
    [self setupGroups];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self clearFile];
    }
}

#pragma mark - 退出登录
#pragma  mark - 退出当前账号
-(void)loginOut
{
    if ([logout.titleLabel.text isEqualToString:@"登录"])
    {
        return [MTNotificationCenter postNotificationName:MTNeedLogin object:nil];
    }
    
    self.tapLoginOutButton = YES;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"确定退出当前账号？"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:@"确定"
                                                    otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.tapLoginOutButton) {
        if(buttonIndex == 0)
        {
            MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            [CommonRemoteHelper RemoteWithUrl:URL_Logout_New parameters: @{@"id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
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
                                                 //清楚第三方的授权信息
                                                 [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
                                                 [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
                                                 [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
                                                 
                                                 [MTNotificationCenter postNotificationName:MTLoginout object:nil userInfo:nil];
                                                 [self setupFooter];
                                             }
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             NSLog(@"发生错误！%@",error);
                                             [HUD removeFromSuperview];
                                             [self.view endEditing:YES];
                                         }];
        }else{
            self.tapLoginOutButton = NO;
        }
        return;
    }
}

@end
