//
//  HMCommonItem.h
//
//  Created by apple on 14-7-21.
//  Copyright (c) 2014年 heima. All rights reserved.
//  用一个HMCommonItem模型来描述每行的信息：图标、标题、子标题、右边的样式（箭头、文字、数字、开关、打钩）

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HMCommonItem : NSObject

/** 文本输入框 */
@property (strong, nonatomic) UITextField *rightText;
/** 图标 */
@property (nonatomic, copy) NSString *icon;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 子标题 */
@property (nonatomic, copy) NSString *subtitle;
/** 右边显示的数字标记 */
@property (nonatomic, copy) NSString *badgeValue;
/** uiswitch的选中状态 */
@property (nonatomic, assign) BOOL selected;
/** 点击这行cell，需要调转到哪个控制器 */
@property (nonatomic, assign) Class destVcClass;
/** 封装点击这行cell想做的事情 */
// block 只能用 copy
@property (nonatomic, copy) void (^operation)();

/** 封装点击这行的switch想做的事情 */
// block 只能用 copy
@property (nonatomic, copy) void (^switchChangeBlock)(UISwitch *switchBtn);

@property (nonatomic, copy) void (^buttonClickBlock)(UIButton *btn);


+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon;
+ (instancetype)itemWithTitle:(NSString *)title;

@end
