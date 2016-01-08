//
//  GoodsHeadViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/7.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "GoodsHeadViewController.h"
#import "GoodsInfoViewController.h"
#import "GoodsDetailEndView.h"
#import "HomePicModel.h"
#import "MTShoppingCarController.h"
#import "EvaluationTotal.h"
#import "GoodsTitleCell.h"
#import "PriceDetailCell.h"
#import "EvaluationCell.h"
#import "EvaluationNoneCell.h"
#import "GoodsDetailViewController.h"
#import "QueryAllEvaluationController.h"


static CGFloat ENDVIEW_HEIGHT = 50;
static CGFloat IMAGEVIEW_HEIGHT;
static CGFloat NAV_HEIGHT = 64;


@interface GoodsHeadViewController ()<UIScrollViewAccessibilityDelegate,UITableViewDataSource,UITableViewDelegate,MTGoodsDetailEndViewDelegate>
{
    /**轮播图片数组*/
    NSMutableArray *slideImages;
    /**广告图片数组*/
    NSMutableArray *advArr;
    
    /**存放image对象数组*/
    NSMutableArray *imgArr;
    
    
    GoodsInfoViewController *detailVC;
    
    NSMutableArray * evaArr;
}

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic, retain) UIScrollView *imgPlayer;

@property (nonatomic,strong) GoodsDetailEndView *endView;

@property (nonatomic,strong) UIPageControl *pageControl;

@end


@implementation GoodsHeadViewController


-(instancetype)init
{
    self = [super init];
    if (self){
        IMAGEVIEW_HEIGHT = MTScreenW *0.9;
        self.view.backgroundColor = [UIColor whiteColor];
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableSkin];
    
    [self initNavigation];
    
    [self getAdvertisementpic];
    
    [self getAlleva];
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"购物车" style:UIBarButtonItemStylePlain target:self action:@selector(gotoShopCar)];
}

-(void)gotoShopCar
{
    MTShoppingCarController *shopCar = [[MTShoppingCarController alloc] init];
    [self.navigationController pushViewController:shopCar animated:YES];
}

-(void)initDragView
{
    detailVC = [[GoodsInfoViewController alloc] init];
    detailVC.view.backgroundColor = HMGlobalBg;
    [self addChildViewController:detailVC];
    
    if (detailVC.tableView != nil)
    {
        self.tableView.secondScrollView = detailVC.tableView;
    }
}

-(void)initTableSkin
{
    self.imgPlayer = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, IMAGEVIEW_HEIGHT)];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView.tableHeaderView = self.imgPlayer;
    
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = HMGlobalBg;
    
    [self.view addSubview:self.tableView];
    
    _endView = [[GoodsDetailEndView alloc]initWithFrame:CGRectMake(0, MTScreenH - ENDVIEW_HEIGHT, MTScreenW,ENDVIEW_HEIGHT)];
     _endView.delegate = self;
    [self.view addSubview:_endView];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH - ENDVIEW_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(UIPageControl *)pageControl
{
    // 初始化 pagecontrol
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((MTScreenW - 100)/2, IMAGEVIEW_HEIGHT - 20 + 64, 100, 18)];     [_pageControl setCurrentPageIndicatorTintColor:[UIColor redColor]];
    [_pageControl setPageIndicatorTintColor:[UIColor grayColor]];
    _pageControl.numberOfPages = [slideImages count];
    _pageControl.currentPage = 0;
    return _pageControl;
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
                                     [NoticeHelper AlertShow:@"获取失败!" view:self.view];
                                 }];
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
    
    [self.view addSubview:self.pageControl];
    
    //    [self initDragView];
    
    //解决初始化imageplayer可能发生偏移的问题
    self.imgPlayer.width = MTScreenW;
    
    imgArr = [[NSMutableArray alloc] init];
    
    // 创建图片 imageview
    for (int i = 0; i < slideImages.count; i++)
    {
        HomePicModel *item = slideImages[i];
        NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_AdvanceImg,item.bc_value]];
        UIImage *img = [UIImage imageNamed:@"IMG_0487.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
        //        [imageView sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"noneImage"]options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //            [imgArr addObject:[UIImage imageNamed:@"IMG_0487.png"]];
        //        }];
        [imgArr addObject:img];
        
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
    [self.view bringSubviewToFront:_pageControl];
    
    [self.imgPlayer setContentSize:CGSizeMake(MTScreenW * ([slideImages count] + 2), self.imgPlayer.height)];
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
    //    HomePicModel *item = advArr[tap.view.tag];
    SWYPhotoBrowserViewController *photoBrowser = [[SWYPhotoBrowserViewController alloc] initPhotoBrowserWithImages:imgArr currentIndex:tap.view.tag];
    [self.navigationController presentViewController:photoBrowser animated:YES completion:nil];
}

