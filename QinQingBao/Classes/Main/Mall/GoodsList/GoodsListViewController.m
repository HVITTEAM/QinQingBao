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

@interface GoodsListViewController ()<UIActionSheetDelegate>
{
    NSMutableArray *dataProvider;
    NSInteger currentPageIdx;
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
    dataProvider = [[NSMutableArray alloc] init];
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
    return;
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dict = [[NSDictionary alloc] init];
    
    if ([self.title isEqualToString:@"全部订单"])
    {
        dict =  @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                  @"client" : @"ios",
                  @"member_id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                  @"p" : [NSString stringWithFormat:@"%li",(long)currentPageIdx],
                  @"page" : @"100",
                  @"get_type" : @"0"};
    }
    else if ([self.title isEqualToString:@"待付款"])
    {
        dict =  @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                  @"client" : @"ios",
                  @"member_id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                  @"p" : [NSString stringWithFormat:@"%li",(long)currentPageIdx],
                  @"pay_staus" : @"0",
                  @"page" : @"100",
                  @"get_type" : @"0"};
    }
    else if ([self.title isEqualToString:@"受理中"])
    {
        dict =  @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                  @"client" : @"ios",
                  @"member_id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                  @"p" : [NSString stringWithFormat:@"%li",(long)currentPageIdx],
                  @"status" : @"0,9",
                  @"page" : @"100",
                  @"get_type" : @"2"};
    }
    else if ([self.title isEqualToString:@"待评价"])
    {
        dict =  @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                  @"client" : @"ios",
                  @"member_id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                  @"p" : [NSString stringWithFormat:@"%li",(long)currentPageIdx],
                  @"status" : @"30,39",
                  @"page" : @"100",
                  @"get_type" : @"2"};
    }
    else if ([self.title isEqualToString:@"取消/售后"])
    {
        dict =  @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                  @"client" : @"ios",
                  @"member_id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                  @"p" : [NSString stringWithFormat:@"%li",(long)currentPageIdx],
                  @"status" : @"50,59",
                  @"page" : @"100",
                  @"get_type" : @"2"};
    }
    [CommonRemoteHelper RemoteWithUrl:URL_Get_workinfo_bystatus parameters: dict
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     OrderTotals *result = [OrderTotals objectWithKeyValues:dict];
                                     NSLog(@"获取到%lu条数据",(unsigned long)result.datas.count);
                                     [self.tableView removePlace];
                                     if (result.datas.count == 0 && currentPageIdx == 1)
                                     {
                                         [self.tableView initWithPlaceString:@"暂无数据!"];
                                     }
                                     else if (result.datas.count == 0 && currentPageIdx > 1)
                                     {
                                         //                                         [NoticeHelper AlertShow:@"没有更多的数据了" view:self.view];
                                         NSLog(@"没有更多的数据了");
                                         currentPageIdx --;
                                         self.noneResultHandler();
                                     }
                                     [dataProvider addObjectsFromArray:[result.datas copy]];
                                     [self.tableView reloadData];
                                     [self.tableView.footer endRefreshing];
                                     [HUD removeFromSuperview];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.tableView.footer endRefreshing];
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
    return 10;
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
    
    [goodscell setitemWithData:nil];
    
    return  goodscell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
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
