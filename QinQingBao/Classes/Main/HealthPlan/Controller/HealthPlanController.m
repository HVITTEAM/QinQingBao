//
//  HealthPlanController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/8/17.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "HealthPlanController.h"

#import "CommonPlanCell.h"
#import "CommonPlanModel.h"

#import "InterveneController.h"

@interface HealthPlanController ()
{
    NSMutableArray *dataProvider;
    NSInteger currentPageIdx;
    
    CGFloat totla;
}

@end

@implementation HealthPlanController


-(instancetype)init
{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self setupRefresh];
    
    currentPageIdx = 0;
    dataProvider = [[NSMutableArray alloc] init];
    
    [self getDataProvider];
    
//    [self downimg];
}

-(void)downimg
{
    currentPageIdx ++;
    UInt64 start = [[NSDate date] timeIntervalSince1970]*1000;
    NSURL *iconUrl = [NSURL URLWithString:@"http://app.hvit.com.cn/one/image/14_05075737633549572_1280.jpg"];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    [manager downloadImageWithURL:iconUrl options:SDWebImageCacheMemoryOnly progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        UInt64 finish = [[NSDate date] timeIntervalSince1970]*1000;
        NSLog(@"单次耗时%llu", finish - start);
        
        totla = totla + (finish - start);
        CGFloat cvg  = totla/currentPageIdx;
        
        NSLog(@"总值%.0f,次数%ld,平均值%.0f",totla,(long)currentPageIdx,cvg);
        
        [[SDImageCache sharedImageCache] cleanDisk];
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];
        [self downimg];
    }];
}

-(void)initView
{
    self.title = @"健康计划";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.view.backgroundColor = HMGlobalBg;
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
        [self getDataProvider];
    }];
    
    //下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        currentPageIdx = 1;
        [dataProvider removeAllObjects];
        [self getDataProvider];
    }];
}

/**
 *  获取数据源
 */
-(void)getDataProvider
{
    MBProgressHUD *HUD;
    if (currentPageIdx == 1)
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Get_healthplan_list parameters:@{@"page" : @"10",
                                                                           @"p" : [NSString stringWithFormat:@"%li",(long)currentPageIdx],
                                                                           @"key":[SharedAppUtil defaultCommonUtil].userVO.key,
                                                                           @"client":@"ios"
                                                                           }
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     NSArray *arr;
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         
                                     }
                                     else
                                     {
                                         arr = [CommonPlanModel objectArrayWithKeyValuesArray:[dict objectForKey:@"datas"]];
                                         
                                         [self.tableView reloadData];
                                     }
                                     
                                     [self.tableView removePlace];
                                     if (arr.count == 0 && currentPageIdx == 1)
                                     {
                                         //                                         [self.tableView initWithPlaceString:@"暂无数据!"];
                                         [self showPlaceholderview];
                                     }
                                     else if (arr.count == 0 && currentPageIdx > 1)
                                     {
                                         NSLog(@"没有更多的数据了");
                                         currentPageIdx --;
                                         [self.view showNonedataTooltip];
                                     }
                                     [dataProvider addObjectsFromArray:arr];
                                     [self.tableView reloadData];
                                     [self.tableView.footer endRefreshing];
                                     [self.tableView.header endRefreshing];
                                     [HUD removeFromSuperview];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [NoticeHelper AlertShow:@"获取失败!" view:self.view];
                                     [self.tableView.footer endRefreshing];
                                     [self.tableView.header endRefreshing];
                                     [HUD removeFromSuperview];
                                 }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataProvider.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 145;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonPlanCell *commonPlanCell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonPlanCell"];
    
    if(commonPlanCell == nil)
        commonPlanCell = [CommonPlanCell commonPlanCell];
    
    
    if (self.tableView.header.state != MJRefreshStateRefreshing)
    {
        commonPlanCell.item = dataProvider[indexPath.section];
    }
    
    return commonPlanCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonPlanModel *model = dataProvider[indexPath.section];
    InterveneController *view = [[InterveneController alloc] init];
    view.wid = model.wid;
    [self.navigationController pushViewController:view animated:YES];
}

-(void)showPlaceholderview
{
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PlaceholderPlan.png"]];
    img.width = 160;
    img.height = 160;
    img.x = (self.view.width - img.width)/2;
    img.y = 70;
    [self.view addSubview:img];
    
    UILabel *la = [[UILabel alloc] init];
    la.textColor = MTNavgationBackgroundColor;
    CGSize size = [@"你还没有专属的健康计划" sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Helvetica Neue" size:16] }];
    la.size = size;
    la.text = @"你还没有专属的健康计划";
    la.x = (self.view.width - la.width)/2;
    la.y = CGRectGetMaxY(img.frame) + 10;
    [self.view addSubview:la];
    
    UILabel *la1 = [[UILabel alloc] init];
    la1.textColor = [UIColor lightGrayColor];
    CGSize size1 = [@"咨询热线: 400-151-2626" sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Helvetica Neue" size:14] }];
    la1.size = size1;
    la1.text = @"咨询热线: 400-151-2626";
    la1.x = (self.view.width - la1.width)/2;
    la1.y = CGRectGetMaxY(la.frame) + 10;
    [self.view addSubview:la1];
}

@end
