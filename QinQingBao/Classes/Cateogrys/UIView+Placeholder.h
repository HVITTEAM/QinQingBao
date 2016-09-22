//
//  UIView+Placeholder.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/7.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Placeholder)

/**
 *  移除空UI
 */
- (void)removePlace;
/**
 *  显示空数据提醒
 */
- (void)showNonedataTooltip;
/**
 *  显示空数据界面
 *
 *  @param placeStr 显示文本
 */
- (void)initWithPlaceString:(NSString *)placeStr imgPath:(NSString *)imgPath;

@end