#pragma mark -- UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (sender == self.tableView)
    {
        _pageControl.y = IMAGEVIEW_HEIGHT - sender.contentOffset.y - 20;
    }
    else if (sender == self.imgPlayer)
    {
        CGFloat pagewidth = self.imgPlayer.frame.size.width;
        int page = floor((self.imgPlayer.contentOffset.x - pagewidth/([slideImages count]+2))/pagewidth)+1;
        page --;  // 默认从第二页开始
        _pageControl.currentPage = page;
    }
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
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 1 ? 1 : 2;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    GoodsTitleCell *goodsTitleCell = [tableView dequeueReusableCellWithIdentifier:@"MTGoodsTitleCell"];
    
    PriceDetailCell *priceDetailCell = [tableView dequeueReusableCellWithIdentifier:@"MTPriceDetailCell"];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            if(goodsTitleCell == nil)
                goodsTitleCell = [GoodsTitleCell goodsTitleCell];
            
            [goodsTitleCell setIndexPath:indexPath rowsInSection:1];
            [goodsTitleCell setItem];
            cell = goodsTitleCell;
            goodsTitleCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else
        {
            if (priceDetailCell == nil)
                priceDetailCell = [PriceDetailCell priceDetailCell];
            [priceDetailCell setItem];
            cell = priceDetailCell;
            priceDetailCell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else
    {
        if (evaArr.count != 0)
        {
            EvaluationCell *evacell = [tableView dequeueReusableCellWithIdentifier:@"MTEvaCell"];
            
            if(evacell == nil)
                evacell = [EvaluationCell evaluationCell];
            //            [evacell setItemInfo:itemInfo];
            [evacell setEvaItem:evaArr[0]];
            evacell.queryClick  = ^(UIButton *btn){
                //                [self queryAllevaluation];
            };
            cell = evacell;
        }
        else
        {
            EvaluationNoneCell *evanoneCell = [tableView dequeueReusableCellWithIdentifier:@"MTEvanoneCell"];
            if(evanoneCell == nil)
                evanoneCell = [EvaluationNoneCell evanoneCell];
            cell = evanoneCell;
        }
        
    }
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        GoodsDetailViewController *detail = [[GoodsDetailViewController alloc] init];
        [self.navigationController pushViewController:detail animated:YES];
    }
    else
    {
        QueryAllEvaluationController *allevaluation = [[QueryAllEvaluationController alloc] init];
        [self.navigationController pushViewController:allevaluation animated:YES];
    }
}

#pragma mark - MTGoodsDetailEndViewDelegate

-(void)buyRightnowClick:(UIButton *)btn
{
    [NoticeHelper AlertShow:@"商品已添加至购物车!" view:self.view];
}

-(void)add2CarClick:(UIButton *)btn
{
    [NoticeHelper AlertShow:@"立即购买" view:self.view];
}


/**
 *  获取服务评价
 */
-(void)getAlleva
{
    evaArr = [[NSMutableArray alloc] init];
    [CommonRemoteHelper RemoteWithUrl:URL_Get_dis_cont parameters: @{@"iid" : @11,
                                                                     @"page" : @1,
                                                                     @"p" : @1,
                                                                     @"client" : @"ios"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     EvaluationTotal *result = [EvaluationTotal objectWithKeyValues:dict];
                                     evaArr = result.datas;
                                     [self.tableView reloadData];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                 }];
}

@end
