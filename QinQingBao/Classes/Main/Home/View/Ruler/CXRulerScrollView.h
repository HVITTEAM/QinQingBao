//
//  CXRulerScrollView.h
//  QinQingBao
//
//  Created by 董徐维 on 16/6/30.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DISTANCELEFTANDRIGHT 8.f // 标尺左右距离
#define DISTANCEVALUE 8.f // 每隔刻度实际长度8个点
#define DISTANCETOPANDBOTTOM 20.f // 标尺上下距离

@interface CXRulerScrollView : UIScrollView

@property (nonatomic,assign) NSUInteger rulerCount;

@property (nonatomic,assign) NSNumber * rulerAverage;

@property (nonatomic,assign) CGFloat startValue;

@property (nonatomic,assign) NSUInteger rulerHeight;

@property (nonatomic,assign) NSUInteger rulerWidth;
/**
 *  当前刻度
 */
@property (nonatomic,assign) CGFloat rulerValue;
/**
 *  画刻度尺
 */
- (void)drawRuler;

@end