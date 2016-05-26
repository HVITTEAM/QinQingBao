//
//  CXHomeViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/5/5.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CXHomeViewController.h"
#import "HomeHeadView.h"

#import "HomePicTotal.h"
#import "HomePicModel.h"

#import "CCLocationManager.h"

#import "CitiesViewController.h"
#import "ArticleModel.h"

#import "CommonArticleCell.h"

#import "NewsDetailViewControler.h"

#import "SettlementSlideViewController.h"
#import "AllArticleTableViewController.h"

#import "MJChiBaoZiHeader.h"


@interface CXHomeViewController ()<MTCityChangeDelegate>
{
    //广告轮播图
    NSMutableArray *advArr;
    
    UIButton * cityBtn;
    
    HomeHeadView *headview;
    
    UIImageView *titleView;
    
    //资讯数据源
    NSMutableArray *dataProvider;
}

@end

@implementation CXHomeViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self initView];
    
    [self setupRefresh];
    
    [self.tableView.header beginRefreshing];
    
    headview.nav = self.navigationController;
}

#pragma mark 集成刷新控件

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    //    MJChiBaoZiHeader *head = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(getNewsData)];
    //    self.tableView.header = head;
    //    head.lastUpdatedTimeLabel.hidden = YES;
    //    head.stateLabel.hidden = YES;
    
    // 下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getAdvertisementpic];
        [self getNewsData];
    }];
}

- (void)initView
{
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView setSeparatorColor:[UIColor colorWithRGB:@"eeeeee"]];
    
    NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"HomeHeadView" owner:nil options:nil];
    self.tableView.tableHeaderView.height = 350;
    self.tableView.tableHeaderView = [nibs lastObject];
    headview = (HomeHeadView *)self.tableView.tableHeaderView;
    headview.nav = self.navigationController;
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.tabBarItem.title = @"首页";
    
    titleView = [[UIImageView alloc] initWithFrame:CGRectMake(MTScreenW/2- 30, 0, 60, 32)];
    titleView.image = [UIImage imageNamed:@"banner.png"];
    
    self.navigationItem.titleView = titleView;
    
    cityBtn = [[UIButton alloc] init];
    cityBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    
    //如果本地有city信息 就设置为本地的
    if ([SharedAppUtil defaultCommonUtil].cityVO)
        [cityBtn setTitle:[SharedAppUtil defaultCommonUtil].cityVO.dvname forState:UIControlStateNormal];
    else//如果没有本地信息
    {
        [self setLocationCity:@"杭州市"];
    }
    [self initLocation];
    
    //给button添加image
    [cityBtn setImage:[UIImage imageNamed:@"icon_Arrow.png"] forState:UIControlStateNormal];
    //设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    
    //按钮文字
    cityBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    cityBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -14, 0, 0);
    [cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    CGSize size = [cityBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:cityBtn.titleLabel.font}];
    cityBtn.frame = CGRectMake(0, 0,size.width + 30, 40);
    cityBtn.imageEdgeInsets = UIEdgeInsetsMake(16,size.width,12,10);
    
    [cityBtn addTarget:self action:@selector(cityChange) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:cityBtn];
    [backButton setStyle:UIBarButtonItemStyleDone];
    [self.navigationItem setLeftBarButtonItem:backButton];
    
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [rightBtn addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"jiesuan.png"] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"jiesuan.png"] forState:UIControlStateHighlighted];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    //    [self.navigationItem setRightBarButtonItem:rightButton];
}

#pragma mark   初始化地图定位功能

/**
 *  初始化地图定位功能
 */
-(void)initLocation
{
    //获取定位城市和地区block
    [[CCLocationManager shareLocation] getCityAndArea:^(NSString *addressString) {
        if (addressString)
        {
            [self setLocationCity:addressString];
        }
    }];
    
    [[CCLocationManager shareLocation] getLocationError:^(NSString *addressString) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示消息"
                                                        message:addressString
                                                       delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }];
}


/**
 *  根据地址 设置当前的地区
 *
 *  @param locationStr 城市区划
 */
-(void)setLocationCity:(NSString *)locationStr
{
    [cityBtn setTitle: locationStr forState:UIControlStateNormal];
    
    NSArray *dataProvider = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"areaList.plist" ofType:nil]];
    
    for (id item in dataProvider)
    {
        NSArray *arr = [item objectForKey:@"regions"];
        for (id item_sub in arr)
        {
            NSString *cityStr = [item_sub objectForKey:@"name"];
            if ([cityStr isEqualToString:locationStr])
            {
                CityModel *cityVO = [[CityModel alloc] init];
                cityVO.dvcode = [item_sub objectForKey:@"dvcode"];
                cityVO.dvname = [item_sub objectForKey:@"name"];
                [self selectedChange:cityVO.dvname];
                [SharedAppUtil defaultCommonUtil].cityVO = cityVO;
                [ArchiverCacheHelper saveObjectToLoacl:cityVO key:User_LocationCity_Key filePath:User_LocationCity_Path];
                break;
            }
        }
    }
}

#pragma mark 获取定位城市的dvname 已废弃

