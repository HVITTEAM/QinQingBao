//
//  CXRuler.h
//  QinQingBao
//
//  Created by 董徐维 on 16/6/30.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXRulerScrollView.h"
@class CXRuler;

@protocol CXRulerDelegate <NSObject>

- (void)CXRuler:(CXRulerScrollView *)rulerScrollView ruler:(CXRuler *)ruler;

@end

@interface CXRuler : UIView <UIScrollViewDelegate>

@property (nonatomic, assign) id <CXRulerDelegate> rulerDelegate;


/*
*  count * average = 刻度最大值
*  @param count        10个小刻度为一个大刻度，大刻度的数量
*  @param average      每个小刻度的值，最小精度 0.1
*  @param startValue 直尺初始化的开始刻度值
*  @param currentValue 直尺初始化的刻度值
*/
- (void)showRulerScrollViewWithCount:(NSUInteger)count average:(NSNumber *)average startValue:(CGFloat)startValue currentValue:(CGFloat)currentValue;

@end