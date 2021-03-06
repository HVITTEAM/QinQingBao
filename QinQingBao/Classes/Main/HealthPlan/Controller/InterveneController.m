//
//  InterveneController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/8/15.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "InterveneController.h"
#import "InterveneEndView.h"

#import "PlanParagraphTextCell.h"
#import "RecommendGoodsCell.h"
#import "ImageCell.h"

#import "ConfirmViewController.h"
#import "MTCommodityModel.h"
#import "MTShoppIngCarModel.h"
#import "PlanReportTitleCell.h"

#import "InterveneModel.h"
#import "GoodsInfoModel.h"
#import "GoodsHeadViewController.h"
#import "MTShoppingCarController.h"
#import "CustomInfoController.h"

#import "HealthArchiveViewController.h"
#import "ArchiveDataListModel.h"

@interface InterveneController ()<InterveneEndViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) InterveneEndView *endView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) InterveneModel *dataItem;

@end

@implementation InterveneController
{
    BOOL showEndView;
    
    BOOL hideEndView;
    
    NSArray *goodsInfoArr;
}

-(InterveneEndView *)endView
{
    if (!_endView) {
        _endView = [[InterveneEndView alloc] initWithFrame:CGRectMake(0, MTScreenH , MTScreenW, [InterveneEndView getViewHeight])];
        _endView.delegate = self;
        _endView.isEdit = NO;
    }
    return _endView;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HMGlobalBg;
        
    }
    return _tableView;
}

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
    
    [self initView];
    
    [self getDataProvider];
    

}

-(void)initView
{
    self.title = @"干预方案";
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    //一开始不显示
    showEndView = NO;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.endView];
}

/**
 *  获取数据源（从档案获取干预方案）
 */
