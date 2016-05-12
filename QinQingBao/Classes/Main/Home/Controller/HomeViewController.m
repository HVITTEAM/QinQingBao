//
//  HomeViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/8/12.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//  ----------------------系统首页----------------------------


static NSString *kcellIdentifier = @"collectionCellID";

static float cellHeight = 80;
static float cellWidth = 66;

#import "HomeViewController.h"
#import "ServiceTypeDatas.h"
#import "ServiceTypeModel.h"
#import "AllServiceTypeController.h"
#import "CitiesViewController.h"
#import "AdvertisementViewController.h"
#import "CCLocationManager.h"
#import "CheckSelfViewController.h"
#import "AllServiceViewController.h"
#import "HomePicTotal.h"
#import "HomePicModel.h"
#import "MTNetReloader.h"


#import "MassageTableViewController.h"

@interface HomeViewController ()<MTCityChangeDelegate>
{
    NSMutableArray *dataProvider;
    /**轮播图片数组*/
    NSMutableArray *slideImages;
    /**广告图片数组*/
    NSMutableArray *advArr;
    
    UIPageControl *pageControl;
    UIButton * button_back;
    
    NSTimer *timer;
    
    float pageControlY;
}

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getAdvertisementpic];
    
    [self initNavigation];
    
    [self initCollectionView];
    
    [self getTypeList];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initView];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [timer invalidate];
}

/**
 *  根据手机的设备  改变视图
 */
-(void)initView
{
    switch ([UIDevice iPhonesModel])
    {
        case iPhone4:
            pageControlY = MTScreenH *0.23 - 15;
            self.imagePlayerHeight.constant = MTScreenH *0.23;
            break;
        case iPhone5:
            self.bgScrollView.scrollEnabled = NO;
            [self autoLayoutView];
            break;
        case iPhone6:
            [self autoLayoutView];
            break;
        case iPhone6Plus:
            [self autoLayoutView];
            break;
        default:
            NSLog(@"UnKnown");
            break;
    }
}

/**
 * 自动布局
 **/
-(void)autoLayoutView
{
    pageControlY = MTScreenH *0.2 - 15;
    self.imagePlayerHeight.constant = MTScreenH *0.2;
    self.buttonTypeHeight.constant = MTScreenH *0.30;
    self.tuinaBtnHeight.constant = self.buttonTypeHeight.constant/2;
    self.vlineTop.constant = self.VlineHeight.constant =  self.tuinaBtnHeight.constant;
    self.checkTop.constant = (self.buttonTypeHeight.constant/2 - self.checkSelfImg.height)/2;
    self.serviceCollectHeight.constant = MTScreenH - self.imagePlayerHeight.constant - self.buttonTypeHeight.constant - CGRectGetMaxY(self.navigationController.navigationBar.frame) - [SharedAppUtil defaultCommonUtil].tabBar.tabBar.height;
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.imgWidth.constant = MTScreenW/2;
    
    float padding = (MTScreenW/2 - CGRectGetMaxX(self.checkSelfImg.frame))/2;
    self.rightPadding.constant = self.leftPadding.constant = self.leftPadding1.constant = padding;
    
    self.bgScrollView.delegate = self;
    self.bgScrollView.backgroundColor = HMGlobalBg;
    
    self.tabBarItem.title = @"首页";
    self.navigationItem.title = @"寸欣健康";
    
    self.bgScrollView.height = pageControlY;
    [self.healthBtn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [self.healthBtn setBackgroundImage:[UIImage imageWithColor:HMGlobalBg] forState:UIControlStateHighlighted];
    
    self.bgScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.serviceColectionview.frame));
    float f = CGRectGetMaxY(self.serviceColectionview.frame);
    NSLog(@"屏幕高度%f",f);
    
    button_back = [[UIButton alloc] init];
    button_back.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    if ([SharedAppUtil defaultCommonUtil].cityVO)
        [button_back setTitle:[SharedAppUtil defaultCommonUtil].cityVO.dvname forState:UIControlStateNormal];
    [self initLocation];
    
    //给button添加image
    [button_back setImage:[UIImage imageNamed:@"icon_Arrow.png"] forState:UIControlStateNormal];
    //设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    
    //按钮文字
    button_back.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button_back.titleEdgeInsets = UIEdgeInsetsMake(0, -14, 0, 0);
    [button_back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    CGSize size = [button_back.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:button_back.titleLabel.font}];
    button_back.frame = CGRectMake(0, 0,size.width + 30, 40);
    button_back.imageEdgeInsets = UIEdgeInsetsMake(16,size.width,12,10);
    
    [button_back addTarget:self action:@selector(cityChange) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button_back];
    [backButton setStyle:UIBarButtonItemStyleDone];
    [self.navigationItem setLeftBarButtonItem:backButton];
}

