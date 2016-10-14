//
//  UIButton+Badge.h
//  QinQingBao
//
//  Created by 董徐维 on 2016/10/13.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Badge)
/**
 *  显示角标的button
 *
 *  @param value badge数值
 */
- (void)initWithBadgeValue:(NSString*)value;
@end
