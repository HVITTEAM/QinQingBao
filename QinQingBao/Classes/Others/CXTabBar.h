//
//  CXTabBar.h
//  QinQingBao
//
//  Created by 董徐维 on 16/9/9.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CXTabBar;

@protocol CXTabBarDelegate <NSObject>

@optional
- (void)tabBarDidClickedPlusButton:(CXTabBar *)tabBar;

@end

@interface CXTabBar : UITabBar
@property (nonatomic, weak) id<CXTabBarDelegate> tabBarDelegate;
@end
