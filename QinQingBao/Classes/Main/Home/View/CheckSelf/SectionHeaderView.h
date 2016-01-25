//
//  SectionHeaderView.h
//  QinQingBao
//
//  Created by shi on 16/1/22.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionHeaderView : UIView

/**
 *  创建一个 section 头部视图
 */
+(SectionHeaderView *)createSectionHeaderWithSectionName:(NSString *)name iconName:(NSString*)iconName;

@end
