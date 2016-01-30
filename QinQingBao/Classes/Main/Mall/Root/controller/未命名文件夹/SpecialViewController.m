//
//  SpecialViewController.m
//  QinQingBao
//
//  Created by shi on 16/1/28.
//  Copyright © 2016年 董徐维. All rights reserved.
//

static NSString *hotGoodsCellId = @"MTHotGoodsCell";

#import "SpecialViewController.h"
#import "CommodityModel.h"
#import "SpecialDataTotal.h"
#import "SpecialData.h"
#import "SpecialDataItem.h"

@interface SpecialViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>

@property(strong,nonatomic)NSMutableArray *goodsDataArray;              //商品数组，内部元素为CommodityModel对象

@property(strong,nonatomic)SpecialDataTotal *specialTotal;              //具体某个专题的所有信息

@end

@implementation SpecialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initCollectionView];
    
    [self loadSpecialGoodsDataWithspecialId:self.specialId];
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
    //获取一个FlowLayout布局对象
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    //设置UICollectionView
    self.collectionView.backgroundColor = HMGlobalBg;
    
    //注册 cell
    UINib *nib1 = [UINib nibWithNibName:@"HotGoodsCell" bundle:nil];
    [self.collectionView registerNib:nib1 forCellWithReuseIdentifier:hotGoodsCellId];
}

#pragma mark -- 协议方法 --
#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.goodsDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:hotGoodsCellId
                                                                           forIndexPath:indexPath];
    CommodityModel *model = self.goodsDataArray[indexPath.row];
    
    //根据tag获取 cell 中的视图
    UIImageView *goodsImgview = [cell viewWithTag:1];
    UILabel *nameLb = [cell viewWithTag:2];
    UILabel *newpriceLb = [cell viewWithTag:3];
    UILabel *oldpriceLb = [cell viewWithTag:4];
    
    //赋值
    nameLb.text = model.goods_name;
    newpriceLb.text = model.goods_promotion_price;
    oldpriceLb.text = model.goods_marketprice;;
    
    //下载商品图片
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@/%@",URL_Local,self.specialTotal.url,model.store_id,model.goods_image];
    NSURL *url = [[NSURL alloc] initWithString:urlStr];
    [goodsImgview sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    return cell;
}

#pragma mark UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //一行显示个 2 cell
    CGFloat itemWidth = floor(MTScreenW/2);
    CGFloat itemHeight = itemWidth + 70;
    return CGSizeMake(itemWidth, itemHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);;
}

#pragma mark -- 内部方法 --
/**
 *  下载具体的专题数据
 */
-(void)loadSpecialGoodsDataWithspecialId:(NSInteger)specialid
{
    [MBProgressHUD showHUDAddedTo:self.collectionView animated:YES];
    
    NSDictionary *params = @{
                             @"special_id":@(specialid)
                             };
    
    [CommonRemoteHelper RemoteWithUrl:URL_Special_list parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
        NSLog(@"%@",dict);
        
        [MBProgressHUD hideHUDForView:self.collectionView animated:YES];
        
        if ([dict[@"code"]integerValue] != 0) {
            [NoticeHelper AlertShow:@"抱歉,无法获取到数据" view:self.view];
            return;
        }
        
        //转换成专题产品模型
        self.specialTotal = [SpecialDataTotal objectWithKeyValues:dict[@"datas"]];
        
        SpecialData *specialData = self.specialTotal.data[0];
        
        SpecialDataItem *specialItem = specialData.item_data;
        
        self.goodsDataArray = specialItem.item;
        
        [self.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.collectionView animated:YES];
        [NoticeHelper AlertShow:@"抱歉,无法获取到数据" view:self.view];
    }];
}

@end
