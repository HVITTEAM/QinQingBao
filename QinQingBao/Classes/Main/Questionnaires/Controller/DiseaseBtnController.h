//
//  DiseaseBtnController.h
//  QinQingBao
//
//  Created by shi on 16/8/10.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonBtnViewController.h"

@interface DiseaseBtnController : CommonBtnViewController

/**
 *  题目数据
 */
@property (nonatomic, retain) NSArray *dataProvider;

/**
 *  答案数据
 */
@property (nonatomic, retain) NSMutableArray *answerProvider;

/**
 *  试卷id
 */
@property (nonatomic, copy) NSString *exam_id;

/**
 *  模型计算ID
 */
@property (nonatomic, copy) NSString *calculatype;

@end
