//
//  OrderDetailViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/6.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "ServiceItemTotal.h"


@interface OrderDetailViewController ()
{
    NSMutableArray *dataProvider;
}

@end

@implementation OrderDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self initTableviewSkin];
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.title = @"服务详情";
}

/**
 *  设置tableView属性
 */
-(void)initTableviewSkin
{
    NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"ServiceHeadView" owner:nil options:nil];
    self.tableView.tableHeaderView = [nibs lastObject];
    self.tableView.tableHeaderView.backgroundColor = HMGlobalBg;
    
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
}


-(void)setSelectedItem:(ServiceModel *)selectedItem
{
    _selectedItem = selectedItem;
    [self getDataProvider];
}
-(void)getDataProvider
{
    dataProvider = [[NSMutableArray alloc] init];
    [CommonRemoteHelper RemoteWithUrl:URL_Iteminfo_data_byiid parameters:  @{@"iid" : self.selectedItem.iid,
                                                                             @"client" : @"ios",
                                                                             @"key" : [SharedAppUtil defaultCommonUtil].userVO.key}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     ServiceItemTotal *result = [ServiceItemTotal objectWithKeyValues:dict];
                                     dataProvider = result.datas;
                                     [self.tableView reloadData];
                                     if (result.datas.count == 0)
                                         [self initWithPlaceString:@"现在还没数据呐"];
                                     else
                                         [self removePlace];
                                     [self.tableView headerEndRefreshing];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [NoticeHelper AlertShow:@"获取失败!" view:self.view];
                                 }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        return 180;
    else if (indexPath.row == 1)
        return 160;
    else
        return 190;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(!self.headView)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"PlaceOrderView" owner:self options:nil];
        self.headView = [nib lastObject];
        __weak typeof(self) weakSelf = self;
        self.headView.submitClick = ^(UIButton *button){
            [weakSelf submitClickHandler];
        };
    }
    return self.headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *listViewCellstr = @"cell";
    NSString *evaCellstr = @"evaCell";
    NSString *bucellstr = @"buceCell";
    NSString *serviceDetailstr = @"serviceDetailCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:listViewCellstr];
    EvaluationCell *evacell = [tableView dequeueReusableCellWithIdentifier:evaCellstr];
    BusinessInfoCell *bucell = [tableView dequeueReusableCellWithIdentifier:bucellstr];
    ServiceDetailCell *serviceDetailcell = [tableView dequeueReusableCellWithIdentifier:serviceDetailstr];
    
    if (indexPath.row == 0)
    {
        if (evacell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"EvaluationCell" owner:self options:nil];
            evacell = [nib lastObject];
            evacell.queryClick  = ^(UIButton *btn){
                [self queryAllevaluation];
            };
            evacell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return  evacell;
    }
    else if (indexPath.row == 1)
    {
        if (bucell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"BusinessInfoCell" owner:self options:nil];
            bucell = [nib lastObject];
            bucell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return  bucell;
    }
    else if (indexPath.row == 2)
    {
        if (serviceDetailcell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ServiceDetailCell" owner:self options:nil];
            serviceDetailcell = [nib lastObject];
            serviceDetailcell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return  serviceDetailcell;
    }
    else
    {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listViewCellstr];
            cell.textLabel.text = @"服务详情";
        }
        return  cell;
    }
}

/**
 *  获取全部评价
 */
-(void)queryAllevaluation
{
    if (!self.queryAlleva)
        self.queryAlleva = [[QueryAllEvaluationController alloc] init];
    [self.navigationController pushViewController:self.queryAlleva animated:YES];
}

/**
 *  下单
 */
-(void)submitClickHandler
{
    if(!self.submitController)
        self.submitController = [[OrderSubmitController alloc] init];
    [self.navigationController pushViewController:self.submitController animated:YES];
}

@end
