//
//  ServiceListViewController.m
//  QinQinBao
//
//  Created by 董徐维 on 15/6/30.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "ServiceListViewController.h"
#import "DOPDropDownMenu.h"
#import "ServiceTypeDatas.h"
#import "MJChiBaoZiHeader.h"

@interface ServiceListViewController ()<UITableViewDataSource,UITableViewDelegate,DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>
{
    NSMutableArray *dataProvider;
    //当前选中的服务分类 默认为第一条
    ServiceTypeModel *selectedItem;
    DOPDropDownMenu *menu;
    NSInteger currentPageIdx;
    //页面当前是否是刷新状态
    BOOL isflesh;
}

@property (nonatomic, strong) UITableView *tableView;

/**
 *  排序方式
 */
@property (nonatomic,retain) NSString *condition;
@property (nonatomic, strong) NSArray *classifys;
//@property (nonatomic, strong) NSArray *cates;
//@property (nonatomic, strong) NSArray *movices;
//@property (nonatomic, strong) NSArray *hostels;
//@property (nonatomic, strong) NSArray *areas;
@property (nonatomic, strong) NSArray *sorts;
@end

@implementation ServiceListViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //ios7可能会将导航栏下方为原点
    self.edgesForExtendedLayout = UIRectEdgeAll;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self initTableviewSkin];
    
    if (self.selected2edItem)
        self.title = self.selected2edItem.tname;
    else
        self.title = self.item.tname;
    
    [self getServiceType];
    
    self.condition = @"";
}

/**
 *  初始化菜单
 */
-(void)initTopMenu
{
    [self setupRefresh];
    
    // 数据
    //    self.classifys = @[@"全部分类",@"服装加工",@"服装洗涤",@"搬家公司"];
    //    self.cates = @[@"分类1",@"分类2",@"分类3",@"分类4",@"分类5",@"分类6"];
    //    self.movices = @[@"服装洗涤1",@"服装洗涤2",@"服装洗涤3"];
    //    self.hostels = @[@"搬家公司1",@"搬家公司2",@"搬家公司3",@"搬家公司4",@"搬家公司5"];
    //    self.areas = @[@"地区",@"西湖区",@"上城区",@"下城区",@"滨江区",@"余杭区"];
    self.sorts = @[@"智能排序",@"好评优先",@"离我最近"];
    // 添加下拉菜单
    menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 62) andHeight:44];
    menu.delegate = self;
    menu.dataSource = self;
    if (!self.selected2edItem)
        [self.view addSubview:menu];
    if (!selectedItem)
        selectedItem = self.classifys[0];
    
    
    [self.tableView.header beginRefreshing];
    //
    //    DOPIndexPath *index = [[DOPIndexPath alloc] initWithColumn:0 row:2];
    //    [menu selectDefalutIndexPath:index];
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.view.backgroundColor = [UIColor whiteColor];
}

/**
 *  初始化tableView
 */
-(void)initTableviewSkin
{
    self.tableView = [[UITableView alloc] initWithFrame:
                      CGRectMake(0, self.selected2edItem ? 0 : 42, MTScreenW, self.selected2edItem ? MTScreenH : MTScreenH - 44)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

-(void)setSelected2edItem:(ServiceTypeModel *)selected2edItem
{
    _selected2edItem = selected2edItem;
    selectedItem = selected2edItem;
}

#pragma mark 集成刷新控件

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    currentPageIdx = 1;
    dataProvider = [[NSMutableArray alloc] init];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    //    MJChiBaoZiHeader *head = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    //    self.tableView.header = head;
    //    head.lastUpdatedTimeLabel.hidden = YES;
    //    head.stateLabel.hidden = YES;
    
    // 下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dataProvider = [[NSMutableArray alloc] init];
        [self headerRereshing];
    }];
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        currentPageIdx ++ ;
        [self footerRereshing];
    }];
}

/**
 *  获取菜头部的查询条件 服务类别
 */
-(void)getServiceType
{
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
    [CommonRemoteHelper RemoteWithUrl:URL_Typelist parameters: @{@"tid" : self.item.tid,
                                                                 @"client" : @"ios",
                                                                 @"p" : @1,
                                                                 @"page" : @100}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     ServiceTypeDatas *result = [ServiceTypeDatas objectWithKeyValues:dict];
                                     if (!result.datas)
                                         self.classifys = [[NSMutableArray alloc] initWithObjects:self.item, nil];
                                     else
                                         self.classifys = [result.datas copy];
                                     [self initTopMenu];
                                     [SVProgressHUD dismiss];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     [SVProgressHUD dismiss];
                                 }];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    if (!isflesh)
        [self getDataProviderWithConditon:self.condition];
}

- (void)footerRereshing
{
    if (!isflesh)
        [self getDataProviderWithConditon:self.condition];
}

