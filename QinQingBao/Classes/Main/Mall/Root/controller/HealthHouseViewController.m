//
//  HealthHouseViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/28.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "HealthHouseViewController.h"
#import "GoodsCell.h"
#import "HouseTypeCell.h"

#import "ConfModelTotal.h"
#import "GoodsHeadViewController.h"
#import "HotGoodsView.h"
#import "HotGoodsViewController.h"
#import "RecommendGoodsTotal.h"

#import "GoodsTableViewController.h"

@interface HealthHouseViewController ()
{
    /**推荐商品view*/
    HotGoodsView *footView;
    
    ConfModelTotal *result;
    /**存放推荐商品对象数组*/
    NSMutableArray *commendGoodsArr;
}

@end

@implementation HealthHouseViewController

-(instancetype)init
{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getRecommendGoods];
    
    [self initFootview];
}

-(void)initTableViewSkin
{
    self.title = @"健康屋";
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = HMGlobalBg;
}

-(void)initFootview
{
    footView = [[HotGoodsView alloc] init];
    footView.frame = CGRectMake(0, 0, MTScreenW, (MTScreenW/2 + 60)*3);
    footView.backgroundColor = [UIColor whiteColor];
    __weak __typeof(self)weakSelf = self;
    footView.clickClick = ^(RecommendGoodsModel *item)
    {
        GoodsHeadViewController *gvc = [[GoodsHeadViewController alloc] init];
        gvc.goodsID = item.goods_id;
        [weakSelf.navigationController pushViewController:gvc animated:YES];
    };
    self.tableView.tableFooterView = footView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return  195;
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == 0)
    {
        HouseTypeCell *houseTypeCell = [tableView dequeueReusableCellWithIdentifier:@"MTHouseTypeCell"];
        houseTypeCell.nav = self.navigationController;
        if(houseTypeCell == nil)
            houseTypeCell = [HouseTypeCell houseTypeCelWithId:self.gc_id];
        houseTypeCell.buttonClick = ^(NSString *gc_id){
            GoodsTableViewController *vc = [[GoodsTableViewController alloc] init];
            vc.gc_id = gc_id;
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        cell = houseTypeCell;
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            UITableViewCell *commoncell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonCell"];
            
            if (commoncell == nil)
                commoncell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MTCommonCell"];
            commoncell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            commoncell.textLabel.text = @"热销商品";
            commoncell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            commoncell.detailTextLabel.text = @"更多";
            cell = commoncell;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        HotGoodsViewController *vc = [[HotGoodsViewController alloc] init];
        vc.dataProvider = commendGoodsArr;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/**
 * 获取推荐商品
 **/
-(void)getRecommendGoods
{
    [CommonRemoteHelper RemoteWithUrl:URL_Apiget_goods parameters:nil
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     NSDictionary *dict1 =  [dict objectForKey:@"datas"];
                                     
                                     //设置推荐商品
                                     RecommendGoodsTotal *commendTotal = [RecommendGoodsTotal objectWithKeyValues:dict1];
                                     commendGoodsArr = commendTotal.data;
                                     if(commendGoodsArr.count > 0)
                                         [footView setDataProvider:commendGoodsArr];
                                     
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [NoticeHelper AlertShow:@"获取失败!" view:self.view];
                                 }];
}


@end
