//
//  MallRootViewControlelr.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/26.
//  Copyright © 2016年 董徐维. All rights reserved.
//

static CGFloat IMAGEVIEW_HEIGHT;


#import "MallRootViewControlelr.h"
#import "HotGoodsView.h"
#import "SWYNavigationBar.h"
#import "GoodsTypeCell.h"

#import "ConfModel.h"
#import "ConfModelTotal.h"
#import "RecommendGoodsTotal.h"
#import "RecommendGoodsModel.h"
#import "GoodsHeadViewController.h"

#import "MTShoppingCarController.h"
#import "ClassificationViewController.h"
#import "SearchViewController.h"

#import "DiscountCell.h"
#import "SpecialCell.h"

#import "SpecialList.h"
#import "SpecialModel.h"

#import "SpecialDataTotal.h"
#import "SpecialData.h"
#import "SpecialDataItem.h"

#import "GroupbuyTotal.h"
#import "GroupbuyMode.h"

#import "DiscountViewController.h"
#import "SpecialViewController.h"
#import "GoodsDescriptionViewController.h"

#import "GoodsTableViewController.h"
#import "HotGoodsViewController.h"


@interface MallRootViewControlelr ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,NavigationBarDelegate,UITextFieldDelegate,DiscountCellDelegate,SpecialCellDelegate>
{
    /**轮播图片数组*/
    NSMutableArray *slideImages;
    /**商品图片轮播数组*/
    NSMutableArray *advArr;
    
    ConfModelTotal *result;
    /**存放推荐商品对象数组*/
    NSMutableArray *commendGoodsArr;
    
    BOOL imagePlayer;
    
    /**推荐商品view*/
    HotGoodsView *footView;
    
    SWYNavigationBar *customNav;
}


@property(strong,nonatomic)SpecialList *specialList;                     //专题列表数据

@property(strong,nonatomic)GroupbuyTotal *groupbuyTotal;                 //抢购数据

@property(strong,nonatomic)NSTimer *timer;               //定时器

@property(assign,nonatomic)NSUInteger remainTime;    //剩余时间

@property(strong,nonatomic)NSDate *endDate;           //到计时结束时间

@property (nonatomic, retain) UIScrollView *imgPlayer;


@property (nonatomic,strong) UIPageControl *pageControl;

@property (nonatomic,strong) UITableView *tableView;


@end

@implementation MallRootViewControlelr

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadSpecialDatas ];
    
    [self loadGroupbuyData];
    
    [self initTableViewSkin];
    
    [self getConfImages];
    
    [self getRecommendGoods];
    
    [self initNavgation];
}

-(void)initNavgation
{
    UIImageView *bgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 60)];
    bgview.image = [UIImage imageNamed:@"topbg.png"];
    [self.view addSubview:bgview];
    
    UITextField *text = [[UITextField alloc] init];
    text.delegate = self;
    text.layer.cornerRadius = 3;
    text.textColor = [UIColor colorWithRGB:@"979797"];
    text.font = [UIFont systemFontOfSize:14];
    text.alpha = 0.9;
    text.text= @"  铁皮枫斗";
    text.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:text];
    
    customNav = [[SWYNavigationBar alloc] initCustomNavigatinBar];
    customNav.titleView = text;
    customNav.delegate = self;
    customNav.backgroundColor = [UIColor colorWithRed:12/255.0 green:167/255.0 blue:161/255.0 alpha:0];
    customNav.frame = CGRectMake(0, 0, MTScreenW, 64);
    [self.view addSubview:customNav];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self startCountDown];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self stopCountDown];
}

-(void)initTableViewSkin
{
    IMAGEVIEW_HEIGHT = MTScreenW *0.482;
    self.tableView.backgroundColor = HMGlobalBg;
    self.imgPlayer = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, IMAGEVIEW_HEIGHT)];
    self.tableView.tableHeaderView = self.imgPlayer;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    footView = [[HotGoodsView alloc] init];
    footView.frame = CGRectMake(0, 0, MTScreenW, (MTScreenW/2 + 60)*3);
    footView.backgroundColor = [UIColor whiteColor];
    __weak __typeof(self)weakSelf = self;
    footView.clickClick = ^(RecommendGoodsModel *item)
    {
        GoodsHeadViewController *gvc = [[GoodsHeadViewController alloc] init];
        gvc.goodsID = item.goods_id;
        [weakSelf.navigationController pushViewController:gvc animated:YES];
    };
    self.tableView.tableFooterView = footView;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, MTScreenW, MTScreenH)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(UIPageControl *)pageControl
{
    // 初始化 pagecontrol
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((MTScreenW - 100)/2, IMAGEVIEW_HEIGHT - 20, 100, 18)];
    [_pageControl setCurrentPageIndicatorTintColor:[UIColor redColor]];
    [_pageControl setPageIndicatorTintColor:[UIColor grayColor]];
    _pageControl.numberOfPages = [slideImages count];
    _pageControl.currentPage = 0;
    if (_pageControl.numberOfPages == 1)
        _pageControl.hidden = YES;
    return _pageControl;
}