/**
 *  初始化突变轮播播放器
 */
-(void)initImagePlayer
{
    self.imgPlayer.bounces = YES;
    self.imgPlayer.pagingEnabled = YES;
    self.imgPlayer.delegate = self;
    self.imgPlayer.userInteractionEnabled = YES;
    self.imgPlayer.showsHorizontalScrollIndicator = NO;
    
    // 初始化 pagecontrol
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((MTScreenW - 100)/2, pageControlY, 100, 18)]; // 初始化mypagecontrol
    [pageControl setCurrentPageIndicatorTintColor:[UIColor orangeColor]];
    [pageControl setPageIndicatorTintColor:[UIColor grayColor]];
    pageControl.numberOfPages = [slideImages count];
    pageControl.currentPage = 0;
    [self.bgScrollView addSubview:pageControl];
    
    //解决初始化imageplayer可能发生偏移的问题
    self.imgPlayer.width = MTScreenW;
    
    // 创建图片 imageview
    for (int i = 0; i < slideImages.count; i++)
    {
        HomePicModel *item = slideImages[i];
        NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_AdvanceImg,item.bc_value]];
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"noneImage"]];
        imageView.frame = CGRectMake((MTScreenW * i) + MTScreenW, 0, MTScreenW, self.imgPlayer.height);
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.tag = i;
        imageView.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage:)];
        [imageView addGestureRecognizer:singleTap];
        [self.imgPlayer addSubview:imageView];
    }
    // 取数组最后一张图片 放在第0页
    HomePicModel *item = slideImages[slideImages.count - 1];
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_AdvanceImg,item.bc_value]];
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"noneImage"]];
    imageView.frame = CGRectMake(0, 0, MTScreenW, self.imgPlayer.height); // 添加最后1页在首页 循环
    [self.imgPlayer addSubview:imageView];
    
    // 取数组第一张图片 放在最后1页
    HomePicModel *item0 = slideImages[0];
    imageView = [[UIImageView alloc] init];
    NSURL *iconUrl1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_AdvanceImg,item0.bc_value]];
    [imageView sd_setImageWithURL:iconUrl1 placeholderImage:[UIImage imageWithName:@"noneImage"]];
    imageView.frame = CGRectMake((MTScreenW * ([slideImages count] + 1)) , 0, MTScreenW, self.imgPlayer.height);
    [self.imgPlayer addSubview:imageView];
    
    [self.imgPlayer setContentSize:CGSizeMake(MTScreenW * ([slideImages count] + 2), self.imgPlayer.height)];
    [self.imgPlayer setContentOffset:CGPointMake(0, 0)];
    [self.imgPlayer scrollRectToVisible:CGRectMake(MTScreenW, 0, MTScreenW, self.imgPlayer.height) animated:NO];
    
    [self initTimer];
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
            
            //            [button_back setTitle:addressString forState:UIControlStateNormal];
            //            CGSize size = [button_back.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:button_back.titleLabel.font}];
            //            button_back.width = size.width + 30;
            //            button_back.imageEdgeInsets = UIEdgeInsetsMake(16,size.width,12,10);
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

