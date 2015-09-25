//
//  BloodPressureCell.h
//  QinQingBao
//
//  Created by 董徐维 on 15/9/24.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BloodPressureCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *hightLab;
@property (strong, nonatomic) IBOutlet UILabel *lowLab;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;


@property (nonatomic, strong) HealthDataModel *item;

@end
