//
//  QuestionResultController3.h
//  QinQingBao
//
//  Created by shi on 2016/11/7.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionResultController3 : UITableViewController

//@property (strong, nonatomic) ResultModel *qResultModel;

@property (nonatomic, copy) NSString *r_dangercoefficient;

@property (nonatomic, copy) NSString *hmd_advise;

@property (nonatomic, copy) NSArray *r_ids;

// 依次来判断是否归档了
@property (nonatomic, copy) NSString *truename;

@end
