//
//  RecommendView.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/9.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "HotGoodsView.h"

@implementation HotGoodsView

- (void)drawRect:(CGRect)rect
{
    [self initView];
    self.backgroundColor = HMGlobalBg;
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
    self.colectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, self.height) collectionViewLayout:flowLayout];
    self.colectView.backgroundColor = HMGlobalBg;
    self.colectView.collectionViewLayout = flowLayout;
    self.colectView.scrollEnabled = NO;
    [self.colectView registerNib:[UINib nibWithNibName:@"HotGoodsCell" bundle:nil] forCellWithReuseIdentifier:@"MTHotGoodsCell"];
    self.colectView.delegate = self;
    self.colectView.dataSource = self;
    [self addSubview:self.colectView];
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataProvider.count/3;
}


//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
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
    self.clickClick(item);
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
