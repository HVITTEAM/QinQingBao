//
//  BloodCell.m
//  QinQingBao
//
//  Created by shi on 15/8/21.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "BloodCell.h"

@implementation BloodCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setItem:(HealthDataModel *)item
{
    _item = item;
    
    switch (self.type) {
        case ChartTypeBlood:
            self.bloodLab.text = [NSString stringWithFormat:@"%@/%@",item.systolic,item.diastolic];
            self.timeLab.text = item.bloodp_time;
            self.decLab.text = @"mmHg";
            break;
        case ChartTypeSugar:
        {
            float floatString = [item.bloodsugar floatValue];
            self.bloodLab.text = [NSString stringWithFormat:@"%.01f",floatString];
            self.timeLab.text = item.bloodsugar_time;
            self.decLab.text = @"mmol/L";
            break;
        }
        case ChartTypeHeart:
            self.bloodLab.text = [NSString stringWithFormat:@"%@",item.heartrate_avg];
            self.timeLab.text = item.heart_time;
            self.decLab.text = @"次/分钟";
            break;
        default:
            break;
    }
 }
@end
