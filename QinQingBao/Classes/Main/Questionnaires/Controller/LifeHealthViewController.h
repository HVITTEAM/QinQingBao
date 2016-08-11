//
//  LifeHealthViewController.h
//  QinQingBao
//
//  Created by shi on 16/8/10.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonBtnViewController.h"

@interface LifeHealthViewController : CommonBtnViewController

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
 *  e_title
 */
@property (nonatomic, copy) NSString *e_title;


/**
 *  模型计算ID
 */
@property (nonatomic, copy) NSString *calculatype;

@end
