//
//  ReportDetailViewController2.h
//  QinQingBao
//
//  Created by 董徐维 on 2017/1/5.
//  Copyright © 2017年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonReportModel.h"

@interface ReportDetailViewController2 : UITableViewController

@property (nonatomic, strong) PersonReportModel *modelData;

@property (nonatomic, copy) NSString *wr_id;     //报告id

@property (nonatomic, copy) NSString *fmno;

@end
