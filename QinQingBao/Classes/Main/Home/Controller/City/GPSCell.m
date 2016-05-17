//
//  GPSCell.m
//  QinQingBao
//
//  Created by 董徐维 on 15/12/1.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "GPSCell.h"

@implementation GPSCell


+ (GPSCell*) GPSCell
{
    GPSCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"GPSCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib
{
    self.backgroundColor = HMColor(241, 241, 241);
}

-(void)setCityValue:(NSString *)cityValue
{
    _cityValue = cityValue;
    CGSize size = [cityValue sizeWithAttributes:@{NSFontAttributeName:self.cityLab.titleLabel.font}];
    self.widthConstraint.constant = size.width + 20;
    [self.cityLab setTitle:_cityValue forState:UIControlStateNormal];
}

@end