/**
 *  获取数据源
 *
 *  @param condition 排序条件 1分数最高 2距离最近 不传或为空 返回默认排序
 */
-(void)getDataProviderWithConditon:(NSString *)condition
{
    isflesh = YES;
    [CommonRemoteHelper RemoteWithUrl:URL_Iteminfo parameters:  @{@"page" : @10,
                                                                  @"p" : [NSString stringWithFormat:@"%li",(long)currentPageIdx],
                                                                  @"tid" : selectedItem.tid,
                                                                  @"client" : @"ios",
                                                                  @"condition" : condition,
                                                                  @"lat" : [SharedAppUtil defaultCommonUtil].lat ? [SharedAppUtil defaultCommonUtil].lat : @"",
                                                                  @"lon" : [SharedAppUtil defaultCommonUtil].lon ? [SharedAppUtil defaultCommonUtil].lon : @"",
                                                                  @"dvcode" : [SharedAppUtil defaultCommonUtil].cityVO ? [SharedAppUtil defaultCommonUtil].cityVO.dvcode : @""}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     ServicesDatas *result = [ServicesDatas objectWithKeyValues:dict];
                                     isflesh = NO;
                                     NSLog(@"获取到%lu条数据",(unsigned long)result.datas.count);
                                     
                                     if (result.datas.count == 0 && currentPageIdx == 1)
                                     {
                                         [self.tableView initWithPlaceString:@"暂无数据!" imgPath:nil];
                                     }
                                     else if (result.datas.count == 0 && currentPageIdx > 1)
                                     {
                                         [self.tableView removePlace];
                                         NSLog(@"没有更多的数据了");
                                         currentPageIdx --;
                                         [self.view showNonedataTooltip];
                                     }
                                     else
                                     {
                                         [self.tableView removePlace];
                                     }
                                     [dataProvider addObjectsFromArray:[result.datas copy]];
                                     
                                     [self.tableView reloadData];
                                     [self.tableView.header endRefreshing];
                                     [self.tableView.footer endRefreshing];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [NoticeHelper AlertShow:@"获取失败!" view:self.view];
                                     [self.tableView.header endRefreshing];
                                     [self.tableView.footer endRefreshing];
                                     isflesh = NO;
                                 }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataProvider.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ListViewCellId = @"ListViewCellId";
    ServiceListCell *cell = [tableView dequeueReusableCellWithIdentifier:ListViewCellId];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"ServiceListCell" owner:nil options:nil];
        cell = [nibs lastObject];
        // 设置背景view
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (dataProvider && dataProvider.count > 0 )
        [cell setitemWithData:dataProvider[indexPath.row]];
    return  cell;
}

/**
 点击菜单切换视图
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceDetailViewController *palceView = [[ServiceDetailViewController alloc] init];
    palceView.selectedItem = dataProvider[indexPath.row];
    palceView.serviceTypeItem = selectedItem;
    [self.navigationController pushViewController:palceView animated:YES];
}


#pragma mark DOPDropDownMenuDataSource,DOPDropDownMenuDelegate
-(void)menuforwardAction:(BOOL)forward
{
    self.tableView.scrollEnabled = !forward;
}

- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 2;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0) {
        return self.classifys.count;
        //    }else if (column == 1){
        //        return self.areas.count;
    }else {
        return self.sorts.count;
    }
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        ServiceTypeModel *model = (ServiceTypeModel *)self.classifys[indexPath.row];
        return model.tname;
        //    } else if (indexPath.column == 1){
        //        return self.areas[indexPath.row];
    } else {
        return self.sorts[indexPath.row];
    }
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
{
    //    if (column == 0) {
    //        if (row == 0) {
    //            return self.cates.count;
    //        } else if (row == 2){
    //            return self.movices.count;
    //        } else if (row == 3){
    //            return self.hostels.count;
    //        }
    //    }
    return 0;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    //    if (indexPath.column == 0) {
    //        if (indexPath.row == 0) {
    //            return self.cates[indexPath.item];
    //        } else if (indexPath.row == 2){
    //            return self.movices[indexPath.item];
    //        } else if (indexPath.row == 3){
    //            return self.hostels[indexPath.item];
    //        }
    //    }
    return nil;
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.item >= 0) {
        NSLog(@"点击了 %ld - %ld - %ld 项目",indexPath.column,indexPath.row,indexPath.item);
    }else {
        NSLog(@"点击了 %ld - %ld 项目",indexPath.column,indexPath.row);
        if (indexPath.column == 0) {
            selectedItem = self.classifys[indexPath.row];
            [self.tableView.header beginRefreshing];
        }
        else if (indexPath.column == 1) {
            self.condition = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
            [self.tableView.header beginRefreshing];
        }
        else if (indexPath.column == 2)
            [NoticeHelper AlertShow:@"暂无此功能" view:self.view];
    }
}

@end
