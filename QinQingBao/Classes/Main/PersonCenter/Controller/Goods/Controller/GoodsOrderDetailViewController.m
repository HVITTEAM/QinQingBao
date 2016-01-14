//
//  GoodsOrderDetailViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "GoodsOrderDetailViewController.h"
#import "CommonGoodsDetailEndView.h"

#import "CommonGoodsDetailBottomCell.h"
#import "CommonGoodsDetailHeadCell.h"
#import "CommonGoodsDetailMiddleCell.h"

static CGFloat ENDVIEW_HEIGHT = 50;


@interface GoodsOrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
}

@property (nonatomic,strong) UITableView *tableView;


@property (nonatomic,strong) CommonGoodsDetailEndView *endView;

@end

@implementation GoodsOrderDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableSkin];
}


-(void)initTableSkin
{
    self.title = @"订单详情";
    
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = HMGlobalBg;
    
    [self.view addSubview:self.tableView];
    
    _endView = [[CommonGoodsDetailEndView alloc]initWithFrame:CGRectMake(0, MTScreenH - ENDVIEW_HEIGHT, MTScreenW,ENDVIEW_HEIGHT)];
    //    _endView.delegate = self;
    [self.view addSubview:_endView];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH - ENDVIEW_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    CommonGoodsDetailHeadCell *headCell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonGoodsDetailHeadCell"];
    
    CommonGoodsDetailMiddleCell *middleCell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonGoodsDetailMiddleCell"];
    
    CommonGoodsDetailBottomCell *bottomCell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonGoodsDetailBottomCell"];
    
    if (indexPath.section == 0)
    {
        if(headCell == nil)
            headCell = [CommonGoodsDetailHeadCell commonGoodsDetailHeadCell];
        
        //            [goodsTitleCell setItem:goodsInfo];
        cell = headCell;
    }
    else if (indexPath.section == 1)
    {
        if(middleCell == nil)
            middleCell = [CommonGoodsDetailMiddleCell commonGoodsDetailMiddleCell];
        
        //            [goodsTitleCell setItem:goodsInfo];
        cell = middleCell;
    }
    else
    {
        if(bottomCell == nil)
            bottomCell = [CommonGoodsDetailBottomCell commonGoodsDetailBottomCell];
        
        //            [goodsTitleCell setItem:goodsInfo];
        cell = bottomCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
