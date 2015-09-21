//
//  FamilyInfoViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/15.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "FamilyInfoViewController.h"

@interface FamilyInfoViewController ()

@end

@implementation FamilyInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self setupGroups];
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.title = @"张大爷";
    self.view.backgroundColor = HMGlobalBg;
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
    
    //    [self setPlaceHolderview];
    
    [self setupFooter];
    
    //刷新表格
    [self.tableView reloadData];
}


-(void)setPlaceHolderview
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake((self.view.width - 100)/2, (self.view.height - 100)/3, 100, 100)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
}

- (void)setupGroup0
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    // 设置组的所有行数据
    HMCommonArrowItem *version = [HMCommonArrowItem itemWithTitle:@"基本信息" icon:nil];
    version.destVcClass = [DetailInfoViewController class];
    version.operation = ^{
    };
    HMCommonArrowItem *help = [HMCommonArrowItem itemWithTitle:@"健康联系人" icon:nil];
    HMCommonArrowItem *advice = [HMCommonArrowItem itemWithTitle:@"健康档案" icon:nil];
    HMCommonArrowItem *service = [HMCommonArrowItem itemWithTitle:@"服务套餐" icon:nil];
    HMCommonArrowItem *doctor = [HMCommonArrowItem itemWithTitle:@"医嘱信息" icon:nil];
    group.items = @[version,help,advice,service,doctor];
}

- (void)setupFooter
{
    // 1.创建按钮
    UIButton *logout = [[UIButton alloc] init];
    
    // 2.设置属性
    logout.titleLabel.font = [UIFont systemFontOfSize:16];
    [logout setTitle:@"解除绑定" forState:UIControlStateNormal];
    [logout setTitleColor:HMColor(255, 10, 10) forState:UIControlStateNormal];
    [logout setBackgroundImage:[UIImage resizedImage:@"common_card_background"] forState:UIControlStateNormal];
    [logout setBackgroundImage:[UIImage resizedImage:@"common_card_background_highlighted"] forState:UIControlStateHighlighted];
    [logout addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    
    // 3.设置尺寸(tableFooterView和tableHeaderView的宽度跟tableView的宽度一样)
    logout.height = 50;
    
    self.tableView.tableFooterView = logout;
    
}

# pragma  mark 解除绑定

-(void)loginOut
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"解除绑定"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:@"确定解绑？"
                                                    otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        //退出登录时候需要先清空系统缓存
        
        //        //退出登录时候需要先清空系统缓存
        //        [SharedAppUtil defaultCommonUtil].userInfor = nil;
        //        [ArchiverCacheHelper saveObjectToLoacl:[SharedAppUtil defaultCommonUtil].userInfor key:User_Archiver_Key filePath:User_Archiver_Path];
        //
        //        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.loginview];
        //
        //        [self presentViewController:nav animated:YES completion:nil];
    }
}

@end