#pragma mark 初始化轮播广告定时器
/**
 *  初始化定时器
 **/
-(void)initTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
}

-(void)timerFireMethod:(NSTimer *)theTimer
{
    [self turn2Page:pageControl.currentPage + 1];
}

/**
 *  轮播广告点击事件
 *
 *  @param tap <#tap description#>
 *  @param idx <#idx description#>
 */
-(void)onClickImage:(UITapGestureRecognizer *)tap
{
    HomePicModel *item = advArr[tap.view.tag];
    if (item.bc_article_url.length == 0)
        return;
    AdvertisementViewController *adver = [[AdvertisementViewController alloc] init];
    adver.type = tap.view.tag;
    adver.selectedItem = item;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:adver];
    [self presentViewController:nav animated:YES completion:nil];
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
    [button_back setTitle:city forState:UIControlStateNormal];
    CGSize size = [button_back.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:button_back.titleLabel.font}];
    button_back.width = size.width + 30;
    button_back.imageEdgeInsets = UIEdgeInsetsMake(16,size.width,12,10);
}

-(void)cityChange
{
    // 2.弹出城市列表
    CitiesViewController *citiesVc = [[CitiesViewController alloc] init];
    citiesVc.delegate  = self;
    citiesVc.selectedCity =  button_back.titleLabel.text;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:citiesVc];
    [self presentViewController:nav animated:YES completion:nil];
}

/**
 *  初始化服务类别列表
 */
-(void)initCollectionView
{
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    self.serviceColectionview.collectionViewLayout = flowLayout;
    self.serviceColectionview.backgroundColor = [UIColor whiteColor];
    self.serviceColectionview.scrollEnabled = NO;
    [self.serviceColectionview registerNib:[UINib nibWithNibName:@"SQCollectionCell" bundle:nil] forCellWithReuseIdentifier:kcellIdentifier];
    self.serviceColectionview.delegate = self;
    self.serviceColectionview.dataSource = self;
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
                                     
                                     slideImages = advArr;
                                     if(slideImages.count > 0)
                                         [self initImagePlayer];
                                     
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self showPlaceHolderView];
                                     [NoticeHelper AlertShow:@"获取失败!" view:self.view];
                                 }];
}

-(void)getTypeList
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Typelist parameters: @{@"tid" : @1,
                                                                 @"client" : @"ios",
                                                                 @"p" : @1,
                                                                 @"page" : @100}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     [HUD removeFromSuperview];
                                     ServiceTypeDatas *result = [ServiceTypeDatas objectWithKeyValues:dict];
                                     NSLog(@"获取到%lu条数据",(unsigned long)result.datas.count);
                                     if (result.datas.count == 0)
                                     {
                                         [NoticeHelper AlertShow:@"暂无数据" view:self.view];
                                         return;
                                     }
                                     dataProvider = result.datas;
                                     [self.serviceColectionview reloadData];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                     [self showPlaceHolderView];
                                     [NoticeHelper AlertShow:@"获取失败!" view:self.view];
                                 }];
}

#pragma mark -- UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (sender == self.bgScrollView)
    {
        //        pageControl.y = pageControlY - sender.contentOffset.y - self.navigationController.navigationBar.height - 10;
    }
    else
    {
        CGFloat pagewidth = self.imgPlayer.frame.size.width;
        int page = floor((self.imgPlayer.contentOffset.x - pagewidth/([slideImages count]+2))/pagewidth)+1;
        page --;  // 默认从第二页开始
        pageControl.currentPage = page;
    }
}

/**
 * 手动时暂停
 **/
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [timer invalidate];
}

