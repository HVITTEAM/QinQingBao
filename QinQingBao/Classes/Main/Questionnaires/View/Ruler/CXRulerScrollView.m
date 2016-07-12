//
//  CXRulerScrollView.m
//  QinQingBao
//
//  Created by 董徐维 on 16/6/30.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CXRulerScrollView.h"
#import "CAShapeLayer+MutipleData.h"


@interface CXRulerScrollView ()

@property(nonatomic,assign) int data;

@end

@implementation CXRulerScrollView
{
    NSMutableArray *shapeLayerArr;
}

/**
 *  设置刻度值，并且高亮显示
 *
 *  @param rulerValue 刻度值
 */
- (void)setRulerValue:(CGFloat)rulerValue
{
    if (self.startValue)
        _rulerValue = rulerValue + self.startValue;
    else
        _rulerValue = rulerValue;
    
    NSLog(@"rulerValue*****************当前刻度:oX:%.0f",rulerValue);
    if (shapeLayerArr.count > 0)
    {
        for (CAShapeLayer *layer in shapeLayerArr)
        {
            if ([layer.flagData isEqualToString:[NSString stringWithFormat:@"%.0f",rulerValue]])
            {
                layer.strokeColor = [UIColor orangeColor].CGColor;
                layer.lineWidth = 2.f;
            }
            else
            {
                NSUInteger i = [shapeLayerArr indexOfObject:layer];
                if (i % 10 == 0)
                {
                    layer.lineWidth = 1.f;
                    layer.strokeColor = [UIColor grayColor].CGColor;
                }
                else
                {
                    layer.lineWidth = 1.f;
                    layer.strokeColor = [UIColor lightGrayColor].CGColor;
                }
            }
        }
    }
}

- (void)drawRuler
{
    shapeLayerArr = [[NSMutableArray alloc] init];
    for (int i = 0; i <= self.rulerCount; i++)
    {
        CGMutablePathRef pathRef = CGPathCreateMutable();
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.lineWidth = 1.f;
        shapeLayer.lineCap = kCALineCapButt;
        
        
        UILabel *rule = [[UILabel alloc] init];
        rule.textColor = [UIColor blackColor];
        rule.text = [NSString stringWithFormat:@"%.0f",i * [self.rulerAverage floatValue] + self.startValue];
        CGSize textSize = [rule.text sizeWithAttributes:@{ NSFontAttributeName : rule.font }];
        if (self.rulerValue)
        {
            NSLog(@"rulerValue初始化当前刻度:%.0f",self.rulerValue);
        }
        
        if (i % 10 == 0)
        {
            shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
            CGPathMoveToPoint(pathRef, NULL, DISTANCELEFTANDRIGHT + DISTANCEVALUE * i , DISTANCETOPANDBOTTOM + 12);
            CGPathAddLineToPoint(pathRef, NULL, DISTANCELEFTANDRIGHT + DISTANCEVALUE * i, self.rulerHeight - DISTANCETOPANDBOTTOM - textSize.height - 12);
            rule.frame = CGRectMake(DISTANCELEFTANDRIGHT + DISTANCEVALUE * i - textSize.width / 2, self.rulerHeight - DISTANCETOPANDBOTTOM - textSize.height, 0, 0);
            [rule sizeToFit];
//            [self addSubview:rule];
        }
        else if (i % 5 == 0) {
            shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
            CGPathMoveToPoint(pathRef, NULL, DISTANCELEFTANDRIGHT + DISTANCEVALUE * i , DISTANCETOPANDBOTTOM + 12);
            CGPathAddLineToPoint(pathRef, NULL, DISTANCELEFTANDRIGHT + DISTANCEVALUE * i, self.rulerHeight - DISTANCETOPANDBOTTOM - textSize.height - 12);
            rule.frame = CGRectMake(DISTANCELEFTANDRIGHT + DISTANCEVALUE * i - textSize.width / 2, self.rulerHeight - DISTANCETOPANDBOTTOM - textSize.height, 0, 0);
            [rule sizeToFit];
            [self addSubview:rule];
        }
        else
        {
            shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
            CGPathMoveToPoint(pathRef, NULL, DISTANCELEFTANDRIGHT + DISTANCEVALUE * i , DISTANCETOPANDBOTTOM + 20);
            CGPathAddLineToPoint(pathRef, NULL, DISTANCELEFTANDRIGHT + DISTANCEVALUE * i, self.rulerHeight - DISTANCETOPANDBOTTOM - textSize.height - 20);
        }
        shapeLayer.flagData = [NSString stringWithFormat:@"%d",i];
        shapeLayer.path = pathRef;
        [self.layer addSublayer:shapeLayer];
        [shapeLayerArr addObject:shapeLayer];
        
        if ([shapeLayer.flagData isEqualToString:[NSString stringWithFormat:@"%.0f",self.rulerValue - self.startValue]])
        {
            shapeLayer.strokeColor = [UIColor orangeColor].CGColor;
            shapeLayer.lineWidth = 2.f;
        }
        else
        {
            if (i % 10 == 0)
            {
                shapeLayer.lineWidth = 1.f;
                shapeLayer.strokeColor = [UIColor grayColor].CGColor;
            }
            else
            {
                shapeLayer.lineWidth = 1.f;
                shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
            }
        }
        
    }
    
    self.frame = CGRectMake(0, 0, self.rulerWidth, self.rulerHeight);
    
    
    UIEdgeInsets edge = UIEdgeInsetsMake(0, self.rulerWidth / 2.f - DISTANCELEFTANDRIGHT, 0, self.rulerWidth / 2.f - DISTANCELEFTANDRIGHT);
    self.contentInset = edge;
    self.contentOffset = CGPointMake(DISTANCEVALUE * (self.rulerValue - self.startValue / [self.rulerAverage floatValue]) - self.rulerWidth + (self.rulerWidth / 2.f + DISTANCELEFTANDRIGHT), 0);
    
    self.contentSize = CGSizeMake(self.rulerCount * DISTANCEVALUE + DISTANCELEFTANDRIGHT * 2.f, self.rulerHeight);
}

@end