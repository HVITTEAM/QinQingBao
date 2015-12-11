//
//  HomeViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/8/12.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//  ----------------------系统首页----------------------------


static NSString *kcellIdentifier = @"collectionCellID";

#define pageControlY  175

static float cellHeight = 80;
static float cellWidth = 66;

#import "HomeViewController.h"
#import "ServiceTypeDatas.h"
#import "ServiceTypeModel.h"
#import "AllServiceTypeController.h"
#import "WebViewController.h"
#import "CitiesViewController.h"
#import "AdvertisementViewController.h"
#import "CCLocationManager.h"


@interface HomeViewController ()<MTCityChangeDelegate>
{
    NSMutableArray *dataProvider;
    UIButton * button_back;
}

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self initImagePlayer];
    
    [self initCollectionView];
    
    [self getTypeList];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [SharedAppUtil defaultCommonUtil].mainNav.navigationBarHidden = YES;
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.imgWidth.constant = MTScreenW/2;
    self.bgScrollView.delegate = self;
    self.bgScrollView.backgroundColor = HMGlobalBg;
    
    self.title = @"亲情宝";
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSFontAttributeName:[UIFont systemFontOfSize:17],
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.bgScrollView.height = pageControlY;
    [self.healthBtn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [self.healthBtn setBackgroundImage:[UIImage imageWithColor:HMGlobalBg] forState:UIControlStateHighlighted];
    
    self.bgScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.serviceColectionview.frame));
    float f = CGRectGetMaxY(self.serviceColectionview.frame);
    NSLog(@"屏幕高度%f",f);
    
    button_back = [[UIButton alloc] init];
    button_back.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    [button_back setTitle:[CCLocationManager shareLocation].lastCity forState:UIControlStateNormal];
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
//    [self.navigationItem setLeftBarButtonItem:backButton];
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
    // 初始化 数组 并添加四张图片
    self.slideImages = [[NSMutableArray alloc] init];
    [self.slideImages addObject:@"1-1.png"];
    [self.slideImages addObject:@"1-2.png"];
    [self.slideImages addObject:@"1-3.png"];
    //    [self.slideImages addObject:@"1-4.jpg"];
    
    // 初始化 pagecontrol
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(110, pageControlY, 100, 18)]; // 初始化mypagecontrol
    [self.pageControl setCurrentPageIndicatorTintColor:[UIColor orangeColor]];
    [self.pageControl setPageIndicatorTintColor:[UIColor grayColor]];
    self.pageControl.numberOfPages = [self.slideImages count];
    self.pageControl.currentPage = 0;
    [self.view addSubview:self.pageControl];
    
    //解决初始化imageplayer可能发生偏移的问题
    self.imgPlayer.width = MTScreenW;
    
    // 创建四个图片 imageview
    for (int i = 0; i < self.slideImages.count; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.slideImages objectAtIndex:i]]];
        imageView.frame = CGRectMake((MTScreenW * i) + MTScreenW, 0, MTScreenW, self.imgPlayer.height);
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.userInteractionEnabled=YES;
        imageView.tag = i;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage:)];
        [imageView addGestureRecognizer:singleTap];
        [self.imgPlayer addSubview:imageView]; // 首页是第0页,默认从第1页开始的。所以+320。。。
    }
    
    // 取数组最后一张图片 放在第0页
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.slideImages objectAtIndex:([self.slideImages count]-1)]]];
    imageView.frame = CGRectMake(0, 0, MTScreenW, self.imgPlayer.height); // 添加最后1页在首页 循环
    [self.imgPlayer addSubview:imageView];
    
    // 取数组第一张图片 放在最后1页
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.slideImages objectAtIndex:0]]];
    imageView.frame = CGRectMake((MTScreenW * ([self.slideImages count] + 1)) , 0, MTScreenW, self.imgPlayer.height);
    [self.imgPlayer addSubview:imageView];
    
    [self.imgPlayer setContentSize:CGSizeMake(MTScreenW * ([self.slideImages count] + 2), self.imgPlayer.height)];
    [self.imgPlayer setContentOffset:CGPointMake(0, 0)];
    [self.imgPlayer scrollRectToVisible:CGRectMake(MTScreenW, 0, MTScreenW, self.imgPlayer.height) animated:NO];
}

/**
 *  轮播广告点击事件
 *
 *  @param tap <#tap description#>
 *  @param idx <#idx description#>
 */
