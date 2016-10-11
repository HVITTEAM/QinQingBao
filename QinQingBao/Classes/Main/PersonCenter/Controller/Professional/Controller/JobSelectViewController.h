//
//  JobSelectViewController.h
//  QinQingBao
//
//  Created by shi on 16/10/10.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpertModel.h"

@interface JobSelectViewController : UITableViewController

@property (strong, nonatomic) NSArray *dataProvider;       //数据源

@property (copy) void(^selectCompleteCallBack)(ExpertModel *item);

- (void)showJobSelectViewInView:(UIView *)v;

@end
