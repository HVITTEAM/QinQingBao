//
//  GoodsSpecCollectionView.m
//  QinQingBao
//
//  Created by 董徐维 on 16/2/26.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "GoodsSpecCollectionView.h"
#import "RecipeCollectionHeaderView.h"
#import "MTUICollectionViewFlowLayout.h"

@interface GoodsSpecCollectionView ()
{
    float height;
}
@end
@implementation GoodsSpecCollectionView

- (void)drawRect:(CGRect)rect
{
    [self initView];
    self.backgroundColor = [UIColor whiteColor];
}

-(void)setDataProvider:(NSMutableArray *)dataProvider
{
    _dataProvider = dataProvider;
    [self.colectView reloadData];
}

-(void)initView
{
    height = self.y;
    [self initCollectionView];
}

-(void)initCollectionView
{
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    
    self.colectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) collectionViewLayout:flowLayout];
    [self.colectView registerClass:[RecipeCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    self.colectView.backgroundColor = [UIColor whiteColor];
    self.colectView.collectionViewLayout = flowLayout;
    self.colectView.scrollEnabled = NO;
    [self.colectView registerNib:[UINib nibWithNibName:@"GoodsSpecCell" bundle:nil] forCellWithReuseIdentifier:@"MTGoodsSpecCell"];
    self.colectView.delegate = self;
    self.colectView.dataSource = self;
    [self addSubview:self.colectView];
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    GoodsTypeModel *item = self.dataProvider[section];
    return item.datas.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataProvider.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //重用cell
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MTGoodsSpecCell" forIndexPath:indexPath];
    
    GoodsTypeModel *sections = self.dataProvider[indexPath.section];
    GoodsTypeModel *item = sections.datas[indexPath.row];
    
    //赋值
    UIButton *typevalue = (UIButton *)[cell viewWithTag:100];
    typevalue.userInteractionEnabled = NO;
    typevalue.selected = item.selected;
    [typevalue setTitle:item.value forState:UIControlStateNormal];
    [typevalue.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:13]];
    [typevalue setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [typevalue setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [typevalue setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateSelected];
    [typevalue setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [typevalue setClipsToBounds:YES];
    typevalue.layer.cornerRadius = 4;
    typevalue.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    typevalue.layer.borderWidth = 0.5f;
    self.colectView.height = self.colectView.contentSize.height;
    self.height = self.colectView.contentSize.height;
    self.y = height - self.height;
    if (self.loadViewRepleteBlock && indexPath.section == self.dataProvider.count - 1 &&indexPath.row == sections.datas.count - 1)
        self.loadViewRepleteBlock();
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader)
    {
        RecipeCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        GoodsTypeModel *item = self.dataProvider[indexPath.section];
        UILabel *lab = (UILabel *)[headerView viewWithTag:100];
        if (!lab)
            lab = [[UILabel alloc] initWithFrame:CGRectMake(0, -3, MTScreenW, 30)];
        lab.font = [UIFont systemFontOfSize:14];
        lab.textColor = [UIColor darkGrayColor];
        lab.tag = 100;
        lab.text = item.value;
        [headerView addSubview:lab];
        reusableview = headerView;
    }
    return reusableview;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsTypeModel *sections = self.dataProvider[indexPath.section];
    GoodsTypeModel *item = sections.datas[indexPath.row];
    CGRect tmpRect = [item.value boundingRectWithSize:CGSizeMake(MTScreenW - 15, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica" size:13],NSFontAttributeName, nil] context:nil];
    return CGSizeMake(tmpRect.size.width + 15,  25);
}

/**
 *  设置横向间距 设置最小列间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

/**
 *  设置竖向间距 设置最小行间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = {MTScreenW, 25};
    return size;
}

#pragma mark --UICollectionViewDelegate，

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //选择的分类
    GoodsTypeModel *sections = self.dataProvider[indexPath.section];
    //选择的分类中的具体项目
    GoodsTypeModel *clickitem = sections.datas[indexPath.row];
    for (GoodsTypeModel *item in sections.datas)
    {
        if (item == clickitem)
        {
            item.selected = !item.selected;
            sections.selected = item.selected;
        }
        else
            item.selected = NO;
    }
    
    [UIView performWithoutAnimation:^{
        [self.colectView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
    }];
    
    if (self.selectedBlock)
        self.selectedBlock(self.dataProvider);
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
