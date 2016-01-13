//
//  ClassificationViewController.m
//  QinQingBao
//
//  Created by shi on 15/8/25.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "ClassificationViewController.h"
#import "GoodsClassModel.h"
#import "GoodsClassModelTotal.h"
#import "GoodsCell.h"
#import "GoodsInfoModel.h"
#import "GoodsInfoTotal.h"
#import "GoodsHeadViewController.h"

@interface ClassificationViewController ()
{
    /**商品信息model*/
    NSMutableArray *goodsDataProvider;
    
    //当前第一页
    NSInteger currentPageIdx;
    
    //总共多少页
    NSInteger totalPage;
    
    GoodsClassModel *selectedClassItem;
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
    
    [self getGoodsClassData];
    
    [self setupRefresh];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.leftViewWidth.constant = MTScreenW *0.3;
}

#pragma mark 集成刷新控件

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    currentPageIdx = 1;
    goodsDataProvider = [[NSMutableArray alloc] init];
    // 上拉刷新
    self.symptomTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        currentPageIdx ++ ;
        [self footerRereshing];
    }];
}

#pragma mark 开始进入刷新状态

- (void)footerRereshing
{
    if (totalPage && currentPageIdx > totalPage)
    {
        [self.symptomTableView.footer endRefreshing];
        [self.view showNonedataTooltip];
        currentPageIdx --;
    }
    else
        [self getDataProvider];
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
}

//获取左侧分类数据
-(void)getGoodsClassData
{
    [CommonRemoteHelper RemoteWithUrl:URL_Goods_class parameters: @{@"gc_id" : @0}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     GoodsClassModelTotal *result = [GoodsClassModelTotal objectWithKeyValues:[dict objectForKey:@"datas"]];
                                     self.goodsClass = result.class_list;
                                     if (result.class_list.count == 0)
                                         return [NoticeHelper AlertShow:@"暂无数据!" view:self.view];
                                     [self.positionTableView reloadData];
                                     selectedClassItem = self.goodsClass[0];
                                     [self footerRereshing];
                                     [self.positionTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"出错了....");
                                 }];
}

//获取右侧数据源
-(void)getDataProvider
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [CommonRemoteHelper RemoteWithUrl:URL_Goods_list parameters: @{@"gc_id" : selectedClassItem.gc_id,
                                                                   @"keyword" : @"",
                                                                   @"key" : @4,
                                                                   @"order" : @2,
                                                                   @"page" : @10,
                                                                   @"curpage" : [NSString stringWithFormat:@"%li",(long)currentPageIdx],}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     [HUD removeFromSuperview];
                                     
                                     NSDictionary *dict1 =  [dict objectForKey:@"datas"];
                                     GoodsInfoTotal *result = [GoodsInfoTotal objectWithKeyValues:dict1];
                                     NSString *str = [dict objectForKey:@"page_total"];
                                     totalPage = [str integerValue];
                                     if (result.goods_list.count == 0 && currentPageIdx == 1)
                                     {
                                         [self.symptomTableView initWithPlaceString:@"暂无数据!"];
                                     }
                                     else if (result.goods_list.count == 0 && currentPageIdx > 1)
                                     {
                                         [self.symptomTableView removePlace];
                                         NSLog(@"没有更多的数据了");
                                         currentPageIdx --;
                                         [self.symptomTableView showNonedataTooltip];
                                     }
                                     else
                                     {
                                         [self.symptomTableView removePlace];
                                     }
                                     [goodsDataProvider addObjectsFromArray:[result.goods_list copy]];
                                     [self.symptomTableView reloadData];
                                     [self.symptomTableView.footer endRefreshing];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     [HUD removeFromSuperview];
                                 }];
}

#pragma mark tableView dataSourse
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.positionTableView == tableView) {
        return self.goodsClass.count;
    }
    return goodsDataProvider.count;
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
        commoncell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:[UIColor redColor]]];
        GoodsClassModel *item = self.goodsClass[indexPath.row];
        commoncell.textLabel.text = item.gc_name;
        commoncell.textLabel.font = [UIFont systemFontOfSize:14];
        commoncell.textLabel.textColor = [UIColor colorWithRGB:@"666666"];
        cell = commoncell;
    }
    else
    {
        GoodsCell *goodscell = [tableView dequeueReusableCellWithIdentifier:@"MTGoodsCell"];
        if(goodscell == nil)
            goodscell = [GoodsCell goodsCell];
        
        [goodscell setitemWithData:goodsDataProvider[indexPath.row]];
        
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
    if (tableView == self.positionTableView)
    {
        selectedClassItem = self.goodsClass[indexPath.row];
        currentPageIdx = 1;
        goodsDataProvider = [[NSMutableArray alloc] init];
        [self getDataProvider];
    }else
    {
        GoodsHeadViewController *goodsvc = [[GoodsHeadViewController alloc] init];
        GoodsInfoModel *item = goodsDataProvider[indexPath.row];
        goodsvc.goodsID =  item.goods_id;
        [self.navigationController pushViewController:goodsvc animated:YES];
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