#pragma mark NavigationBarDelegate
-(void)navigationBar:(SWYNavigationBar *)naviBar didClickLeftBtn:(UIButton *)leftBtn
{
    ClassificationViewController *class = [[ClassificationViewController alloc] init];
    [self.navigationController pushViewController:class animated:YES];
}

-(void)navigationBar:(SWYNavigationBar *)naviBar didClickRightBtn:(UIButton *)rightBtn
{
    if (![SharedAppUtil defaultCommonUtil].userVO )
        return [MTNotificationCenter postNotificationName:MTNeedLogin object:nil userInfo:nil];
    MTShoppingCarController *shopCar = [[MTShoppingCarController alloc] init];
    [self.navigationController pushViewController:shopCar animated:YES];
}


/**
 * 获取轮播图片
 **/
-(void)getConfImages
{
    advArr = [[NSMutableArray alloc] init];
    [CommonRemoteHelper RemoteWithUrl:URL_Shopcofn parameters:nil
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     NSDictionary *dict1 =  [dict objectForKey:@"datas"];
                                     result = [ConfModelTotal objectWithKeyValues:dict1];
                                     advArr = result.data;
                                     slideImages = advArr;
                                     //设置商品轮播图
                                     if(slideImages.count > 0)
                                     {
                                         if (imagePlayer)
                                             return ;
                                         [self initImagePlayer];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [NoticeHelper AlertShow:@"获取失败!" view:self.view];
                                 }];
}

/**
 * 获取推荐商品
 **/
-(void)getRecommendGoods
{
    [CommonRemoteHelper RemoteWithUrl:URL_Apiget_goods parameters:nil
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     NSDictionary *dict1 =  [dict objectForKey:@"datas"];
                                     
                                     //设置推荐商品
                                     RecommendGoodsTotal *commendTotal = [RecommendGoodsTotal objectWithKeyValues:dict1];
                                     commendGoodsArr = commendTotal.data;
                                     if(commendGoodsArr.count > 0)
                                         [footView setDataProvider:commendGoodsArr];
                                     
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [NoticeHelper AlertShow:@"获取失败!" view:self.view];
                                 }];
}

#pragma mark 网络相关方法

#pragma mark 网络相关方法
/**
 *  下载专题数据
 */
-(void)loadSpecialDatas
{
    [CommonRemoteHelper RemoteWithUrl:URL_Special_list parameters:nil type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
        NSLog(@"%@",dict);
        
        if ([dict[@"code"]integerValue] != 0) {
            [NoticeHelper AlertShow:@"抱歉,专题数据" view:self.view];
            return;
        }
        
        self.specialList = [SpecialList objectWithKeyValues:dict[@"datas"]];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [NoticeHelper AlertShow:@"抱歉,无法获取到专题数据" view:self.view];
    }];
}

/**
 *  下载抢购专区数据
 */
-(void)loadGroupbuyData
{
    NSDictionary *params = @{
                             @"g_status":@1,
                             @"curpage":@1,
                             @"page":@10
                             };
    
    [CommonRemoteHelper RemoteWithUrl:URL_groupbuy_list parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
        NSLog(@"%@",dict);
        
        if ([dict[@"code"]integerValue] != 0) {
            [NoticeHelper AlertShow:@"抱歉,无法获取到抢购数据" view:self.view];
            return;
        }
        //转换成专题产品模型
        self.groupbuyTotal = [GroupbuyTotal objectWithKeyValues:dict[@"datas"]];
        GroupbuyMode *model = self.groupbuyTotal.data[0];
        self.endDate = [NSDate dateWithTimeIntervalSinceNow:[model.count_down integerValue]];
        [self startCountDown];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [NoticeHelper AlertShow:@"抱歉,无法获取到抢购数据" view:self.view];
    }];
}

