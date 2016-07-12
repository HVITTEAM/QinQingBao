//
//  CXRuler.m
//  QinQingBao
//
//  Created by 董徐维 on 16/6/30.
//  Copyright © 2016年 董徐维. All rights reserved.

#import "CXRuler.h"


@implementation CXRuler
{
    CXRulerScrollView * rulerScrollView;
    //init完成
    Boolean InitFinish;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        rulerScrollView = [self rulerScrollView];
        rulerScrollView.rulerHeight = frame.size.height;
        rulerScrollView.rulerWidth = frame.size.width;
    }
    return self;
}

- (void)showRulerScrollViewWithCount:(NSUInteger)count average:(NSNumber *)average startValue:(CGFloat)startValue currentValue:(CGFloat)currentValue
{
    //当前刻度不能大于最大刻度
    if (currentValue - startValue > [average floatValue] * count)
    {
        currentValue = [average floatValue] * count + startValue;
    }
    rulerScrollView.rulerAverage = average;
    rulerScrollView.startValue = startValue;
    rulerScrollView.rulerCount = count;
    rulerScrollView.rulerValue = currentValue - startValue;
    [rulerScrollView drawRuler];
    [self addSubview:rulerScrollView];
    [self drawRacAndLine];
}

- (CXRulerScrollView *)rulerScrollView
{
    CXRulerScrollView * rScrollView = [CXRulerScrollView new];
    rScrollView.delegate = self;
    rScrollView.showsHorizontalScrollIndicator = NO;
    return rScrollView;
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(CXRulerScrollView *)scrollView
{
    CGFloat offSetX = scrollView.contentOffset.x + self.width / 2 - DISTANCELEFTANDRIGHT;
    CGFloat ruleValue = (offSetX / DISTANCEVALUE) * [scrollView.rulerAverage floatValue];
    if (ruleValue < 0.f)
    {
        return;
    }
    else if (ruleValue > scrollView.rulerCount * [scrollView.rulerAverage floatValue])
    {
        return;
    }
    if (self.rulerDelegate)
    {
        //实时设置高亮显示
        if (InitFinish)
            scrollView.rulerValue = ruleValue;
        InitFinish = YES;
        
        [self.rulerDelegate CXRuler:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(CXRulerScrollView *)scrollView
{
    [self animationRebound:scrollView];
}

- (void)scrollViewDidEndDragging:(CXRulerScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self animationRebound:scrollView];
}

- (void)animationRebound:(CXRulerScrollView *)scrollView
{
    CGFloat offSetX = scrollView.contentOffset.x + self.frame.size.width / 2 - DISTANCELEFTANDRIGHT;
    CGFloat oX = (offSetX / DISTANCEVALUE) * [scrollView.rulerAverage floatValue];
    
    NSLog(@"rulerValue*****************之前:oX:%.0f",oX);
    
    oX = floor(oX*100) / 100 ;
    
    NSLog(@"rulerValue*****************之后:oX:%.0f",oX);
    
    rulerScrollView.rulerValue = oX;
    CGFloat offX = (oX / ([scrollView.rulerAverage floatValue])) * DISTANCEVALUE + DISTANCELEFTANDRIGHT - self.width / 2;
    [UIView animateWithDuration:.2f animations:^{
        scrollView.contentOffset = CGPointMake(offX, 0);
    }];
}

- (void)drawRacAndLine
{
    // 渐变
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    
    gradient.colors = @[(id)[[UIColor whiteColor] colorWithAlphaComponent:1.f].CGColor,
                        (id)[[UIColor whiteColor] colorWithAlphaComponent:0.0f].CGColor,
                        (id)[[UIColor whiteColor] colorWithAlphaComponent:1.f].CGColor];
    
    gradient.locations = @[[NSNumber numberWithFloat:0.0f],
                           [NSNumber numberWithFloat:0.6f]];
    
    gradient.startPoint = CGPointMake(0, .5);
    gradient.endPoint = CGPointMake(1, .5);
    
    CGMutablePathRef pathArc = CGPathCreateMutable();
    
    CGPathMoveToPoint(pathArc, NULL, 0, DISTANCETOPANDBOTTOM);
    CGPathAddQuadCurveToPoint(pathArc, NULL, self.frame.size.width / 2, - 20, self.frame.size.width, DISTANCETOPANDBOTTOM);
    
    [self.layer addSublayer:gradient];
    
}
@end