//
//  UIButton+Badge.m
//  QinQingBao
//
//  Created by 董徐维 on 2016/10/13.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "UIView+Badge.h"
#import "HMBadgeView.h"

@implementation UIView (Badge)
- (void)initWithBadgeValue:(NSString*)value
{
    if ([value integerValue] == 0)
    {
        HMBadgeView *view = [self viewWithTag:1010];
        if (view)
            [view removeFromSuperview];
        return ;
    }
    HMBadgeView *bageView = [[HMBadgeView alloc] init];
    bageView.tag = 1010;
    bageView.x = self.width - 10;
    bageView.y = - 7;
    bageView.badgeValue = value;
    [self addSubview:bageView];
}
@end
