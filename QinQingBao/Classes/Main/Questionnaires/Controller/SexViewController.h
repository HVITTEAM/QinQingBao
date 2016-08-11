//
//  SexViewController.h
//  Healthy
//
//  Created by shi on 16/7/11.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonQuesViewController.h"
#import "ExamModel.h"
#import "ClasslistExamInfoModel.h"

@interface SexViewController : CommonQuesViewController

/**
 *  试卷id
 */
@property (nonatomic, copy) NSString *exam_id;

/**
 *  模型计算ID
 */
@property (nonatomic, copy) NSString *calculatype;

@property (nonatomic, copy) NSString *e_title;


@end
