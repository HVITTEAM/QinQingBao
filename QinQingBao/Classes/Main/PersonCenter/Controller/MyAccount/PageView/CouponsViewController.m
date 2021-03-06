//
//  CouponsTableViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/8/26.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "CouponsViewController.h"
#import "CouponsModel.h"
#import "CouponsTotal.h"


@interface CouponsViewController ()
{
    NSMutableArray *dataProvider;
}

@end

@implementation CouponsViewController

-(instancetype)init
{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidCurrentView
{
    NSLog(@"加载为当前视图 = %@",self.title);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableSkin];
    
    [self getDataProvider];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)initTableSkin
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = HMGlobalBg;
}

-(void)getDataProvider
{
    dataProvider = [[NSMutableArray alloc] init];

    NSDictionary *dict = [[NSDictionary alloc] init];
    
    if ([self.title isEqualToString:@"未使用"])
    {
        dict =  @{@"member_id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                  @"page" : @100,
                  @"voucher_state" : @"1",
                  @"curpage" : @1,
                  @"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                  @"client" : @"ios"};
    }
    else if ([self.title isEqualToString:@"已使用"])
    {
        dict =  @{@"member_id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                  @"voucher_state" : @"2",
                  @"page" : @100,
                  @"curpage" : @1,
                  @"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                  @"client" : @"ios"};
    }
    else if ([self.title isEqualToString:@"已过期"])
    {
        dict =  @{@"member_id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                  @"voucher_state" : @"3",
                  @"page" : @100,
                  @"curpage" : @3,
                  @"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                  @"client" : @"ios"};
    }
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [CommonRemoteHelper RemoteWithUrl:URL_Youhuicard parameters: dict
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                     }
                                     else
                                     {
                                         CouponsTotal *result = [CouponsTotal objectWithKeyValues:[dict objectForKey:@"datas"]];
                                         dataProvider = result.voucher_list;
                                         if (dataProvider.count == 0)
                                              [self.tableView initWithPlaceString:PlaceholderStr_Coup imgPath:@"placeholder-2"];
                                         [self.tableView reloadData];
                                     }
                                     [HUD removeFromSuperview];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                 }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataProvider.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponsCell *cell = [tableView dequeueReusableCellWithIdentifier: @"CouponsCell"];
    
    if (cell == nil)
        cell = [CouponsCell couponsCell];
    
    [cell setCouponsModel:dataProvider[indexPath.row]];
    
    cell.left.constant = 0;
    cell.selectBtn.hidden = YES;
    return  cell;
}


@end
