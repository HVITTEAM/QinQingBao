//
//  QuestionThreeController.h
//  QinQingBao
//
//  Created by 董徐维 on 16/7/12.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CommonQuesViewController.h"

@interface QuestionThreeController : CommonQuesViewController

/**
 *  题目数据
 */
@property (nonatomic,strong)NSArray *dataProvider;

/**
 *  答案数据
 */
@property (nonatomic, retain) NSMutableArray *answerProvider;

/**
 *  试卷id
 */
@property (nonatomic, copy) NSString *exam_id;

@property (nonatomic, copy) NSString *e_title;


/**
 *  模型计算ID
 */
@property (nonatomic, copy) NSString *calculatype;

@end
