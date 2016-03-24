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
#import "DeviceModel.h"

@interface FamilyViewController ()<UINavigationControllerDelegate>
{
    NSMutableArray *dataProvider;
    UserInforModel *infoVO;
    FamilyModel *familyVO;
}

@end

@implementation FamilyViewController

-(instancetype)init
{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self getDataProvider];
    
    self.navigationController.delegate= self;
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.title = @"我的亲友";
    self.view.backgroundColor = HMGlobalBg;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addHandler:)];
}

/**
 *  获取绑定的家属数据
 */
-(void)getDataProvider
{
    [self setupGroups];
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_get_user_devide parameters: @{@"member_id" : [SharedAppUtil defaultCommonUtil].userVO.member_id}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         if([codeNum integerValue] == 17001)
                                             [self initWithPlaceString:@"暂无数据"];
                                         [dataProvider removeAllObjects];
                                         [self setupGroups];
                                     }
                                     else
                                     {
                                         dataProvider = [DeviceModel objectArrayWithKeyValuesArray:[dict objectForKey:@"datas"]];
                                         if (dataProvider.count == 0)
                                             return [self initWithPlaceString:@"暂无数据"];
                                         [self setupGroups];
                                         [self removePlace];
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
    
    NSMutableArray *itemArr = [[NSMutableArray alloc] init];
    for (DeviceModel *data in dataProvider)
    {
        HMCommonArrowItem *item = [HMCommonArrowItem itemWithTitle:data.ud_name icon:@""];
        item.subtitle = data.rel_name;
        item.operation = ^{
            FamilyInfoViewController *detail = [[FamilyInfoViewController alloc] init];
            detail.backHandlerClick =  ^{
                [self getDataProvider];
            };
            detail.selecteItem = data;
            [self.navigationController pushViewController:detail animated:YES];
        };
        
        [itemArr addObject:item];
    }
    group.items = [itemArr copy];
}

-(void)addHandler:(id)sender
{
    AddMemberViewController *addView = [[AddMemberViewController alloc] init];
    addView.backHandlerClick =  ^{
        [self getDataProvider];
    };
    [self.navigationController pushViewController:addView animated:YES];
}



@end
