//
//  ProfileConsumeCell.m
//  QinQingBao
//
//  Created by shi on 16/5/4.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ProfileConsumeCell.h"

@implementation ProfileConsumeCell

+(instancetype)creatProfileConsumeCellWithTableView:(UITableView *)tableView
{
    static NSString * profileConsumeCell = @"profileConsumeCell";
    ProfileConsumeCell *cell = [tableView dequeueReusableCellWithIdentifier:profileConsumeCell];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProfileConsumeCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

- (IBAction)tapButtonAction:(UIButton *)sender
{
    if (self.tapConsumeCellBtnCallback) {
        self.tapConsumeCellBtnCallback(self,sender.tag);
    }
}

@end
