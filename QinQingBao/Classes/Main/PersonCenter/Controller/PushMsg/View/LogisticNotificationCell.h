//
//  LogisticNotificationCell.h
//  QinQingBao
//
//  Created by shi on 16/6/1.
//  Copyright © 2016年 董徐维. All rights reserved.
//个人中心-我的消息-物流助手

#import <UIKit/UIKit.h>

@interface LogisticNotificationCell : UITableViewCell

+(instancetype)createCellWithTableView:(UITableView *)tableView;

-(void)setdataWithModel:(NSString *)str;

@end