/**
 * scrollview 委托函数
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pagewidth = self.imgPlayer.frame.size.width;
    int currentPage = floor((self.imgPlayer.contentOffset.x - pagewidth/ ([slideImages count]+2)) / pagewidth) + 1;
    if (currentPage==0)
    {
        [self.imgPlayer scrollRectToVisible:CGRectMake(MTScreenW * [slideImages count],0,MTScreenW,self.imgPlayer.height) animated:NO]; // 序号0 最后1页
    }
    else if (currentPage==([slideImages count]+1))
    {
        [self.imgPlayer scrollRectToVisible:CGRectMake(MTScreenW,0,MTScreenW,self.imgPlayer.height) animated:NO]; // 最后+1,循环第1页
    }
    
    [self initTimer];
}

/**
 * pagecontrol 选择器的方法
 */
- (void)turn2Page:(NSInteger)idx
{
    if (idx == slideImages.count)
        idx = 0;
    pageControl.currentPage = idx;
    [self.imgPlayer scrollRectToVisible:CGRectMake(MTScreenW * (idx+1) , 0 ,MTScreenW, self.imgPlayer.height) animated:YES];
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}


//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //重用cell
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kcellIdentifier forIndexPath:indexPath];
    //赋值
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    UILabel *label = (UILabel *)[cell viewWithTag:2];
    NSInteger index = indexPath.section *4 + indexPath.row;
    ServiceTypeModel *data = [dataProvider objectAtIndex:index];
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Img,data.url]];
    
    if (dataProvider.count > 8)
    {
        if (indexPath.row == 7)
        {
            imageView.image = [UIImage imageWithName:@"more.png"];
            label.text = @"全部分类";
            return cell;
        }
    }
    [imageView sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
    label.text = data.tname;
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(cellWidth, cellHeight);
}

/**
 *  设置横向间距 设置最小列间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return (self.view.width - cellWidth*4)/5;
}

/**
 *  设置竖向间距 设置最小行间距
 */
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 0;
//}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    float VSpace = (self.serviceCollectHeight.constant - cellHeight*2)/4;
    float HSpace = (self.view.width - cellWidth*4)/8;
    
    if (section == 0)
        return UIEdgeInsetsMake(VSpace, HSpace, VSpace, HSpace);//分别为上、左、下、右
    else
        return UIEdgeInsetsMake(0, HSpace, VSpace, HSpace);//分别为上、左、下、右
    
}

#pragma mark --UICollectionViewDelegate，

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.section *4 + indexPath.row;
    ServiceTypeModel *item = [dataProvider objectAtIndex:index];
    if (dataProvider.count >= 8 && index == 7)
    {
        AllServiceViewController *alllist = [[AllServiceViewController alloc] init];
        alllist.dataProvider = dataProvider;
        return [self.navigationController pushViewController:alllist animated:YES];
    }
    ServiceListViewController *listView = [[ServiceListViewController alloc] init];
    listView.item = item;
    [self.navigationController pushViewController:listView animated:YES];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark 症状自查
- (IBAction)healthClickHandler:(id)sender
{
    CheckSelfViewController *healthVC = [[CheckSelfViewController alloc] init];
    [self.navigationController pushViewController:healthVC animated:YES];
}

#pragma mark 专家问诊
- (IBAction)questionClickHander:(id)sender
{
    return [NoticeHelper AlertShow:@"暂未开通!" view:self.view];
    HealthServicesController *healthVC = [[HealthServicesController alloc] init];
    [self.navigationController pushViewController: healthVC animated:YES];
}

#pragma mark 推拿保健
- (IBAction)massageClickHandler:(id)sender
{
    MassageTableViewController *view = [[MassageTableViewController alloc] init];
    [self.navigationController pushViewController:view animated:YES];
    
    //    AdvertisementViewController *adver = [[AdvertisementViewController alloc] init];
    //    adver.type = 5;
    //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:adver];
    //    [self presentViewController:nav animated:YES completion:nil];
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
                                                              [self getTypeList];
                                                          }] ;
    [netReloader showInView:self.view];
}

@end
