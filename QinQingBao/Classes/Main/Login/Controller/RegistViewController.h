//
//  RegistViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 15/8/12.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//qwe vvvv wwww ppp

#import <UIKit/UIKit.h>

@interface RegistViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneNumText;
@property (weak, nonatomic) IBOutlet UITextField *VerNumText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *verBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreementBtn;
@property (weak, nonatomic) IBOutlet UIButton *registNowBtn;

//容纳文本输入框的UIView
@property (strong, nonatomic) IBOutlet UIView *txtview;
//当前正在使用的文本输入框
@property (strong,nonatomic)UITextField *currentText;
//键盘高度
@property(assign,nonatomic)CGFloat keyBoardH;
@end