-(void)getDataProvider
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Get_work_intervention parameters:@{@"fmno" : self.fmno,
                                                                             @"wid" : self.wid && self.wid.length >0 ? self.wid : @"" ,
                                                                             @"key":[SharedAppUtil defaultCommonUtil].userVO.key,
                                                                             @"client":@"ios" }
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         if ([codeNum isEqualToString:@"17001"])
                                         {
                                             [self.view initWithPlaceString:@"暂无数据" imgPath:nil];
                                         }
                                         else
                                         {
                                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                             [alertView show];
                                         }
                                     }
                                     else
                                     {
                                         self.dataItem = [InterveneModel objectWithKeyValues:[dict objectForKey:@"datas"]];
                                         
                                         goodsInfoArr = [GoodsInfoModel objectArrayWithKeyValuesArray:self.dataItem.goodsinfos];
                                         //干预方案状态更改
                                         [self uploadReadStatusWithReportId:self.dataItem.wi_id fmno:self.fmno];
                                     }
                                     [self.tableView reloadData];
                                     [HUD removeFromSuperview];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [NoticeHelper AlertShow:@"获取失败!" view:self.view];
                                     [HUD removeFromSuperview];
                                 }];
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        return 44;
    }
    else if (indexPath.section == 0 && indexPath.row == 0)
    {
        return 140;
    }
    else if (indexPath.section == 0 && indexPath.row == 2)
    {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.height - 10;
    }
    else if (indexPath.section == 1)
    {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.height;
    }
    else if (indexPath.section == 2)
    {
        return indexPath.row == 0 ?  40 : 90;
    }
    else
        return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataItem ? (goodsInfoArr && goodsInfoArr.count >0 ? 3 : 2) : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataItem && self.dataItem.disease_risk && self.dataItem.disease_risk.length > 0) {
        return section == 0 ? 3 : section == 1 ? 8 : goodsInfoArr.count + 1;
    }
    return section == 0 ? 2 : section == 1 ? 8 : goodsInfoArr.count + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == 2 ? 0 : 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlanParagraphTextCell *paragraphTextCell = [tableView dequeueReusableCellWithIdentifier:@"MTParagraphTextCell"];
    
    PlanReportTitleCell *planReportTitleCell = [tableView dequeueReusableCellWithIdentifier:@"MTPlanReportTitleCell"];
    
    RecommendGoodsCell *recommendGoodsCell = [tableView dequeueReusableCellWithIdentifier:@"MTRecommendGoodsCell"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonCell"];
    
    ImageCell *imgcell = [tableView dequeueReusableCellWithIdentifier:@"MTImageCell"];
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        if (!imgcell)
            imgcell = [[[NSBundle mainBundle] loadNibNamed:@"ImageCell" owner:nil options:nil] lastObject];
        
        // NSURL *iconUrl = [NSURL URLWithString:self.dataItem.item_url_big];
        // [imgcell.imgView sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderDetail"]];
        
        cell = imgcell;
    }
    else  if (indexPath.section == 0 && indexPath.row == 1)
    {
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CommonCell"];
        }
        cell.imageView.image = [UIImage imageNamed:@"person.png"];
        cell.textLabel.text = self.truename;
        cell.textLabel.textColor = [UIColor colorWithRGB:@"333333"];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.text = [MTDateHelper getDaySince1970:self.dataItem.wp_create_time dateformat:@"yyyy-MM-dd"];
        cell.textLabel.textColor = [UIColor colorWithRGB:@"666666"];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else  if (indexPath.section == 0 && indexPath.row == 2)
    {
        if(paragraphTextCell == nil)
            paragraphTextCell = [PlanParagraphTextCell planParagraphTextCell];
        paragraphTextCell.textLab.font = [UIFont systemFontOfSize:12];
        paragraphTextCell.textLab.textColor = [UIColor colorWithRGB:@"c69666"];
        [paragraphTextCell setTitle:@"" withValue:self.dataItem.disease_risk];
        cell = paragraphTextCell;
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            if(paragraphTextCell == nil)
                paragraphTextCell = [PlanParagraphTextCell planParagraphTextCell];
            [paragraphTextCell setTitle:@"干预目标" withValue:self.dataItem.wp_advice_goal];
            cell = paragraphTextCell;
        }
        else if (indexPath.row == 1)
        {
            if(paragraphTextCell == nil)
                paragraphTextCell = [PlanParagraphTextCell planParagraphTextCell];
            
            [paragraphTextCell setTitle:@"饮食调理建议" withValue:self.dataItem.wp_advice_diet];
            cell = paragraphTextCell;
        }
        else if (indexPath.row == 2)
        {
            if(paragraphTextCell == nil)
                paragraphTextCell = [PlanParagraphTextCell planParagraphTextCell];
            
            [paragraphTextCell setTitle:@"运动增健建议" withValue:self.dataItem.wp_advice_sport];
            cell = paragraphTextCell;
        }
        else if (indexPath.row == 3)
        {
            if(paragraphTextCell == nil)
                paragraphTextCell = [PlanParagraphTextCell planParagraphTextCell];
            
            [paragraphTextCell setTitle:@"睡眠改善建议" withValue:self.dataItem.wp_advice_sleeping];
            cell = paragraphTextCell;
        }
        else if (indexPath.row == 4)
        {
            if(paragraphTextCell == nil)
                paragraphTextCell = [PlanParagraphTextCell planParagraphTextCell];
            
            [paragraphTextCell setTitle:@"心理调适减压" withValue:self.dataItem.wp_advice_mental];
            cell = paragraphTextCell;
        }
        else if (indexPath.row == 5)
        {
            if(paragraphTextCell == nil)
                paragraphTextCell = [PlanParagraphTextCell planParagraphTextCell];
            
            [paragraphTextCell setTitle:@"环境起居建议" withValue:self.dataItem.wp_advice_envir];
            cell = paragraphTextCell;
        }
        else if (indexPath.row == 6)
        {
            if(paragraphTextCell == nil)
                paragraphTextCell = [PlanParagraphTextCell planParagraphTextCell];
            
            [paragraphTextCell setTitle:@"营养素补充建议" withValue:self.dataItem.wp_nutrient_plan];
            cell = paragraphTextCell;
        }
        else if (indexPath.row == 7)
        {
            if(paragraphTextCell == nil)
                paragraphTextCell = [PlanParagraphTextCell planParagraphTextCell];
            
            [paragraphTextCell setTitle:@"精准健康管理建议" withValue:self.dataItem.wp_advice_health];
            cell = paragraphTextCell;
        }
        else
        {
            if(planReportTitleCell == nil)
                planReportTitleCell = [PlanReportTitleCell planReportTitleCell];
            
            planReportTitleCell.item = self.dataItem;
            
            cell = planReportTitleCell;
        }
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CommonCell"];
            }
            cell.textLabel.text = @"寸欣健康为您推荐";
            cell.imageView.image = [UIImage imageNamed:@"推荐商品"];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = [UIColor colorWithRGB:@"333333"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else
        {
            if(recommendGoodsCell == nil)
                recommendGoodsCell = [RecommendGoodsCell recommendGoodsCell];
            recommendGoodsCell.parnetVC = self;
            recommendGoodsCell.goodsItem = goodsInfoArr[indexPath.row - 1];
            recommendGoodsCell.changeClick = ^(UIButton *btn){
                [self selectedChnageHandler];
            };
            cell = recommendGoodsCell;
        }
    }
    else
    {
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommonCell"];
        }
        
        cell.textLabel.text = @"测试";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        HealthArchiveViewController *healthArchiveVC = [[HealthArchiveViewController alloc] init];
        ArchiveDataListModel *model = [[ArchiveDataListModel alloc] init];
        model.fmno = self.fmno;
        healthArchiveVC.selectedListModel = model;
        healthArchiveVC.addArchive = NO;
        [self.navigationController pushViewController:healthArchiveVC animated:YES];
    }
    else if (indexPath.section == 2 && indexPath.row >0)
    {
        GoodsHeadViewController *goodsvc = [[GoodsHeadViewController alloc] init];
        GoodsInfoModel *item = goodsInfoArr[indexPath.row - 1];
        goodsvc.goodsID =  item.goods_id;
        [self.navigationController pushViewController:goodsvc animated:YES];
    }
}

