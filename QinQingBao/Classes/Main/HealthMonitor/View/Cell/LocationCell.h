//
//  LocationCell.h
//  QinQingBao
//
//  Created by 董徐维 on 15/9/24.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *locationLab;
@property (strong, nonatomic) IBOutlet UILabel *timaLab;

@property (nonatomic, strong) HealthDataModel *item;

+(LocationCell *)locationCell;
@end
