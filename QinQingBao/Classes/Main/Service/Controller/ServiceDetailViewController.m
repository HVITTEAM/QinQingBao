//
//  OrderDetailViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/6.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "ServiceDetailViewController.h"
#import "ServiceItemTotal.h"
#import "EvaluationTotal.h"
#import "EvaluationNoneCell.h"
#import "RemarkDetailCell.h"


@interface ServiceDetailViewController ()
{
    /*所有的评价数据*/
    NSMutableArray *evaArr;
    
    NSMutableArray *dataProvider;
    /*当前服务的详细数据*/
    ServiceItemModel *itemInfo;
}

@end

@implementation ServiceDetailViewController

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


-(void)setSelectedItem:(ServiceItemModel *)selectedItem
{
    _selectedItem = selectedItem;
    
    [self getDataProvider];
    
    [self getAlleva];
}

/**
 *  获取服务评价
 */
-(void)getAlleva
{
    evaArr = [[NSMutableArray alloc] init];
    [CommonRemoteHelper RemoteWithUrl:URL_Get_dis_cont parameters: @{@"iid" : self.selectedItem.iid,
                                                                     @"page" : @10,
                                                                     @"p" : @1,
                                                                     @"client" : @"ios",
                                                                     @"key" : [SharedAppUtil defaultCommonUtil].userVO.key}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     EvaluationTotal *result = [EvaluationTotal objectWithKeyValues:dict];
                                     evaArr = result.datas;
                                     [self.tableView reloadData];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                 }];
}

-(void)getDataProvider
{
    itemInfo = self.selectedItem;
    [(ServiceHeadView *)self.tableView.tableHeaderView setItemInfo:itemInfo];
    [self.tableView reloadData];
    //    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    dataProvider = [[NSMutableArray alloc] init];
    //    [CommonRemoteHelper RemoteWithUrl:URL_Iteminfo_data_byiid parameters:  @{@"iid" : self.selectedItem.iid,
    //                                                                             @"client" : @"ios",
    //                                                                             @"key" : [SharedAppUtil defaultCommonUtil].userVO.key}
    //                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
    //                                     itemInfo = [ServiceItemModel objectWithKeyValues:[dict objectForKey:@"datas"]];
    //                                     [(ServiceHeadView *)self.tableView.tableHeaderView setItemInfo:itemInfo];
    //                                     [self.tableView reloadData];
    //                                     [HUD removeFromSuperview];
    //                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //                                     NSLog(@"发生错误！%@",error);
    //                                     [NoticeHelper AlertShow:@"获取失败!" view:self.view];
    //                                     [HUD removeFromSuperview];
    //                                 }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.row == 0)
        height =  evaArr.count != 0 ? 180 : 50;
    else if (indexPath.row == 1)
        height = 160;
    else if (indexPath.row == 2)
        height = 80;
    else if (indexPath.row == 3)
    {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.height;
    }
    return height;
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
    self.headView.price = itemInfo.price;
    return self.headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    
    switch (indexPath.row)
    {
        case 0:
        {
            if (evaArr.count != 0)
            {
                EvaluationCell *evacell = [tableView dequeueReusableCellWithIdentifier:@"MTEvaCell"];
                
                if(evacell == nil)
                    evacell = [EvaluationCell evaluationCell];
                
                [evacell setItemInfo:itemInfo];
                [evacell setEvaItem:evaArr[0]];
                evacell.queryClick  = ^(UIButton *btn){
                    [self queryAllevaluation];
                };
                cell = evacell;
            }
            else
            {
                EvaluationNoneCell *evanoneCell = [tableView dequeueReusableCellWithIdentifier:@"MTEvanoneCell"];
                if(evanoneCell == nil)
                    evanoneCell = [EvaluationNoneCell evanoneCell];
                cell = evanoneCell;
            }
        }
            break;
        case 1:
        {
            BusinessInfoCell *bucell = [tableView dequeueReusableCellWithIdentifier:@"MTbusinessInfoCell"];
            
            if(bucell == nil)
                bucell = [BusinessInfoCell businessCell];
            
            [bucell setItemInfo:itemInfo];
            
            cell = bucell;
        }
            break;
        case 2:
        {
            RemarkDetailCell *remarkDetailCell = [tableView dequeueReusableCellWithIdentifier:@"MTRemarkDetailCell"];
            
            if(remarkDetailCell == nil)
                remarkDetailCell = [RemarkDetailCell remarkDetailCell];
            
            [remarkDetailCell setItemInfo:itemInfo];
            
            cell = remarkDetailCell;
        }
            break;
        case 3:
        {
            ServiceDetailCell *serviceDetailcell = [tableView dequeueReusableCellWithIdentifier:@"MTServiceDetailsCell"];
            
            if(serviceDetailcell == nil)
                serviceDetailcell = [ServiceDetailCell serviceCell];
            
//            serviceDetailcell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage resizedImage:@"common_background.png"]];

            [serviceDetailcell setItemInfo:itemInfo];

            cell = serviceDetailcell;

        }
            break;
        case 4:
        {
            UITableViewCell *commoncell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonCell"];
            
            if (commoncell == nil)
                commoncell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MTCommonCell"];
            
            commoncell.textLabel.text = @"服务详情";

            cell = commoncell;
            
        }
            break;
        default:
            break;
    }


    return cell;
}

/**
 *  获取全部评价
 */
-(void)queryAllevaluation
{
    QueryAllEvaluationController *queryAlleva = [[QueryAllEvaluationController alloc] init];
    queryAlleva.itemInfo = self.selectedItem;
    [self.navigationController pushViewController:queryAlleva animated:YES];
}

/**
 *  下单
 */
-(void)submitClickHandler
{
    OrderSubmitController *submitController = [[OrderSubmitController alloc] init];
    submitController.serviceDetailItem = self.selectedItem;
    submitController.serviceTypeItem = self.serviceTypeItem;
    [self.navigationController pushViewController:submitController animated:YES];
}

@end
