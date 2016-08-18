//
//  PlanReportTitleCell.h
//  QinQingBao
//
//  Created by 董徐维 on 16/8/17.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InterveneModel;

@interface PlanReportTitleCell : UITableViewCell


+ (PlanReportTitleCell*) planReportTitleCell;

@property (nonatomic, retain) InterveneModel *item;
@end
