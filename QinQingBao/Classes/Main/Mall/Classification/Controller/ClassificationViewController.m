//
//  ClassificationViewController.m
//  QinQingBao
//
//  Created by shi on 15/8/25.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "ClassificationViewController.h"
#import "ServiceTypeModel.h"
#import "ServiceTypeDatas.h"
#import "ServiceListViewController.h"
#import "GoodsCell.h"

@interface ClassificationViewController ()
{
    //当前选择的大类
    NSIndexPath *selectedIdx;
}

@end

@implementation ClassificationViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self initTableView];
    
    [self getDataProvider:self.dataProvider[0]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.leftViewWidth.constant = MTScreenW *0.25;
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.navigationItem.title = @"商品分类";
}

/**
 *  初始化表视图
 */
-(void)initTableView
{
    self.positionTableView.delegate = self;
    self.positionTableView.dataSource = self;
    self.symptomTableView.delegate = self;
    self.symptomTableView.dataSource = self;
    self.symptomTableView.tableFooterView = [[UIView alloc] init];
    
    //解决tableView分割线右移问题
    if ([ self.positionTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.positionTableView  setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.positionTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.positionTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([ self.symptomTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.symptomTableView  setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.symptomTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.symptomTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    //设置默认选中cell
    [self.positionTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

//获取数据源
-(void)getDataProvider:(ServiceTypeModel *)item
{
    //    [CommonRemoteHelper RemoteWithUrl:URL_Typelist parameters: @{@"tid" : item.tid,
    //                                                                 @"client" : @"ios",
    //                                                                 @"p" : @1,
    //                                                                 @"page" : @100}
    //                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
    //                                     ServiceTypeDatas *result = [ServiceTypeDatas objectWithKeyValues:dict];
    //                                     self.symptoms = result.datas;
    //                                     if (result.datas.count == 0)
    //                                         [NoticeHelper AlertShow:@"暂无数据!" view:self.view];
    [self.symptomTableView reloadData];
    //                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //                                     [SVProgressHUD dismiss];
    //                                 }];
}

#pragma mark tableView dataSourse
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.positionTableView == tableView) {
        return 6;
    }
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (self.positionTableView == tableView)
    {
        UITableViewCell *commoncell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonCell"];
        
        if (commoncell == nil)
            commoncell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MTCommonCell"];
        
        commoncell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:HMGlobalBg]];
        commoncell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:[UIColor whiteColor]]];
        commoncell.textLabel.text = @"健康保健";
        commoncell.textLabel.font = [UIFont systemFontOfSize:14];
        commoncell.textLabel.textColor = [UIColor colorWithRGB:@"666666"];
        cell = commoncell;
    }
    else
    {
        
        GoodsCell *goodscell = [tableView dequeueReusableCellWithIdentifier:@"MTGoodsCell"];
        if(goodscell == nil)
            goodscell = [GoodsCell goodsCell];
        
        [goodscell setitemWithData:nil];
        
        cell = goodscell;
    }
    return cell;
}

#pragma mark tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.positionTableView == tableView)
        return 50.0f;
    return 85.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.positionTableView == tableView)
    {
        selectedIdx = indexPath;
        [self getDataProvider:self.dataProvider[indexPath.row]];
    }else{
        ServiceListViewController *listView = [[ServiceListViewController alloc] init];
        listView.item = self.dataProvider[selectedIdx.row];
        listView.selected2edItem = self.symptoms[indexPath.row];
        [self.navigationController pushViewController:listView animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //设置cell选中时的背景View
    UIView* sbkView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView = sbkView;
    if (self.positionTableView == tableView) {
        sbkView .backgroundColor = [UIColor whiteColor];
    }else sbkView .backgroundColor = HMGlobalBg;
    
    //解决tableView分割线右移问题
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
