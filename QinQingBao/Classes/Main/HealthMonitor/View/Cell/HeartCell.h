//
//  HeartCell.h
//  QinQingBao
//
//  Created by 董徐维 on 15/8/19.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeartCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *heartDataLabel;
@property (strong, nonatomic) IBOutlet UIView *bgView;

/** cell更新时间 */
@property (strong, nonatomic) IBOutlet UILabel *time;
/** cell对应的item数据 */
@property (nonatomic, strong) HealthDataModel *item;
@end
