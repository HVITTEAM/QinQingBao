//
//  HeartImageCell.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeartImageCell : UITableViewCell

+(HeartImageCell *)heartImageCell;

@property (nonatomic, strong) HealthDataModel *item;

@end
