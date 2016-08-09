//
//  BasicViewController.h
//  Healthy
//
//  Created by shi on 16/7/11.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonQuesViewController.h"

@interface BasicViewController : CommonQuesViewController

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
