//
//  AddaddressInfoViewController.h
//  QinQingBao
//
//  Created by Dual on 16/1/9.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MallAddressModel.h"

@interface AddaddressInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameTextField; //姓名
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField; //手机
@property (weak, nonatomic) IBOutlet UITextField *provinceTextField; //省份
@property (weak, nonatomic) IBOutlet UIImageView *provinceImageView; //省份辅助视图
@property (weak, nonatomic) IBOutlet UITextField *cityTextField; //城市
@property (weak, nonatomic) IBOutlet UIImageView *cityImageView; //城市辅助视图
@property (weak, nonatomic) IBOutlet UITextField *regionTextField; //区域
@property (weak, nonatomic) IBOutlet UIImageView *regionImageView; //区域辅助视图
@property (weak, nonatomic) IBOutlet UITextField *addressTextField; //地址详细
@property (weak, nonatomic) IBOutlet UITextField *telephoneTextField; //电话
@property (strong, nonatomic) IBOutlet UIView *bgview;

@property (nonatomic, retain) MallAddressModel *item;
@end
