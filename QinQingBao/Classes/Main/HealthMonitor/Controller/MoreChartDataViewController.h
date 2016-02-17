//
//  MoreChartDataViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 15/12/21.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreChartDataViewController : UITableViewController

@property (nonatomic, retain) NSMutableArray *dataProvider;
@property (nonatomic, assign) ChartType type;

@end