-(void)getLocationCity:(NSString *)cityStr
{
    [CommonRemoteHelper RemoteWithUrl:URL_Dingwei_conf parameters:@{@"dvname" : cityStr}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         CityModel *cityVO = [CityModel objectWithKeyValues:[dict objectForKey:@"datas"]];
                                         [self selectedChange:cityVO.dvname];
                                         [SharedAppUtil defaultCommonUtil].cityVO = cityVO;
                                         [ArchiverCacheHelper saveObjectToLoacl:cityVO key:User_LocationCity_Key filePath:User_LocationCity_Path];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [NoticeHelper AlertShow:@"获取失败!" view:self.view];
                                 }];
}


#pragma mark MTCityChangeDelegate
-(void)selectedChange:(NSString *)city
{
    [cityBtn setTitle:city forState:UIControlStateNormal];
    CGSize size = [cityBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:cityBtn.titleLabel.font}];
    cityBtn.width = size.width + 30;
    cityBtn.imageEdgeInsets = UIEdgeInsetsMake(16,size.width,12,10);
}

-(void)cityChange
{
    CitiesViewController *citiesVc = [[CitiesViewController alloc] init];
    citiesVc.delegate  = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:citiesVc];
    [self presentViewController:nav animated:YES completion:nil];
}

/**
 * 获取轮播图片
 **/
-(void)getAdvertisementpic
{
    advArr = [[NSMutableArray alloc] init];
    [CommonRemoteHelper RemoteWithUrl:URL_Advertisementpic parameters:@{}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                         return ;
                                     }
                                     
                                     NSDictionary *dict1 =  [dict objectForKey:@"datas"];
                                     
                                     NSArray *picItem = [dict1 objectForKey:@"data"];
                                     
                                     advArr = [[NSMutableArray alloc] init];
                                     for (NSDictionary *item in picItem)
                                     {
                                         HomePicModel *vo = [HomePicModel objectWithKeyValues:item];
                                         [advArr addObject:vo];
                                     }
                                     if(advArr.count > 0)
                                     {
                                         headview.slideImages = advArr;
                                         headview.advArr = advArr;
                                         [headview initImagePlayer];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [NoticeHelper AlertShow:@"获取失败!" view:self.view];
                                 }];
}

/**
 *  获取资讯文章列表
 */
-(void)getNewsData
{
    [self.tableView.header beginRefreshing];
    [CommonRemoteHelper RemoteWithUrl:URL_get_articles parameters:@{@"page" : @5,
                                                                    @"p" : @1,
                                                                    @"type" : @0}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     [self.tableView.header endRefreshing];
                                     NSDictionary *dict1 =  [dict objectForKey:@"datas"];
                                     
                                     dataProvider = [ArticleModel objectArrayWithKeyValuesArray:dict1];
                                     [self.tableView reloadData];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.tableView.header endRefreshing];
                                     [NoticeHelper AlertShow:@"获取失败!" view:self.view];
                                 }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataProvider.count + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        return 44;
    return 94;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *commoncell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonCell"];
    
    CommonArticleCell *articlecell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonArticleCell"];
    
    if (commoncell == nil)
        commoncell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MTCommonCell"];
    commoncell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0)
    {
        commoncell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, 5, 100, 30)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [label setText:@"健康·生活"];
        label.font = [UIFont fontWithName:@"HYQiHei-EZJ" size:11];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor colorWithRGB:@"666666"];
        [commoncell.contentView addSubview:label];
        return commoncell;
    }
    else
    {
        if (articlecell == nil)
            articlecell = [CommonArticleCell commonArticleCell];
        ArticleModel *item = dataProvider[indexPath.row - 1];
        articlecell.titleLab.text = item.title;
        articlecell.subtitle = item.abstract;
        articlecell.commentcountLab.text = item.comment_count;
        NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_ImgArticle,item.logo_url]];
        NSLog(@"图片地址：%@",[NSString stringWithFormat:@"%@%@",URL_ImgArticle,item.logo_url]);
        [articlecell.headImg sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
        return articlecell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        AllArticleTableViewController *view = [[AllArticleTableViewController alloc] init];
        [self.navigationController pushViewController:view animated:YES];
    }
    else
    {
        NewsDetailViewControler *view = [[NewsDetailViewControler alloc] init];
        ArticleModel *item = dataProvider[indexPath.row - 1];
        view.articleItem = item;
        NSString *url;
        if (![SharedAppUtil defaultCommonUtil].userVO)
            url = [NSString stringWithFormat:@"%@/admin/manager/index.php/family/article_detail/%@?key=cxjk&like",URL_Local,item.id];
        else
            url = [NSString stringWithFormat:@"%@/admin/manager/index.php/family/article_detail/%@?key=%@&like",URL_Local,item.id,[SharedAppUtil defaultCommonUtil].userVO.key];
        view.url = url;
        [self.navigationController pushViewController:view animated:YES];
    }
}

/**
 *  结算
 */
-(void)pay
{
    if (![SharedAppUtil defaultCommonUtil].userVO)
        return [MTNotificationCenter postNotificationName:MTNeedLogin object:nil userInfo:nil];
    SettlementSlideViewController *vc = [[SettlementSlideViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
