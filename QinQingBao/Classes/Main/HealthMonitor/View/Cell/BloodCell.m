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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setItem:(HealthDataModel *)item
{
    _item = item;
    
    switch (self.type) {
        case ChartTypeBlood:
            self.bloodLab.text = [NSString stringWithFormat:@"%@/%@",item.systolic,item.isastolic];
            self.timeLab.text = item.bloodp_time;
            self.decLab.text = @"mmol/L";
            break;
        case ChartTypeSugar:
            self.bloodLab.text = [NSString stringWithFormat:@"%@",item.bloodglucose];
            self.timeLab.text = item.boolg_time;
            self.decLab.text = @"mmHg";
            break;
        case ChartTypeHeart:
            self.bloodLab.text = [NSString stringWithFormat:@"%@/%@",item.heartrate_max,item.heartrate_min  ];
            self.timeLab.text = item.heart_time;
            self.decLab.text = @"次/分钟";
            break;
        default:
            break;
    }
 }


@end
