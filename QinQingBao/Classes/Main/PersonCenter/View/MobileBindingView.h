//
//  MobileBindingView.h
//  QinQingBao
//
//  Created by shi on 16/6/3.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MobileBindingView : UIView

/**
 * 点击确认按钮后回调，传回手机号与验证码 第一个参数为手机号，第二个为验证码
 */
@property(copy)void(^tapConfirmBtnCallBack)(NSString *,NSString *);

/**
 * 点击取消按钮后回调,可以不设置
 */
@property(copy)void(^tapCancelBtnCallBack)();

/**
 *  创建一个MobileBindingView并显示到指定view上
 */
+(MobileBindingView *)showMobileBindingViewToView:(UIView *)targetView;

/**
 *  从指定view上删除
 */
-(void)hideMobileBindingView;

@end
