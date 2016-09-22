//
//  ProfileConsumeCell.m
//  QinQingBao
//
//  Created by shi on 16/5/4.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ProfileTopCell.h"

@implementation ProfileTopCell

+(instancetype)creatProfileConsumeCellWithTableView:(UITableView *)tableView
{
    static NSString * profileConsumeCell = @"profileConsumeCell";
    ProfileTopCell *cell = [tableView dequeueReusableCellWithIdentifier:profileConsumeCell];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProfileTopCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

-(void)setZan:(NSInteger)zannum fansnum:(NSInteger)fansnum attentionnum:(NSInteger)attentionnum
{
    self.zanLab.text = [NSString stringWithFormat:@"%ld",(long)zannum];
    self.fansLab.text = [NSString stringWithFormat:@"%ld",(long)fansnum];
    self.attentionLab.text = [NSString stringWithFormat:@"%ld",(long)attentionnum];
}

- (IBAction)tapButtonAction:(UIButton *)sender
{
    if (self.tapConsumeCellBtnCallback) {
        self.tapConsumeCellBtnCallback(self,sender.tag);
    }
}

@end
