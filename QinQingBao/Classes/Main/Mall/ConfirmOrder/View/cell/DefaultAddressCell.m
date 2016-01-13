//
//  DefaultAddressCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/9.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "DefaultAddressCell.h"

@implementation DefaultAddressCell


+(DefaultAddressCell *)defaultAddressCell
{
    DefaultAddressCell * cell = [[self alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

#pragma mark - 懒加载右边的view
- (UIImageView *)locationImg
{
    if (_locationImg == nil) {
        self.locationImg = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"map"]];
    }
    return _locationImg;
}

- (UILabel *)nameLab
{
    if (_nameLab == nil) {
        self.nameLab = [[UILabel alloc] init];
        self.nameLab.textColor = [UIColor colorWithRGB:@"666666"];
        self.nameLab.font = [UIFont systemFontOfSize:14];
    }
    return _nameLab;
}

- (UILabel *)addressLab
{
    if (_addressLab == nil) {
        self.addressLab = [[UILabel alloc] init];
        self.addressLab.textColor = [UIColor colorWithRGB:@"666666"];
        self.addressLab.font = [UIFont systemFontOfSize:14];
        self.addressLab.numberOfLines = 0;
    }
    return _addressLab;
}

- (UILabel *)telLab
{
    if (_telLab == nil) {
        self.telLab = [[UILabel alloc] init];
        self.telLab.textColor = [UIColor colorWithRGB:@"666666"];
        self.telLab.font = [UIFont systemFontOfSize:14];
        self.telLab.textAlignment = NSTextAlignmentRight;
    }
    return _telLab;
}


- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setItem:(MallAddressModel*)item
{
    self.locationImg.x = 10;
    
    [self addSubview: self.locationImg];
    
    self.nameLab.frame = CGRectMake(CGRectGetMaxX(self.locationImg.frame) + 10, 10, 100, 21);
    self.nameLab.text = [NSString stringWithFormat:@"收货人:%@",item.true_name];
    [self.contentView addSubview:self.nameLab];
    
    self.telLab.text = item.mob_phone;
    self.telLab.frame = CGRectMake(CGRectGetMaxX(self.nameLab.frame), 10, 150, 21);
    [self.contentView addSubview:self.telLab];

    
    NSArray *arr = [item.area_info componentsSeparatedByString:@"-"];
    
    self.addressLab.text = [NSString stringWithFormat:@"%@%@%@%@",arr[0],arr[1],arr[2],item.address];
    
    CGRect tmpRect = [self.addressLab.text boundingRectWithSize:CGSizeMake(MTScreenW - CGRectGetMaxX(self.locationImg.frame) - 50, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.addressLab.font,NSFontAttributeName, nil] context:nil];
    self.addressLab.frame = CGRectMake(CGRectGetMaxX(self.locationImg.frame) + 10, CGRectGetMaxY(self.nameLab.frame)+5, MTScreenW - CGRectGetMaxX(self.locationImg.frame) - 40, tmpRect.size.height);
    [self.contentView addSubview:self.addressLab];
    
    self.height = CGRectGetMaxY(self.addressLab.frame) + 10;
    
    self.locationImg.y = self.height/2 - 10;
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.height, MTScreenW, 0.5)];
    line.backgroundColor=[UIColor colorWithRGB:@"e2e2e2"];
    [self addSubview:line];
}

@end
