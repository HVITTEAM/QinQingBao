//
//  MTCommonTextCell.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/9.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTCommonTextCell : UITableViewCell


+(MTCommonTextCell *)commonTextCell;
/**
 * 文本label
 */
@property (strong, nonatomic) UITextField *textField;

-(void)setItemWithTittle:(NSString *)title placeHolder:(NSString *)placeHolder;
@end