#pragma mark -- UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    hideEndView = YES;
    for (UITableViewCell *cell in self.tableView.visibleCells)
    {
        if ([cell isKindOfClass:[RecommendGoodsCell class]])
        {
            hideEndView = NO;
            if (!showEndView)
            {
                NSLog(@"显示");
                [UIView animateWithDuration:0.3 delay:1 options:0 animations:^{
                    self.tableView.height = MTScreenH - [InterveneEndView getViewHeight];
                    self.endView.y = MTScreenH - [InterveneEndView getViewHeight];
                } completion:^(BOOL finished) {
                    showEndView = YES;
                    hideEndView = NO;
                }];
            }
            break;
        }
    }
    if (hideEndView && self.endView.y == MTScreenH - [InterveneEndView getViewHeight]) {
        NSLog(@"消失");
        [UIView animateWithDuration:0.3 delay:1 options:0 animations:^{
            self.endView.y = MTScreenH;
            self.tableView.height = MTScreenH;
        } completion:^(BOOL finished) {
            showEndView = NO;
        }];
    }
}

#pragma mark MTShoppingCartEndViewDelegate

-(void)clickALLEnd:(UIButton *)bt
{
    NSLog(@"全选");
    bt.selected = !bt.selected;
    
    for (GoodsInfoModel *item in goodsInfoArr)
    {
        item.selected = bt.selected;
    }
    [self selectedChnageHandler];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)clickRightBT:(UIButton *)bt
{
    [self checkData];
}

- (void)selectedChnageHandler
{
    BOOL allSelected = YES;
    
    BOOL disSelected = YES;
    
    CGFloat totalPrice = 0;
    
    for (GoodsInfoModel *item in goodsInfoArr)
    {
        if (item.selected)
        {
            totalPrice += [item.goods_price floatValue];
            disSelected = NO;
        }
        else
        {
            allSelected = NO;
        }
    }
    
    if (allSelected)
    {
        NSLog(@"全部选中");
        self.endView.selectedAllbt.selected = YES;
    }
    else
    {
        self.endView.selectedAllbt.selected = NO;
    }
    
    if (disSelected)
        self.endView.pushBt.enabled = NO;
    else
        self.endView.pushBt.enabled = YES;
    
    self.endView.Lab.text = [NSString stringWithFormat:@"%.02f",totalPrice];
}


/**
 *  添加到购物车
 */
-(void)checkData
{
    NSMutableArray *selectedArr = [[NSMutableArray alloc] init];
    for (GoodsInfoModel *item in goodsInfoArr)
    {
        if (item.selected)
        {
            [selectedArr addObject:item];
        }
    }
    if (selectedArr.count == 0)
        return [NoticeHelper AlertShow:@"请选择商品" view:nil];
    
    [self add2carWithID:selectedArr];
}

-(void)add2carWithID:(NSMutableArray *)selectedArr
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSInteger invokeIdx = 0;
    for (GoodsInfoModel *item  in selectedArr)
    {
        invokeIdx ++;
        [CommonRemoteHelper RemoteWithUrl:URL_Cart_add parameters: @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                     @"goods_id" : item.goods_id,
                                                                     @"client" : @"ios",
                                                                     @"quantity" : @"1"}
                                     type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                         
                                         id codeNum = [dict objectForKey:@"code"];
                                         if([codeNum isKindOfClass:[NSString class]])
                                         {
                                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                             [alertView show];
                                         }
                                         else
                                         {
                                             if (invokeIdx == selectedArr.count)
                                             {
                                                 [HUD removeFromSuperview];
                                                 MTShoppingCarController *shopCar = [[MTShoppingCarController alloc] init];
                                                 [self.navigationController pushViewController:shopCar animated:YES];
                                             }
                                         }
                                         
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"出错了....");
                                         [HUD removeFromSuperview];
                                         
                                         [NoticeHelper AlertShow:@"添加失败!" view:self.view];
                                     }];
    }
}

/**
 *  干预方案状态变更 未读改为已读  read为0:解读报告操作 1:干预方案操作
 */
- (void)uploadReadStatusWithReportId:(NSString *)reportId fmno:(NSString *)fmno
{
    NSMutableDictionary *params = [@{
                                     @"client":@"ios",
                                     @"key":[SharedAppUtil defaultCommonUtil].userVO.key
                                     }mutableCopy];
    params[@"fmno"] = fmno;
    params[@"report_id"] = reportId;
    params[@"read"] = @"1";
    
    [CommonRemoteHelper RemoteWithUrl:URL_Readed parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
