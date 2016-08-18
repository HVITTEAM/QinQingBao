//
//  RulerViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 16/6/30.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"

@interface CommonRulerViewController : UIViewController

/**
 *  初始化刻度尺
 *
 *  @param title        当前界面的title
 *  @param startValue   开始的刻度
 *  @param currentValue 当前的刻度
 *  @param count        一共多少刻度
 */
-(void)initWithTitle:(NSString *)title startValue:(CGFloat)startValue currentValue:(CGFloat)currentValue count:(NSUInteger)count unit:(NSString *)unit;

@property (nonatomic, copy) void (^selectedResult)(CGFloat value);


/**
 *  题目数据
 */
@property (nonatomic, retain) QuestionModel *questionItem;

@property (nonatomic, retain) UIImage *headImgData;

@end
