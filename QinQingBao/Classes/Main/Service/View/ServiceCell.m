//
//  ServiceCell.m
//  QinQinBao
//
//  Created by 董徐维 on 15/6/15.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "ServiceCell.h"

static NSString *kcellIdentifier = @"collectionCellID";
static float cellHeight = 80;
static float cellWidth = 60;


@implementation ServiceCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

#pragma mark - 调整子控件的位置
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self initCollectionView];
    
}

-(void)initCollectionView
{
    if (self.collectView)
        return;
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    self.collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, self.height) collectionViewLayout:flowLayout];
    self.collectView.backgroundColor = [UIColor clearColor];
    //通过Nib生成cell，然后注册 Nib的view需要继承 UICollectionViewCell
    [self.collectView registerNib:[UINib nibWithNibName:@"SQCollectionCell" bundle:nil] forCellWithReuseIdentifier:kcellIdentifier];
    self.collectView.delegate = self;
    self.collectView.dataSource = self;
    [self.collectView reloadData];
    [self addSubview:self.collectView];
    
    self.collectView.scrollEnabled = NO;
    
    
    // 1.取出背景view
    UIImageView *selectedBgView = [[UIImageView alloc] init];
    
    // 去除cell的默认背景色
    self.backgroundColor = [UIColor clearColor];
    // 2.设置背景图片
    selectedBgView.image = [UIImage resizedImage:@"chartcell_background"];
    self.collectView.backgroundView = selectedBgView;
    //    self.collectView.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.array.count;
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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kcellIdentifier forIndexPath:indexPath];
    //赋值
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    UILabel *label = (UILabel *)[cell viewWithTag:2];
    
    ServiceMenuModel *item = _array[indexPath.row];
    NSString *imageName = [NSString stringWithFormat:item.img,".png"];
    imageView.image = [UIImage imageNamed:imageName];
    label.text = item.label;
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(cellWidth, cellHeight);
}

/**
 *  设置横向间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (self.width == 414)//如果是plus
        return 30;
    else
        return (self.width - cellWidth*4)/8;
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
    return UIEdgeInsetsMake(-3, 10, 5, 10);//分别为上、左、下、右
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"click");
    ServiceMenuModel *item = _array[indexPath.row];
    [self.delegate servicecellClickHandler:item];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
