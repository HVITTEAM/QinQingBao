//
//  GoodsTypeCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/26.
//  Copyright © 2016年 董徐维. All rights reserved.
//

static float cellHeight = 80;
static float cellWidth = 66;

#import "HouseTypeCell.h"
#import "ConfModelTotal.h"
#import "GoodsTableViewController.h"
#import "GoodsClassModelTotal.h"
#import "GoodsClassModel.h"

@implementation HouseTypeCell
{
    NSMutableArray *dataProvider;
    ConfModelTotal *result;
}

+ (HouseTypeCell*) houseTypeCell
{
    HouseTypeCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"HouseTypeCell" owner:self options:nil] objectAtIndex:0];
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
    [CommonRemoteHelper RemoteWithUrl:URL_Goods_class parameters: nil
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     GoodsClassModelTotal *result = [GoodsClassModelTotal objectWithKeyValues:[dict objectForKey:@"datas"]];
                                     dataProvider = result.class_list;
                                     if (dataProvider.count == 0)
                                         return [NoticeHelper AlertShow:@"暂无数据!" view:self];
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
    if (index < dataProvider.count) {
        GoodsClassModel *data = [dataProvider objectAtIndex:index];
        //    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/shop/%@%@",URL_Local,result.url,data.gc_thumb]];
        NSURL *iconUrl = [NSURL URLWithString:data.image];
        [imageView sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
        label.text = data.gc_name;
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
    
    if (section == 0)
        return UIEdgeInsetsMake(VSpace, HSpace, VSpace, HSpace);//分别为上、左、下、右
    else
        return UIEdgeInsetsMake(0, HSpace, VSpace, HSpace);//分别为上、左、下、右
}

#pragma mark --UICollectionViewDelegate，

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.section *4 + indexPath.row;
//    GoodsClassModel *data = [dataProvider objectAtIndex:index];
//    GoodsTableViewController *vc = [[GoodsTableViewController alloc] init];
//    vc.gc_id = data.gc_id;
//    if (!data.flag || [data.flag isEqualToString:@"0"])
//        [self.nav pushViewController:vc animated:YES];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
