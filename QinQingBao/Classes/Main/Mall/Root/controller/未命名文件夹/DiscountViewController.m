//
//  SpecialViewController.m
//  QinQingBao
//
//  Created by shi on 16/1/27.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "DiscountViewController.h"
#import "DiscountHeadCell.h"
#import "DiscountCountDownCell.h"

#import "GroupbuyTotal.h"
#import "GroupbuyMode.h"

//////////////////////////////////////////////////////////

static NSString *hotGoodsCellId = @"MTHotGoodsCell";
static NSString *discountHeadCellId = @"discountHeadCell";
static NSString *discountCountDownCellId = @"discountCountDownCell";

///////////////////////////////////////////////////////////////////

@interface DiscountViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>

@property(strong,nonatomic)NSMutableArray *goodsDataArray;        //商品数组内部

@property(strong,nonatomic)GroupbuyTotal *groupbuyTotal;         //抢购数据

@property(copy,nonatomic)NSString *imageUrl;

@property(strong,nonatomic)NSTimer *timer;               //定时器

@property(assign,nonatomic)NSUInteger remainTime;    //剩余时间

@end

@implementation DiscountViewController

#pragma mark -- 生命周期方法 --

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initCollectionView];
    
    [self loadFirstPageGroupbuyData];
    
    self.remainTime = 10;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self startCountDown];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self stopCountDown];
}

#pragma mark -- getter 方法 --
-(NSMutableArray *)goodsDataArray
{
    if (!_goodsDataArray) {
        _goodsDataArray = [[NSMutableArray alloc] init];
    }
    return _goodsDataArray;
}

#pragma mark -- 初始化子视图方法 --
/**
 *  初始化CollectionView
 */
-(void)initCollectionView
{
    //创建一个FlowLayout布局对象
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    //设置UICollectionView
    self.collectionView.backgroundColor = HMGlobalBg;
    
    //注册 cell
    UINib *nib1 = [UINib nibWithNibName:@"HotGoodsCell" bundle:nil];
    [self.collectionView registerNib:nib1 forCellWithReuseIdentifier:hotGoodsCellId];
    
    //注册 cell
    UINib *nib2 = [UINib nibWithNibName:@"DiscountHeadCell" bundle:nil];
    [self.collectionView registerNib:nib2 forCellWithReuseIdentifier:discountHeadCellId];
    
    //注册 cell
    UINib *nib3 = [UINib nibWithNibName:@"DiscountCountDownCell" bundle:nil];
    [self.collectionView registerNib:nib3 forCellWithReuseIdentifier:discountCountDownCellId];
}

#pragma mark -- 协议方法 --
#pragma mark UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //展示产品的 section 不为1，其它都是一个 cell
    if (section == 2) {
      return self.goodsDataArray.count;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //头部图片 cell
        DiscountHeadCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:discountHeadCellId forIndexPath:indexPath];
        return cell;
    }else if (indexPath.section == 1){
        //到计时 cell
        DiscountCountDownCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:discountCountDownCellId forIndexPath:indexPath];
        return cell;
    }
    //产品 cell
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:hotGoodsCellId
                                                                forIndexPath:indexPath];
    GroupbuyMode *model = self.goodsDataArray[indexPath.row];
    
    //根据tag获取 cell 中的视图
    UIImageView *goodsImgview = [cell viewWithTag:1];
    UILabel *nameLb = [cell viewWithTag:2];
    UILabel *newpriceLb = [cell viewWithTag:3];
    UILabel *oldpriceLb = [cell viewWithTag:4];
    
    //赋值
    nameLb.text = model.goods_name;
    newpriceLb.text = model.goods_price;
    oldpriceLb.text = model.groupbuy_price;
    
    //下载商品图片
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@/%@",URL_Local,self.imageUrl,model.store_id,model.groupbuy_image1];
    NSURL *url = [[NSURL alloc] initWithString:urlStr];
    [goodsImgview sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    
    return cell;
}

#pragma mark UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //头部图片 cell大小
        return CGSizeMake(MTScreenW, MTScreenH * 0.25);
        
    }else if (indexPath.section == 1){
        //到计时 cell 大小
        return CGSizeMake(MTScreenW, 50);
    }
    //产品 Cell大小，一行显示个 2 cell
    CGFloat itemWidth = floor(MTScreenW/2);
    CGFloat itemHeight = itemWidth + 70;
    return CGSizeMake(itemWidth, itemHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 10, 0);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);;
}

#pragma mark -- 内部方法 --
#pragma mark 到计时相关方法
/**
 *  开始到计时
 */
-(void)startCountDown
{
    if (self.timer) {
        [self stopCountDown];
    }
    
    if (self.remainTime == 0) {
        return;
    }
    
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
    DiscountCountDownCell *cell = (DiscountCountDownCell *)[self.collectionView cellForItemAtIndexPath:idx];
    
    cell.hours= [NSString stringWithFormat:@"%@",@(hours)];
    cell.minutes = [NSString stringWithFormat:@"%@",@(minutes)];
    cell.seconds = [NSString stringWithFormat:@"%@",@(seconds)];
    
    if (self.remainTime == 0) {
        [self stopCountDown];
    }
}

#pragma mark 网络相关方法
/**
 *  下载抢购专区数据
 */
-(void)loadFirstPageGroupbuyData
{
    [MBProgressHUD showHUDAddedTo:self.collectionView animated:YES];
    
    NSDictionary *params = @{
                             @"g_status":@(0),
                             @"curpage":@(1),
                             @"page":@(10)
                             };
    
    [CommonRemoteHelper RemoteWithUrl:URL_groupbuy_list parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:self.collectionView animated:YES];
        
        if ([dict[@"code"]integerValue] != 0) {
            [NoticeHelper AlertShow:@"抱歉,无法获取到抢购数据" view:self.view];
            return;
        }
        //转换成专题产品模型
        self.groupbuyTotal = [GroupbuyTotal objectWithKeyValues:dict[@"datas"]];
        self.goodsDataArray = self.groupbuyTotal.data;
        [self.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.collectionView animated:YES];
        [NoticeHelper AlertShow:@"抱歉,无法获取到抢购数据" view:self.view];
    }];
}


@end
