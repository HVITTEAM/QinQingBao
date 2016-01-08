//
//  FamilyInfoViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/15.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "FamilyInfoViewController.h"
#import "HypertensioninfoModel.h"
#import "HealthArchivesController.h"
#import "FamilyInforTotal.h"
#import "FamilyInforModel.h"


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
    self.title = self.selecteItem.member_truename;
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
    
    [self setupFooter];
    
    //刷新表格
    [self.tableView reloadData];
}

/**
 *  获取数据
 */
-(void)getDataProvider
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Healthy parameters: @{@"member_id" : self.selecteItem.member_id,
                                                                @"client" : @"ios",
                                                                @"key":[SharedAppUtil defaultCommonUtil].userVO.key}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         FamilyInforTotal *result = [FamilyInforTotal objectWithKeyValues:dict];
                                         HealthArchivesController *viewC = [[HealthArchivesController alloc] init];
                                         viewC.familyInfoTotal = result.datas;
                                         viewC.title = [NSString stringWithFormat:@"%@的健康档案",self.selecteItem.member_truename];
                                         [self.navigationController pushViewController:viewC animated:YES];
                                     }
                                     [HUD removeFromSuperview];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                     [self.view endEditing:YES];
                                 }];
    
}

- (void)setupGroup0
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
#warning nil会有警告信息log出来
    // 设置组的所有行数据
    HMCommonArrowItem *version = [HMCommonArrowItem itemWithTitle:@"基本信息" icon:@""];
    version.isSubtitle = YES;
//    version.destVcClass = [DetailInfoViewController class];
    version.operation = ^{
        DetailInfoViewController *view = [[DetailInfoViewController alloc] init];
        view.itemInfo = self.selecteItem;
        [self.navigationController pushViewController:view animated:YES];
    };
    HMCommonArrowItem *help = [HMCommonArrowItem itemWithTitle:@"健康联系人" icon:@""];
    help.operation = ^{
        [NoticeHelper AlertShow:@"暂未开通!" view:self.view];
    };
    help.isSubtitle = YES;
    HMCommonArrowItem *advice = [HMCommonArrowItem itemWithTitle:@"健康档案" icon:@""];
    advice.isSubtitle = YES;
    advice.operation = ^{
        [self getDataProvider];
    };

    HMCommonArrowItem *service = [HMCommonArrowItem itemWithTitle:@"服务套餐" icon:@""];
    service.operation = ^{
        [NoticeHelper AlertShow:@"暂未开通!" view:self.view];
    };

    service.isSubtitle = YES;
    HMCommonArrowItem *doctor = [HMCommonArrowItem itemWithTitle:@"医嘱信息" icon:@""];
    doctor.operation = ^{
        [NoticeHelper AlertShow:@"暂未开通!" view:self.view];
    };
    doctor.isSubtitle = YES;
    group.items = @[version,help,advice,service,doctor];
}

- (void)setupFooter
{
    // 1.创建按钮
    UIButton *cancel = [[UIButton alloc] init];
    
    // 2.设置属性
    cancel.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancel setTitle:@"解除绑定" forState:UIControlStateNormal];
    [cancel setTitleColor:HMColor(255, 10, 10) forState:UIControlStateNormal];
    [cancel setBackgroundImage:[UIImage resizedImage:@"common_card_background"] forState:UIControlStateNormal];
    [cancel setBackgroundImage:[UIImage resizedImage:@"common_card_background_highlighted"] forState:UIControlStateHighlighted];
    [cancel addTarget:self action:@selector(cancelHandler) forControlEvents:UIControlEventTouchUpInside];
    
    // 3.设置尺寸(tableFooterView和tableHeaderView的宽度跟tableView的宽度一样)
    cancel.height = 50;
    
    self.tableView.tableFooterView = cancel;
    
}

# pragma  mark 解除绑定

-(void)cancelHandler
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
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [CommonRemoteHelper RemoteWithUrl:URL_Del_relation parameters: @{@"member_id" : self.selecteItem.member_id,
                                                                         @"client" : @"ios",
                                                                         @"key":[SharedAppUtil defaultCommonUtil].userVO.key}
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
                                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"解除绑定成功!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                             [alertView show];
                                             [SharedAppUtil defaultCommonUtil].needRefleshMonitor = YES;
                                             if (self.backHandlerClick)
                                                 self.backHandlerClick();
                                             [self.navigationController popViewControllerAnimated:YES];
                                         }
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"发生错误！%@",error);
                                         [HUD removeFromSuperview];
                                         [self.view endEditing:YES];
                                     }];
        
    }
}

@end
