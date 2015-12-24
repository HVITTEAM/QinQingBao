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


@interface FamilyViewController ()<UINavigationControllerDelegate>
{
    NSMutableArray *dataProvider;
    UserInforModel *infoVO;
    FamilyModel *familyVO;
}

@end

@implementation FamilyViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    
    if (self.isfromOrder)
        [self getUserData];
    
    [self getDataProvider];
    
    self.navigationController.delegate= self;
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
 *  获取绑定的家属数据
 */
-(void)getDataProvider
{
    [self setupGroups];
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Relation parameters: @{@"member_id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                                                                 @"client" : @"ios",
                                                                 @"key":[SharedAppUtil defaultCommonUtil].userVO.key}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         
                                         //                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         //                                         [alertView show];
                                         
                                         if(!self.isfromOrder)
                                             [self initWithPlaceString:@"您还没有绑定的家属呐"];
                                         [dataProvider removeAllObjects];
                                         [self setupGroups];
                                     }
                                     else
                                     {
                                         FamilyTotal *result = [FamilyTotal objectWithKeyValues:dict];
                                         dataProvider = result.datas;
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

/**
 *  获取当前登录账户的个人资料
 */
-(void)getUserData
{
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
                                             infoVO = [UserInforModel objectWithKeyValues:di];
                                             
                                             familyVO = [[FamilyModel alloc] init];
                                             familyVO.member_id = infoVO.member_id;
                                             familyVO.member_truename = infoVO.member_truename;
                                             familyVO.member_mobile = infoVO.member_mobile;
                                             familyVO.member_sex = infoVO.member_sex;
                                             familyVO.member_birthday = infoVO.member_birthday;
                                             familyVO.totalname = infoVO.totalname;
                                             familyVO.member_areainfo = infoVO.member_areainfo;
                                             familyVO.member_birthday = infoVO.member_birthday;
                                             familyVO.member_areaid = infoVO.member_areaid;
                                             
                                             [self setupGroups];
                                         }
                                         else
                                             [NoticeHelper AlertShow:@"个人资料为空!" view:self.view];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
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
    
    if (self.isfromOrder)
        [self setupGroup1];
    
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
    for (FamilyModel *data in dataProvider)
    {
        HMCommonArrowItem *item = [HMCommonArrowItem itemWithTitle:data.member_truename icon:@""];
        item.subtitle = data.relation;
        __weak typeof(FamilyModel) *weakSelf = data;
        item.operation = ^{
            if(self.isfromOrder)
            {
                [MTNotificationCenter postNotificationName:MTSececteFamily object:weakSelf userInfo:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                FamilyInfoViewController *detail = [[FamilyInfoViewController alloc] init];
                detail.backHandlerClick =  ^{
                    [self getDataProvider];
                };
                detail.selecteItem = data;
                [self.navigationController pushViewController:detail animated:YES];
            }
        };
        
        [itemArr addObject:item];
    }
    group.items = [itemArr copy];
}

/**
 *  添加自己的VO
 *
 *  @param vo 自己
 */
- (void)setupGroup1
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    HMCommonArrowItem *item = [HMCommonArrowItem itemWithTitle:familyVO.member_truename icon:@""];
    item.subtitle = @"自己";
    item.operation = ^{
        if(self.isfromOrder)
        {
            [MTNotificationCenter postNotificationName:MTSececteFamily object:familyVO userInfo:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
    group.items = @[item];
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
