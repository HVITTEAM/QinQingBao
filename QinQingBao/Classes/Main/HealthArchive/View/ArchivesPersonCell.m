//
//  ArchivesPersonCell.m
//  QinQingBao
//
//  Created by shi on 2016/11/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ArchivesPersonCell.h"

@implementation ArchivesPersonCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"archivesPersonCell";
    ArchivesPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ArchivesPersonCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.badgeIcon.layer.cornerRadius = 4;
    self.contentV.layer.cornerRadius = 5;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imgView.layer.cornerRadius = self.imgView.width/2;
    self.imgView.layer.masksToBounds = YES;
}

@end

