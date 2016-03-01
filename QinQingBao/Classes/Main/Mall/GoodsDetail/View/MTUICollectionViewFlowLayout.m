//
//  MTUICollectionViewFlowLayout.m
//  QinQingBao
//
//  Created by 董徐维 on 16/2/26.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "MTUICollectionViewFlowLayout.h"

@implementation MTUICollectionViewFlowLayout

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    //从第二个循环到最后一个
    for(int i = 1; i < [attributes count]; ++i)
    {
        //当前attributes
        UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
        //上一个attributes
        UICollectionViewLayoutAttributes *prevLayoutAttributes = attributes[i - 1];
        //我们想设置的最大间距，可根据需要改
        NSInteger maximumSpacing = 0;
        //前一个cell的最右边
        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        //如果当前一个cell的最右边加上我们想要的间距加上当前cell的宽度依然在contentSize中，我们改变当前cell的原点位置
        //不加这个判断的后果是，UICollectionView只显示一行，原因是下面所有cell的x值都被加到第一行最后一个元素的后面了
        if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width)
        {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = origin + maximumSpacing;
            currentLayoutAttributes.frame = frame;
        }
    }
    return [attributes copy];
}


@end
