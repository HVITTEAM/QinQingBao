//
//  HotCitiesCell.m
//  QinQingBao
//
//  Created by 董徐维 on 15/11/30.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "HotCitiesCell.h"

@implementation HotCitiesCell


+ (HotCitiesCell*) hotCitiesCell
{
    HotCitiesCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"HotCitiesCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
    
    [self initCollectionView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

/**
 *  初始化服务类别列表
 */
-(void)initCollectionView
{
    self.backgroundColor = HMColor(241, 241, 241);
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    self.collectView.collectionViewLayout = flowLayout;
    self.collectView.backgroundColor = HMColor(241, 241, 241);
    self.collectView.scrollEnabled = NO;
    [self.collectView registerNib:[UINib nibWithNibName:@"HotCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MTCommonCell"];
    self.collectView.delegate = self;
    self.collectView.dataSource = self;
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataProvider.count;
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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MTCommonCell" forIndexPath:indexPath];
    //赋值
    UIButton *btn = (UIButton *)[cell viewWithTag:1];
    [btn setTitle:self.dataProvider[indexPath.row] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = [HMColor(222, 222, 222) CGColor];
    [btn addTarget:self action:@selector(btnClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 30);
}

/**
 *  设置横向间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (MTScreenW == 414)//如果是plus
        return 35;
    else
        return (MTScreenW - 100*4)/8;
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
  
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)btnClickHandler:(UIButton *)btn
{
    self.selectedHandler(btn);
}


@end
