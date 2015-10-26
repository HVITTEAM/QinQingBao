//
//  FamilyViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/8/25.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "FamilyViewController.h"
#import "FamilyTotal.h"
#import "FamilyModel.h"


@interface FamilyViewController ()
{
    NSMutableArray *dataProvider;
}

@end

@implementation FamilyViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self setupGroups];
    
    [self getDataProvider];
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.title = @"我的家属";
    self.view.backgroundColor = HMGlobalBg;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addHandler:)];
}

/**
 *  获取数据
 */
-(void)getDataProvider
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Relation parameters: @{@"oldid" : [SharedAppUtil defaultCommonUtil].userVO.old_id,
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
                                         FamilyTotal *result = [FamilyTotal objectWithKeyValues:dict];
                                         dataProvider = result.datas;
                                         [NoticeHelper AlertShow:@"登陆成功！" view:self.view];
                                     }
                                     [HUD removeFromSuperview];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                     [self.view endEditing:YES];
                                 }];
    
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
    HMCommonArrowItem *version = [HMCommonArrowItem itemWithTitle:@"老张" icon:@""];
    if(!self.isfromOrder)
        version.destVcClass = [FamilyInfoViewController class];
    
    __weak typeof(HMCommonArrowItem) *weakSelf = version;
    version.operation = ^{
        if(self.isfromOrder)
        {
            [MTNotificationCenter postNotificationName:@"selected" object:weakSelf userInfo:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
    
    HMCommonArrowItem *help = [HMCommonArrowItem itemWithTitle:@"老王" icon:@""];
    
    HMCommonArrowItem *advice = [HMCommonArrowItem itemWithTitle:@"二大爷" icon:@""];
    
    group.items = @[version,help,advice];
}

-(void)addHandler:(id)sender
{
    if (self.addView == nil) {
        self.addView = [[AddMemberViewController alloc] init];
    }
    [self.navigationController pushViewController:self.addView animated:YES];
}



@end
