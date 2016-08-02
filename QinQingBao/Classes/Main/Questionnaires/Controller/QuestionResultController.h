//
//  QuestionResultController.h
//  QinQingBao
//
//  Created by 董徐维 on 16/7/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CommonQuesViewController.h"
@class ReportListModel;

@interface QuestionResultController : CommonQuesViewController

/**
 *  答案数据
 */
@property (nonatomic, retain) NSMutableArray *answerProvider;

/**
 *  试卷id
 */
@property (nonatomic, copy) NSString *exam_id;

/**
 *  问卷答案列表中的一个数据,从个人中心评价列表中进入该界面时需要传递
 */
@property (nonatomic,strong)ReportListModel *reportListModel;

@end