-(void)onClickImage:(UITapGestureRecognizer *)tap
{
    //    WebViewController *listView = [[WebViewController alloc] init];
    if (tap.view.tag <= 0)
        return;
    AdvertisementViewController *adver = [[AdvertisementViewController alloc] init];
    adver.type = tap.view.tag;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:adver];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)cityChange
{
    // 2.弹出城市列表
    CitiesViewController *citiesVc = [[CitiesViewController alloc] init];
    citiesVc.delegate  = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:citiesVc];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)selectedChange:(NSString *)city
{
    [button_back setTitle:city forState:UIControlStateNormal];
    CGSize size = [button_back.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:button_back.titleLabel.font}];
    button_back.frame = CGRectMake(0, 0,size.width + 30, 40);
    button_back.imageEdgeInsets = UIEdgeInsetsMake(16,size.width,12,10);
    
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

-(void)getTypeList
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Typelist parameters: @{@"tid" : @1,
                                                                 @"client" : @"ios",
                                                                 @"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
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
                                     [NoticeHelper AlertShow:@"获取失败!" view:self.view];
                                 }];
}

#pragma mark -- UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (sender == self.bgScrollView)
    {
        self.pageControl.y = pageControlY - sender.contentOffset.y - self.navigationController.navigationBar.height;
    }
    else
    {
        CGFloat pagewidth = self.imgPlayer.frame.size.width;
        int page = floor((self.imgPlayer.contentOffset.x - pagewidth/([self.slideImages count]+2))/pagewidth)+1;
        page --;  // 默认从第二页开始
        self.pageControl.currentPage = page;
    }
}

/**
 * scrollview 委托函数
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pagewidth = self.imgPlayer.frame.size.width;
    int currentPage = floor((self.imgPlayer.contentOffset.x - pagewidth/ ([self.slideImages count]+2)) / pagewidth) + 1;
    if (currentPage==0)
    {
        [self.imgPlayer scrollRectToVisible:CGRectMake(MTScreenW * [self.slideImages count],0,MTScreenW,self.imgPlayer.height) animated:NO]; // 序号0 最后1页
    }
    else if (currentPage==([self.slideImages count]+1))
    {
        [self.imgPlayer scrollRectToVisible:CGRectMake(MTScreenW,0,MTScreenW,self.imgPlayer.height) animated:NO]; // 最后+1,循环第1页
    }
}

/**
 * pagecontrol 选择器的方法
 */
- (void)turnPage
{
    NSInteger page = self.pageControl.currentPage; // 获取当前的page
    [self.imgPlayer scrollRectToVisible:CGRectMake(MTScreenW * (page+1) , 0 ,MTScreenW, self.imgPlayer.height) animated:NO]; // 触摸pagecontroller那个点点 往后翻一页 +1
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataProvider.count > 8 ? 8 :dataProvider.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //重用cell
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kcellIdentifier forIndexPath:indexPath];
    //赋值
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    UILabel *label = (UILabel *)[cell viewWithTag:2];
    ServiceTypeModel *data = [dataProvider objectAtIndex:indexPath.row];
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://ibama.hvit.com.cn/public/%@",data.url]];
    
    if (dataProvider.count > 8)
    {
        if (indexPath.row == 7)
        {
            [imageView sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
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
 *  设置横向间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (self.view.width == 414)//如果是plus
        return 30;
    else
        return (self.view.width - cellWidth*4)/8;
}

/**
 *  设置竖向间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 5, 10);//分别为上、左、下、右
}

#pragma mark --UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceTypeModel *item = [dataProvider objectAtIndex:indexPath.row];
    if (dataProvider.count > 8 && indexPath.row == 7)
    {
        AllServiceTypeController *alllist = [[AllServiceTypeController alloc] init];
        alllist.dataProvider = dataProvider;
        return [[SharedAppUtil defaultCommonUtil].mainNav pushViewController:alllist animated:YES];
    }
    ServiceListViewController *listView = [[ServiceListViewController alloc] init];
    listView.item = item;
    [[SharedAppUtil defaultCommonUtil].mainNav pushViewController:listView animated:YES];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (IBAction)healthClickHandler:(id)sender
{
    return [NoticeHelper AlertShow:@"暂未开通!" view:self.view];
    HealthServicesController *healthVC = [[HealthServicesController alloc] init];
    [self.navigationController pushViewController: healthVC animated:YES];
}

- (IBAction)questionClickHander:(id)sender
{
    return [NoticeHelper AlertShow:@"暂未开通!" view:self.view];
    HealthServicesController *healthVC = [[HealthServicesController alloc] init];
    [self.navigationController pushViewController: healthVC animated:YES];
}

@end
