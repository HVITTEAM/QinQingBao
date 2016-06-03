//
//  MessageTypeCell.h
//  QinQingBao
//
//  Created by 董徐维 on 16/6/1.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTypeCell : UITableViewCell

+(MessageTypeCell *) messageTypeCell;

@property (strong, nonatomic) IBOutlet UIImageView *headImg;
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UILabel *subtitleLab;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;
@property (strong, nonatomic) IBOutlet UIView *badgeView;

@end
