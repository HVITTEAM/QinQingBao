//
//  UITextField+Validate.h
//  QinQingBao
//
//  Created by 董徐维 on 16/5/27.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  验证输入框（手机号码，金额）
 */
@interface UITextField (Validate)
/**
 *  验证金额的输入框
 *  输入框中只能输入数字和小数点，且小数点只能输入一位，参数number 可以设置小数的位数
 *  该函数在-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string调用；
 *
 *  @param textfield 文本框
 *  @param range     NSRange
 *  @param string    string
 *  @param number    小数点后几位
 *
 *  @return 是否验证通过
 */
-(BOOL)isValidAboutMoneyTextFiled:(UITextField *)textfield shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  decimalNumber: (NSInteger) number;

/**
 *  验证手机号码的输入框 （仅仅是十一位的手机号码）
 *
 *  @param textfield 文本框
 *  @param range     NSRange
 *  @param string    string
 *  @param number    小数点后几位
 *
 *  @return 是否验证通过
 */
-(BOOL)isValidAboutMobileTextFiled:(UITextField *)textfield shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
@end
