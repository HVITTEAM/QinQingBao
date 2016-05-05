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

#import "MTNetReloader.h"

#import "CCLocationManager.h"

#import "CitiesViewController.h"
#import "ArticleModel.h"

#import "CommonArticleCell.h"


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
    [titleView removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:titleView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self initView];
    
    [self getAdvertisementpic];
    
    [self getNewsData];
    
    headview.nav = self.navigationController;
}

- (void)initView
{
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"HomeHeadView" owner:nil options:nil];
    self.tableView.tableHeaderView.height = 350;
    self.tableView.tableHeaderView = [nibs lastObject];
    headview = (HomeHeadView *)self.tableView.tableHeaderView;
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.tabBarItem.title = @"首页";
#warning frame 有问题 暂时这样解决
    titleView = [[UIImageView alloc] initWithFrame:CGRectMake(MTScreenW/2- 80, -90, 160, 284)];
    titleView.image = [UIImage imageNamed:@"banner.png"];
    
    
    cityBtn = [[UIButton alloc] init];
    cityBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    if ([SharedAppUtil defaultCommonUtil].cityVO)
        [cityBtn setTitle:[SharedAppUtil defaultCommonUtil].cityVO.dvname forState:UIControlStateNormal];
    [self initLocation];
    
    //给button添加image
    [cityBtn setImage:[UIImage imageNamed:@"icon_Arrow.png"] forState:UIControlStateNormal];
    //设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    
    //按钮文字
    cityBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    cityBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -14, 0, 0);
    [cityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    CGSize size = [cityBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:cityBtn.titleLabel.font}];
    cityBtn.frame = CGRectMake(0, 0,size.width + 30, 40);
    cityBtn.imageEdgeInsets = UIEdgeInsetsMake(16,size.width,12,10);
    
    [cityBtn addTarget:self action:@selector(cityChange) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:cityBtn];
    [backButton setStyle:UIBarButtonItemStyleDone];
    [self.navigationItem setLeftBarButtonItem:backButton];
}

#pragma mark   初始化地图定位功能

/**
 *  初始化地图定位功能
 */
-(void)initLocation
{
    //获取定位城市和地区block
    [[CCLocationManager shareLocation] getCityAndArea:^(NSString *addressString) {
        if (addressString) {
            [self getLocationCity:addressString];
        }
    }];
    
    [[CCLocationManager shareLocation] getLocationError:^(NSString *addressString) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示消息"
                                                        message:@"需要开启定位服务,请到设置->隐私,打开定位服务"
                                                       delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
        [SharedAppUtil defaultCommonUtil].lat = @"0";
        [SharedAppUtil defaultCommonUtil].lon = @"0";
        
        return [self getLocationCity:addressString];
    }];
}

#pragma mark 获取定位城市的dvname

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
    citiesVc.selectedCity =  cityBtn.titleLabel.text;
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
                                     [self showPlaceHolderView];
                                     [NoticeHelper AlertShow:@"获取失败!" view:self.view];
                                 }];
}

/**
 *  获取资讯文章列表
 */
-(void)getNewsData
{
    [CommonRemoteHelper RemoteWithUrl:URL_get_articles parameters:@{@"page" : @1000,
                                                                    @"p" : @1,
                                                                    @"type" : @0}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     NSDictionary *dict1 =  [dict objectForKey:@"datas"];
                                     
                                     dataProvider = [ArticleModel objectArrayWithKeyValuesArray:dict1];
                                     
                                     [self.tableView reloadData];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self showPlaceHolderView];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        return 44;
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *commoncell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonCell"];
    
    CommonArticleCell *articlecell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonArticleCell"];
    
    commoncell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (commoncell == nil)
        commoncell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MTCommonCell"];
    
    if (indexPath.row == 0)
    {
        commoncell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        commoncell.textLabel.text = @"健康·生活";
        return commoncell;
    }
    else
    {
        if (articlecell == nil)
            articlecell = [CommonArticleCell commonArticleCell];
        
        ArticleModel *item = dataProvider[indexPath.row - 1];
        
        articlecell.titleLab.text = item.title;
        articlecell.subtitleLab.text = item.subtitle;
        NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Img,item.logo_url]];
        [articlecell.headImg sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
        return articlecell;
    }
}

#pragma mark Net Error
/**
 * 显示异常界面
 **/
-(void)showPlaceHolderView
{
    MTNetReloader *netReloader = [[MTNetReloader alloc] initWithFrame:self.view.frame
                                                          reloadBlock:^{
                                                              NSLog(@"Reload") ;
                                                              [netReloader dismiss] ;
                                                              [self getAdvertisementpic];
                                                          }] ;
    [netReloader showInView:self.view];
}

@end
