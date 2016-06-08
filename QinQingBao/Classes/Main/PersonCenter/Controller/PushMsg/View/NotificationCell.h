//
//  NotificationCell.h
//  QinQingBao
//
//  Created by shi on 16/6/1.
//  Copyright © 2016年 董徐维. All rights reserved.
//个人中心-我的消息-通知消息

#import <UIKit/UIKit.h>
@class PushMsgModel;
@interface NotificationCell : UITableViewCell

+(instancetype)createCellWithTableView:(UITableView *)tableView;

-(void)setDataWithModel:(PushMsgModel *)model;

@end
