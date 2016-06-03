//
//  NewsCell.h
//  QinQingBao
//
//  Created by shi on 16/5/31.
//  Copyright © 2016年 董徐维. All rights reserved.
//个人中心-我的消息-活动资讯、健康小贴士

#import <UIKit/UIKit.h>
@class EventMsgModel;

@interface NewsCell : UITableViewCell

+(instancetype)createCellWithTableView:(UITableView *)tableView;

-(void)setDataWithMode:(EventMsgModel *)model;

@end
