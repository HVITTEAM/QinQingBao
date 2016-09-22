//
//  QCListViewController.m
//  QCSliderTableView
//
//  Copyright (c) 2014年 Scasy. All rights reserved.
//

#import "GoodsListViewController.h"
#import "OrderModel.h"
#import "OrderTotals.h"
#import "OrderDetailController.h"
#import "GoodsCell.h"
#import "GoodsHeadViewController.h"
#import "GoodsInfoModel.h"
#import "GoodsInfoTotal.h"

@interface GoodsListViewController ()
{
    /**商品信息model*/
    NSMutableArray *goodsDataProvider;
    
    //当前第一页
    NSInteger currentPageIdx;
    
    //总共多少页
    NSInteger totalPage;
}

@end

@implementation GoodsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableviewSkin];
    
    [self setupRefresh];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidCurrentView
{
    NSLog(@"加载为当前视图 = %@",self.title);
    currentPageIdx = 1;
    goodsDataProvider = [[NSMutableArray alloc] init];
    [self dataRereshing];
}

/** 屏蔽tableView的样式 */
- (id)init
{
    self.hidesBottomBarWhenPushed = YES;
    return [self initWithStyle:UITableViewStyleGrouped];
}

/**
 *  设置tableView属性
 */
-(void)initTableviewSkin
{
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.sectionFooterHeight = 10;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(-25, 0, -25, 0);
}

#pragma mark 集成刷新控件

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 上拉刷新
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        currentPageIdx ++ ;
        [self dataRereshing];
    }];
}

#pragma mark 开始进入刷新状态
- (void)dataRereshing
{
    if (totalPage && currentPageIdx > totalPage)
    {
        [self.tableView.footer endRefreshing];
        self.noneResultHandler();
        currentPageIdx --;
        return;
    }
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *invokeType;
    if ([self.title isEqualToString:@"销量"])
    {
        invokeType =  @"1";
    }
    else if ([self.title isEqualToString:@"综合"])
    {
        invokeType =  @"2";

    }
    else if ([self.title isEqualToString:@"价格"])
    {
        invokeType =  @"3";

    }
    else if ([self.title isEqualToString:@"新品"])
    {
        invokeType =  @"4";
    }
    [CommonRemoteHelper RemoteWithUrl:URL_Goods_list parameters: @{@"gc_id" : self.gc_id.length>0 ? self.gc_id : @"0",
                                                                   @"keyword" : self.keyWords.length>0 ? self.keyWords : @"0",
                                                                   @"key" : invokeType,
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
                                         [self.tableView initWithPlaceString:@"暂无数据!" imgPath:nil];
                                     }
                                     else if (result.goods_list.count == 0 && currentPageIdx > 1)
                                     {
                                         [self.tableView removePlace];
                                         NSLog(@"没有更多的数据了");
                                         currentPageIdx --;
                                     }
                                     else
                                     {
                                         [self.tableView removePlace];
                                     }
                                     [goodsDataProvider addObjectsFromArray:[result.goods_list copy]];
                                     [self.tableView reloadData];
                                     [self.tableView.footer endRefreshing];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     [HUD removeFromSuperview];
                                 }];
}

#pragma mark - 表格视图数据源代理方法


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return goodsDataProvider.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsCell *goodscell = [tableView dequeueReusableCellWithIdentifier:@"MTGoodsCell"];
    if(goodscell == nil)
        goodscell = [GoodsCell goodsCell];
    
    [goodscell setitemWithData:goodsDataProvider[indexPath.row]];
    
    return  goodscell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsHeadViewController *goodsvc = [[GoodsHeadViewController alloc] init];
    GoodsInfoModel *item = goodsDataProvider[indexPath.row];
    goodsvc.goodsID =  item.goods_id;
    [self.nav pushViewController:goodsvc animated:YES];
}

/**
 *  回调方法
 *
 *  @param indexPath indexPath description
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //KVO
    [self setValue:@"0" forKey:@"needFlesh"];
    [self addObserver:self forKeyPath:@"needFlesh" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
    if([keyPath isEqualToString:@"needFlesh"])
    {
        [self dataRereshing];
    }
}


@end
