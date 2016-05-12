//
//  ProfileConsumeCell.h
//  QinQingBao
//
//  Created by shi on 16/5/4.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileConsumeCell : UITableViewCell

@property(copy)void(^tapConsumeCellBtnCallback)(ProfileConsumeCell *,NSUInteger idx);

+(instancetype)creatProfileConsumeCellWithTableView:(UITableView *)tableView;

@end
    