/**
 *  初始化突变轮播播放器
 */
-(void)initImagePlayer
{
    imagePlayer = YES;
    self.imgPlayer.bounces = YES;
    self.imgPlayer.pagingEnabled = YES;
    self.imgPlayer.delegate = self;
    self.imgPlayer.userInteractionEnabled = YES;
    self.imgPlayer.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:self.pageControl];
    
    //解决初始化imageplayer可能发生偏移的问题
    self.imgPlayer.width = MTScreenW;
    
    // 创建图片 imageview
    for (int i = 0; i < slideImages.count; i++)
    {
        ConfModel *model = slideImages[i];
        NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/shop/%@%@",URL_Local,result.url,model.image]];
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
    ConfModel *model = slideImages[slideImages.count - 1];
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/shop/%@%@",URL_Local,result.url,model.image]];
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"noneImage"]];
    imageView.frame = CGRectMake(0, 0, MTScreenW, self.imgPlayer.height);
    [self.imgPlayer addSubview:imageView];
    
    imageView = [[UIImageView alloc] init];
    
    ConfModel *model1 = slideImages[0];
    NSURL *iconUrl1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@/shop/%@%@",URL_Local,result.url,model1.image]];
    [imageView sd_setImageWithURL:iconUrl1 placeholderImage:[UIImage imageWithName:@"noneImage"]];
    
    imageView.frame = CGRectMake((MTScreenW * ([slideImages count] + 1)) , 0, MTScreenW, self.imgPlayer.height);
    [self.imgPlayer addSubview:imageView];
    
    [self.tableView addSubview:_pageControl];
    
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
    if (slideImages.count == 0)
        return;
    ConfModel *model = slideImages[tap.view.tag];
    if (model.type.length == 0)
        return;
    if ([model.type isEqualToString:@"url"]) {
        MTProgressWebViewController *vc = [[MTProgressWebViewController alloc] init];
        vc.url = model.data;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([model.type isEqualToString:@"special"]) {
        HotGoodsViewController *vc = [[HotGoodsViewController alloc] init];
        vc.title = model.gc_name;
        vc.special_id = model.data;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([model.type isEqualToString:@"goods"]) {
        GoodsHeadViewController *vc = [[GoodsHeadViewController alloc] init];
        vc.goodsID = model.data;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([model.type isEqualToString:@"keyword"]) {
        GoodsTableViewController *vc = [[GoodsTableViewController alloc] init];
        vc.keyWords = model.data;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -- UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (sender == self.imgPlayer)
    {
        CGFloat pagewidth = self.imgPlayer.frame.size.width;
        int page = floor((self.imgPlayer.contentOffset.x - pagewidth/([slideImages count]+2))/pagewidth)+1;
        page --;  // 默认从第二页开始
        _pageControl.currentPage = page;
    }
    
    CGFloat scrollOffset = self.tableView.contentOffset.y;
    customNav.backgroundColor = [UIColor colorWithRed:12/255.0 green:167/255.0 blue:161/255.0 alpha:scrollOffset/64];
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

#pragma mark - 文本框点击事件

-(void)textFieldDidBeginEditing:(UITextField *)tex
{
    [tex resignFirstResponder];
    SearchViewController *searchView = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchView animated:YES];
}

#pragma mark - Table view data source

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3)
        return 0.5;
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return  165;
    if (indexPath.section == 2) {
        return MTViewH * 0.15;
    }else if (indexPath.section == 1){
        //计算钜惠专区 Cell 高度
        //商品价格和名字的总高度
        CGFloat textHeight = 70;
        //顶部图标所在位置的高度
        CGFloat topHeight = 44;
        //商品的间隔
        CGFloat goodsSpace = 10;
        
        CGFloat bottomSpace = 00;
        
        CGFloat cellHeight = floor((MTScreenW - 2 * goodsSpace)/2.5) + textHeight + topHeight + bottomSpace;
        
        return cellHeight;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == 0)
    {
        GoodsTypeCell *goodsTypeCell = [tableView dequeueReusableCellWithIdentifier:@"MTGoodsTypeCell"];
        goodsTypeCell.nav = self.navigationController;
        if(goodsTypeCell == nil)
            goodsTypeCell = [GoodsTypeCell goodsTypeCell];
        cell = goodsTypeCell;
    }
    else if (indexPath.section == 2) {
        SpecialCell *specialCell = [[SpecialCell alloc] initSpecialCellWithTableView:tableView indexpath:indexPath];
        specialCell.intermediateImageUrl = self.specialList.url;
        specialCell.specialArray = self.specialList.data;
        specialCell.delegate = self;
        
        cell = specialCell;

    }
    else if (indexPath.section == 1)
    {
        //钜惠专区 Cell
        DiscountCell *disCell = [[DiscountCell alloc] initDiscountCellWithTableView:tableView indexpath:indexPath];
        disCell.delegate = self;
        disCell.intermediateImageUrl = self.groupbuyTotal.url;
        disCell.goodsDatas = self.groupbuyTotal.data;
        cell = disCell;
    }
    else
    {
        UITableViewCell *commoncell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonCell"];
        
        if (commoncell == nil)
            commoncell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MTCommonCell"];
        commoncell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hotgoods.png"]];
        img.frame = CGRectMake(10, 10, 80, 20);
        [commoncell.contentView addSubview:img];
        commoncell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        commoncell.detailTextLabel.text = @"更多";
        cell = commoncell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3)
    {
        HotGoodsViewController *vc = [[HotGoodsViewController alloc] init];
        vc.dataProvider = commendGoodsArr;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/**
 *  到计时旁边的更多按钮被点击时回调
 */
-(void)discountCell:(DiscountCell *)cell moreBtnClicked:(UIButton *)moreBtn
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    DiscountViewController *specialVC = [[DiscountViewController alloc] initWithCollectionViewLayout:flowLayout];
    specialVC.title = @"钜惠专区";
    [self.navigationController pushViewController:specialVC animated:YES];
}

/**
 *  点击钜惠专区商品时回调
 */
-(void)discountCell:(DiscountCell *)cell goodsModel:(GroupbuyMode *)groupbuyMode
{
    //跳转到商品详情
    GoodsHeadViewController *gvc = [[GoodsHeadViewController alloc] init];
    gvc.goodsID = groupbuyMode.goods_id;
    [self.navigationController pushViewController:gvc animated:YES];
}

#pragma mark SpecialCellDelegate协议方法
/**
 *  点击专题图片时回调
 */
-(void)specialCell:(SpecialCell *)cell specialTappedOfModel:(SpecialModel *)specialmodel
{
    if (specialmodel.type.length == 0)
        return;
    if ([specialmodel.type isEqualToString:@"url"]) {
        MTProgressWebViewController *vc = [[MTProgressWebViewController alloc] init];
        vc.url = specialmodel.data;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([specialmodel.type isEqualToString:@"special"]) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        SpecialViewController *specialVC = [[SpecialViewController alloc] initWithCollectionViewLayout:flowLayout];
        specialVC.title = specialmodel.title;
        specialVC.specialId = [specialmodel.data integerValue];
        [self.navigationController pushViewController:specialVC animated:YES];    }
    else if ([specialmodel.type isEqualToString:@"goods"]) {
        GoodsHeadViewController *vc = [[GoodsHeadViewController alloc] init];
        vc.goodsID = specialmodel.data;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark 到计时相关方法
#pragma mark 到计时相关方法
/**
 *  开始到计时
 */
-(void)startCountDown
{
    if (self.timer) {
        [self stopCountDown];
    }
    
    if (!self.endDate) {
        return;
    }
    NSDate *currentDate = [NSDate date];
    self.remainTime = [self.endDate timeIntervalSinceDate:currentDate];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshCountDownTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:UITrackingRunLoopMode];
}

/**
 *  停止到计时
 */
-(void)stopCountDown
{
    [self.timer invalidate];
    self.timer = nil;
}

/**
 *  刷新 cell 中的数值
 */
-(void)refreshCountDownTime
{
    //剩余时间减1
    self.remainTime--;
    
    //计算显示时间
    NSInteger hours = self.remainTime / 3600;
    NSInteger minutes = (self.remainTime % 3600) / 60;
    NSInteger seconds = self.remainTime % 3600 % 60;
    
    //获取 cell
    NSIndexPath *idx = [NSIndexPath indexPathForRow:0 inSection:1];
    DiscountCell *cell = (DiscountCell *)[self.tableView cellForRowAtIndexPath:idx];
    
    cell.hours= [NSString stringWithFormat:@"%@",@(hours)];
    cell.minutes = [NSString stringWithFormat:@"%@",@(minutes)];
    cell.seconds = [NSString stringWithFormat:@"%@",@(seconds)];
    
    if (self.remainTime == 0) {
        [self stopCountDown];
    }
}


@end
