//
//  UIView+Placeholder.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/7.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "UIView+Placeholder.h"

@implementation UIView (Placeholder)

/**
*  提示用户
*
*/
- (void)showNonedataTooltip
{
    // 1.创建一个UILabel
    UILabel *label = [[UILabel alloc] init];
    label.text = @"没有新的数据了";
    // 3.设置背景
    label.backgroundColor = [UIColor orangeColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    
    // 4.设置frame
    label.width = MTScreenW;
    label.height = 35;
    label.font = [UIFont systemFontOfSize:13];
    label.x = 0;
    label.y = MTScreenH;
    
    // 5.添加到导航控制器的view
    //    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
    [self addSubview:label];
    
    // 6.动画
    CGFloat duration = 0.75;
    [UIView animateWithDuration:duration animations:^{
        // 往下移动一个label的高度
        label.transform = CGAffineTransformMakeTranslation(0, -label.height);
    } completion:^(BOOL finished) { // 向下移动完毕
        
        // 延迟delay秒后，再执行动画
        CGFloat delay = 1.0;
        
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            // 恢复到原来的位置
            label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
            // 删除控件
            [label removeFromSuperview];
        }];
    }];
}

@end
