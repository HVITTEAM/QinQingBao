//
//  circleWaitView.h
//  shipin7HD
//
//  Created by yudan on 13-4-27.
//  Copyright (c) 2013年 Dengsh. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ANIMATION_KEY_CIRCLE                @"circle"  


@interface circleWaitView : UIView
{
    UIImageView             *_bgView;
    UIImageView             *_lodingView;
}


// 显示
- (void)show;

// 隐藏
- (void)hide;


@end
