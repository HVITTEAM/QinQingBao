//
//  RadianView.h
//  Circle
//
//  Created by shi on 16/7/6.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadianView : UIView

//圆圈的值
@property(assign,nonatomic)CGFloat percentValue;   //0到100的值,表示百分比,默认为0

//中间显示的文本
@property (nonatomic, copy) NSString *midStr;

@property(assign,nonatomic)CGFloat lineWidth;  //线宽  默认为20

@property(assign,nonatomic)CGFloat lineThick;  //线粗细  默认为2

@property(assign,nonatomic)CGFloat lineSpace;  //线粗细  默认为6

@property(strong,nonatomic)UIColor *lowerCircleColor;  //下层圆的颜色 ,默认为白色

@property(strong,nonatomic)UIColor *upperCircleColor;   //上层圆的颜色,默认为红色

@property (nonatomic, copy) NSString *dangerText;



@end
