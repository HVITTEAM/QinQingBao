//
//  HeartbeatCell.h
//  QinQingBao
//
//  Created by 董徐维 on 15/11/4.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeartbeatCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *heartBeatLab;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;

@property (nonatomic, strong) HealthDataModel *item;

+(HeartbeatCell *)heartbeatCell;
@end