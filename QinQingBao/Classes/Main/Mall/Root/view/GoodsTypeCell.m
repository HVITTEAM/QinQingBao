//
//  GoodsTypeCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/26.
//  Copyright © 2016年 董徐维. All rights reserved.
//

static float cellHeight = 80;
static float cellWidth = 66;

#import "GoodsTypeCell.h"
#import "ConfModelTotal.h"
#import "GoodsTableViewController.h"
#import "HealthHouseViewController.h"

@implementation GoodsTypeCell
{
    NSMutableArray *dataProvider;
    ConfModelTotal *result;
}

+ (GoodsTypeCell*) goodsTypeCell
{
    GoodsTypeCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"GoodsTypeCell" owner:self options:nil] objectAtIndex:0];
    [cell initCollectionView];
    [cell getTypeList];
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

-(void)getTypeList
{
    [CommonRemoteHelper RemoteWithUrl:URL_Goodclass parameters: nil
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     NSDictionary *dict1 =  [dict objectForKey:@"datas"];
                                     result = [ConfModelTotal objectWithKeyValues:dict1];
                                     dataProvider = result.data;
                                     [self.collectView reloadData];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [NoticeHelper AlertShow:@"获取失败!" view:self];
                                 }];
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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MTCommonCollecttionCell" forIndexPath:indexPath];
    //赋值
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    UILabel *label = (UILabel *)[cell viewWithTag:2];
    NSInteger index = indexPath.section *4 + indexPath.row;
    ConfModel *data = [dataProvider objectAtIndex:index];
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/shop/%@%@",URL_Local,result.url,data.gc_thumb]];
    [imageView sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
    label.text = data.gc_name;
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
    
    if (section == 0)
        return UIEdgeInsetsMake(VSpace, HSpace, VSpace, HSpace);//分别为上、左、下、右
    else
        return UIEdgeInsetsMake(0, HSpace, VSpace, HSpace);//分别为上、左、下、右
}

#pragma mark --UICollectionViewDelegate，

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.section *4 + indexPath.row;
    ConfModel *data = [dataProvider objectAtIndex:index];
    if (!data.flag || [data.flag isEqualToString:@"0"])
    {
        GoodsTableViewController *vc = [[GoodsTableViewController alloc] init];
        vc.gc_id = data.gc_id;
        [self.nav pushViewController:vc animated:YES];
    }
    else
    {
        HealthHouseViewController *vc = [[HealthHouseViewController alloc] init];
        [self.nav pushViewController:vc animated:YES];
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
