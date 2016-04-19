//
//  NumPickerView.h
//  QinQingBao
//
//  Created by shi on 16/4/15.
//  Copyright © 2016年 董徐维. All rights reserved.
//

//要以直接在 xib 上使用

#import <UIKit/UIKit.h>

@interface NumPickerView : UIView

@property(strong,nonatomic)UIColor *pickerViewButtonColor;  //边框颜色、加减按钮背景颜色，默认为(220, 220, 220)

@property(assign,nonatomic)CGFloat buttonWidth;        //加减按钮宽度  默认为30

@property(assign,nonatomic)CGFloat number;           //要显示的数字，如果小于0自动会设置为0

@property(copy)void(^numberDidChangeHandle)(NSInteger);

+(instancetype)numPickerViewWithFrame:(CGRect)frame;

@end
