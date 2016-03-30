//
//  CommonOrderCell.h
//  QinQinBao
//
//  Created by 董徐维 on 15/6/24.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface CommonOrderCell : UITableViewCell

@property (nonatomic, copy) void (^deleteClick)(UIButton *btn);

@property (nonatomic, retain) OrderModel *item;

@property(strong,nonatomic)NSDateFormatter *formatterIn;        //时期格式化对象

@property(strong,nonatomic)NSDateFormatter *formatterOut;        //时期格式化对象

+(CommonOrderCell *) commonOrderCell;

- (IBAction)deleteBtnClickHandler:(id)sender;

@end
