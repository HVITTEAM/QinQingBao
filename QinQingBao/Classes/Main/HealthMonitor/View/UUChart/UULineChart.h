//
//  UULineChart.h
//  UUChartDemo
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "UUColor.h"
#import "UIView+Extension.h"

#define chartMargin     10
#define xLabelMargin    15
#define yLabelMargin    15
#define UULabelHeight    10
#define UUYLabelwidth     30
#define UUTagLabelwidth     80

@interface UULineChart : UIView

@property (strong, nonatomic) NSArray * xLabels;

@property (strong, nonatomic) NSArray * yLabels;

@property (strong, nonatomic) NSArray * yValues;

@property (nonatomic, strong) NSArray * colors;

@property (nonatomic) CGFloat xLabelWidth;
@property (nonatomic) CGFloat yValueMin;
@property (nonatomic) CGFloat yValueMax;

@property (nonatomic, assign) CGRange markRange;

@property (nonatomic, assign) CGRange chooseRange;

@property (nonatomic, assign) BOOL showRange;

@property (nonatomic, retain) NSMutableArray *ShowHorizonLine;
@property (nonatomic, retain) NSMutableArray *ShowMaxMinArray;

//新添加的属性yView用于显示y轴坐标，yLabelArray用于存放yLabel.
@property (nonatomic,strong)  UIView *yView;
@property (nonatomic, retain) NSMutableArray *yLabelArray;

-(void)strokeChart;

@end
