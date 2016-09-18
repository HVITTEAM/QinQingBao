//
//  CollectTypeCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/26.
//  Copyright © 2016年 董徐维. All rights reserved.
//

static float cellHeight = 75;
static float cellWidth = 60;

#import "CollectTypeCell.h"
#import "GoodsTableViewController.h"
#import "HealthHouseViewController.h"

@implementation CollectTypeCell
{
}

+ (CollectTypeCell*) collectTypeCell
{
    CollectTypeCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"CollectTypeCell" owner:self options:nil] objectAtIndex:0];
    [cell initCollectionView];
    return cell;
}

/**
 *  初始化服务类别列表
 */
-(void)initCollectionView
{
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    self.collectView.collectionViewLayout = flowLayout;
    self.collectView.backgroundColor = [UIColor whiteColor];
    self.collectView.scrollEnabled = NO;
    [self.collectView registerNib:[UINib nibWithNibName:@"SQCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"MTCommonCollecttionCell"];
    self.collectView.delegate = self;
    self.collectView.dataSource = self;
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
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //重用cell
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MTCommonCollecttionCell" forIndexPath:indexPath];
    //赋值
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    UILabel *label = (UILabel *)[cell viewWithTag:2];
    label.textColor = [UIColor colorWithRGB:@"666666"];
    switch (indexPath.row)
    {
        case 0:
        {
            label.text = @"账户";
            imageView.image = [UIImage imageWithName:@"type1"];
        }
            break;
            
        case 1:
        {
            label.text = @"评估";
            imageView.image = [UIImage imageWithName:@"type2"];
        }
            break;
        case 2:
        {
            label.text = @"商品";
            imageView.image = [UIImage imageWithName:@"type3"];
        }
            break;
        case 3:
        {
            label.text = @"服务";
            imageView.image = [UIImage imageWithName:@"type4"];
        }
            break;
        default:
            break;
    }

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
    return (MTScreenW - cellWidth*4)/5;
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
    float VSpace = (self.height - cellHeight*2)/4;
    float HSpace = (self.width - cellWidth*4)/8;
    
    return UIEdgeInsetsMake(0, HSpace, VSpace, HSpace);//分别为上、左、下、右
}

#pragma mark --UICollectionViewDelegate，

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cellClick)
        self.cellClick(indexPath.row);
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
