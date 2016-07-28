//
//  CommonMarketCell.h
//  QinQingBao
//
//  Created by 董徐维 on 16/6/21.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ExamModel;

@interface CommonExamCell : UITableViewCell

+ (CommonExamCell*) commonExamCell;

@property (nonatomic, retain) ExamModel *item;
@end
