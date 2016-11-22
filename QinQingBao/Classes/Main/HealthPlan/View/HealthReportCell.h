//
//  HealthReportCell.h
//  QinQingBao
//
//  Created by 董徐维 on 2016/11/7.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonReportModel.h"

@interface HealthReportCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *bgview;
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UIImageView *topIcon;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIScrollView *pageView;
@property (strong, nonatomic) IBOutlet UILabel *planLab;
+ (HealthReportCell*) healthReportCell;


@property (nonatomic, retain) NSArray *dataProvider;
/**
 type 1 报告 2 干预方案
 */
@property (nonatomic, copy) void (^clickType)(PersonReportModel *item);

@end
