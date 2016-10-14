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
    HMBadgeView *bageView = [[HMBadgeView alloc] init];
    bageView.x = self.width - 10;
    bageView.y = - 7;
    bageView.badgeValue = value;
    [self addSubview:bageView];
}
@end
