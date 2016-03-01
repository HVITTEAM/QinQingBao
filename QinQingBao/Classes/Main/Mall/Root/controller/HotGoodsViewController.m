//
//  HotGoodsViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/2/1.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "HotGoodsViewController.h"
#import "GoodsHeadViewController.h"
#import "SpecialList.h"
#import "SpecialDataTotal.h"
#import "SpecialData.h"
@interface HotGoodsViewController ()

@end

@implementation HotGoodsViewController


-(instancetype)init
{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    self.title = @"热销商品";
    [self initView];
    
    [super viewDidLoad];
    
    if (self.special_id)
        [self getGoodsList];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
}

-(void)setDataProvider:(NSMutableArray *)dataProvider
{
    _dataProvider = dataProvider;
    [self.colectView reloadData];
}

-(void)initView
{
    [self initCollectionView];
}

-(void)initCollectionView
{
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    self.colectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH) collectionViewLayout:flowLayout];
    self.colectView.backgroundColor = HMGlobalBg;
    self.colectView.collectionViewLayout = flowLayout;
    [self.colectView registerNib:[UINib nibWithNibName:@"HotGoodsCell" bundle:nil] forCellWithReuseIdentifier:@"MTHotGoodsCell"];
    self.colectView.delegate = self;
    self.colectView.dataSource = self;
    [self.view addSubview:self.colectView];
}

/**
 * 获取专题商品
 **/
-(void)getGoodsList
{
    [CommonRemoteHelper RemoteWithUrl:URL_Apiget_seecial parameters:@{@"special_id" : self.special_id}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     NSDictionary *dict1 =  [dict objectForKey:@"datas"];
                                     SpecialDataTotal *result = [SpecialDataTotal objectWithKeyValues:dict1];
                                     SpecialData *item = result.data[0];
                                     SpecialDataItem *items = item.item_data;
                                     self.dataProvider = items.item;
                                     [self.colectView reloadData];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [NoticeHelper AlertShow:@"获取失败!" view:self.view];
                                 }];
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSString *str = [NSString stringWithFormat:@"%u",_dataProvider.count/2];
    return ceilf([str floatValue]);
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //重用cell
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MTHotGoodsCell" forIndexPath:indexPath];
    
    NSInteger index = indexPath.section *2 + indexPath.row;
    RecommendGoodsModel *item = [self.dataProvider objectAtIndex:index];
    
    //赋值
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    UILabel *titlelab = (UILabel *)[cell viewWithTag:2];
    UILabel *pricelab = (UILabel *)[cell viewWithTag:3];
    UILabel *oldpricelab = (UILabel *)[cell viewWithTag:4];
    
    
    NSString *markpriceStr                            = [NSString stringWithFormat:@"￥%@  ",item.goods_marketprice];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:markpriceStr];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid |NSUnderlineStyleSingle) range:NSMakeRange(0, markpriceStr.length-1)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, markpriceStr.length-1)];
    //市场价
    oldpricelab.attributedText = attri;
    
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/shop/data/upload/shop/store/goods/%@/%@",URL_Local,item.store_id,item.goods_image]];
    [imageView sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
    cell.backgroundColor = [UIColor whiteColor];
    titlelab.text = item.goods_name;
    if ([item.goods_price isEqualToString:item.goods_marketprice])
        oldpricelab.hidden = YES;
    pricelab.text = [NSString stringWithFormat:@"  ￥%@",item.goods_price];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(MTScreenW/2, MTScreenW/2 + 60);
}

/**
 *  设置横向间距 设置最小列间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

/**
 *  设置竖向间距 设置最小行间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);//分别为上、左、下、右
    
}

#pragma mark --UICollectionViewDelegate，

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.section *2 + indexPath.row;
    RecommendGoodsModel *item = [self.dataProvider objectAtIndex:index];
    
    GoodsHeadViewController *gvc = [[GoodsHeadViewController alloc] init];
    gvc.goodsID = item.goods_id;
    [self.navigationController pushViewController:gvc animated:YES];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


@end
