//
//  Gene_DetectionViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 2017/1/8.
//  Copyright © 2017年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonReportModel.h"
@interface Gene_DetectionViewController : UITableViewController

@property (nonatomic, strong) PersonReportModel *modelData;

@property (nonatomic, copy) NSString *fmno;
@property (nonatomic, copy) NSString *wr_id;     //报告id

@end
