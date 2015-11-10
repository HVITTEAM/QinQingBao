//
//  LocationCell.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/24.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "LocationCell.h"

@implementation LocationCell

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
    NSString *time                            = [NSString stringWithFormat:@"更新时间: %@",item.gps_time];
    self.timaLab.text = time;
}

@end
