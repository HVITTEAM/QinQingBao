//
//  ScrollMenuLayout.m
//  Scroll
//
//  Created by shi on 16/9/10.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "ScrollMenuLayout.h"

@interface ScrollMenuLayout ()

@property (assign, nonatomic)NSInteger totalNum;

@end

@implementation ScrollMenuLayout

- (void)prepareLayout
{
    self.totalNum = [self.collectionView numberOfItemsInSection:0];
}

- (CGSize)collectionViewContentSize
{
    CGRect bounds = self.collectionView.bounds;
    
    NSInteger num = self.row * self.col;
    
    NSInteger numOfPage = ceil(self.totalNum * 1.0 / num);
    
    CGSize size = CGSizeMake(bounds.size.width * numOfPage, bounds.size.height);
    
    return size;
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* attributes = [NSMutableArray array];
    for (int i = 0; i < self.totalNum; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    
    return attributes;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat collectWidth = self.collectionView.bounds.size.width;
    CGFloat collectHeight = self.collectionView.bounds.size.height;
    
    CGFloat cellWidth = floor((collectWidth - self.margin.left - self.margin.right - (self.col - 1) * self.colSpace) / self.col) ;
    CGFloat cellHeight = floor((collectHeight - self.margin.top - self.margin.bottom - (self.row - 1) * self.rowSpace) / self.row) ;
    
    NSInteger positionPage = indexPath.row / self.col / self.row;    //所在页面
    NSInteger positionRow = indexPath.row / self.col % self.row;    //所在页的第几行
    NSInteger positionCol = indexPath.row % self.col;    //所在页的第几列
    
    CGFloat x = collectWidth * positionPage + self.margin.left + (cellWidth + self.colSpace) * positionCol;
    CGFloat y = self.margin.top + (cellHeight + self.rowSpace) * positionRow;
    
    
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attr.frame = CGRectMake(x, y, cellWidth, cellHeight);
    
    
    return attr;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end
