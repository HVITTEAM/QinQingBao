//
//  CAttention.h
//  VideoGo
//
//  Created by hongfei hu on 12-9-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define TAG_ATTENTION_BUBBLE_BTN 20001
#define TAG_ATTENTION_BUBBLE_IMG 20002
#define TAG_ATTENTION_BUBBLE_LAB 20003
#define TAG_HUD                  20005
#define TAG_WAIT_HUD             20006

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface CAttention : NSObject

// 默认弱提示展示
+ (void)showAutoHiddenAttention:(NSString *)text
                         toView:(UIView *)view;

// 自定义弱提示展示 向上偏移量 字体大小 是否需要加蒙班
+ (void)showCustomAutoHiddenAttention:(NSString *)text 
                               toView:(UIView *)view
                            toYOffset:(float)yOffset
                           toFontSize:(UIFont *)font
                    toIsDimBackground:(BOOL)bDimBackground;

// 创建默认忙等待提示
+ (MBProgressHUD *)createWaitViewtoText:(NSString *)text
                               toView:(UIView *)view;

+ (MBProgressHUD *)loadingViewWithText:(NSString *)text toView:(UIView *)view;

// 创建自定义忙等待提示
+ (MBProgressHUD *)createWaitViewtoText:(NSString *)text
                                 toView:(UIView *)view
                              toYOffset:(float)yOffset
                             toFontSize:(UIFont *)font
                      toIsDimBackground:(BOOL)bDimBackground;

// 隐藏忙等待提示
+ (void)hiddenWaitView:(MBProgressHUD *)hud;

// 气泡提示
+ (void)addBubble:(UIView *)view
toCancleBtnDelegate:(id)delegate
     toLabelRight:(float)right
           toText:(NSString *)text
       toBtnFrame:(CGRect)btnFrame
         toAction:(SEL)action;

// 移出气泡提示
+ (void)removeBubble:(UIView *)view;

@end
