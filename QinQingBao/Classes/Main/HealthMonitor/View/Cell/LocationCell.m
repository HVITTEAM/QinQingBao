//
//  LocationCell.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/24.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "LocationCell.h"

@implementation LocationCell


+(LocationCell *)locationCell
{
    LocationCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"LocationCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setItem:(HealthDataModel *)item
{
    _item = item;
    
    self.locationLab.text = item.address;
    self.locationLab.textColor = MTNavgationBackgroundColor;
    NSString *time                            = [NSString stringWithFormat:@"更新时间: %@",item.gps_time];
    self.timaLab.text = time;
}

@end
