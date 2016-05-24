//
//  TimeLineCell.h
//  QinQingBao
//
//  Created by 董徐维 on 15/11/27.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeLineModel.h"

@interface TimeLineCell : UITableViewCell

+ (TimeLineCell*) timeLineCell;

@property (nonatomic, retain) TimeLineModel *item;
@end
