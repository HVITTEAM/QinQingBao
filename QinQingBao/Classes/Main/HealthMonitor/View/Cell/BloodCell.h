//
//  BloodCell.h
//  QinQingBao
//
//  Created by shi on 15/8/21.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BloodCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *bloodLab;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;
@property (strong, nonatomic) IBOutlet UILabel *decLab;

@property (nonatomic, strong) HealthDataModel *item;
@property (nonatomic, assign) ChartType type;

@end
