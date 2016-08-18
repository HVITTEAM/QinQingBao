//
//  CommonPlanCell.h
//  QinQingBao
//
//  Created by 董徐维 on 16/6/21.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommonPlanModel;

@interface CommonPlanCell : UITableViewCell

+ (CommonPlanCell*) commonPlanCell;

@property (nonatomic, retain) CommonPlanModel *item;
@end
