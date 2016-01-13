//
//  MTCommonTextCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/9.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "MTCommonTextCell.h"

@implementation MTCommonTextCell

+(MTCommonTextCell *)commonTextCell
{
    MTCommonTextCell * cell = [[self alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (UITextField *)textField
{
    if (_textField == nil) {
        self.textField = [[UITextField alloc] init];
        self.textField.textColor = [UIColor colorWithRGB:@"666666"];
        self.textField.font = [UIFont systemFontOfSize:14];
    }
    return _textField;
}

- (void)awakeFromNib
{
    
}


-(void)setItemWithTittle:(NSString *)title placeHolder:(NSString *)placeHolder;
{
    self.textLabel.x = 10;
    self.textLabel.textColor = [UIColor colorWithRGB:@"333333"];
    self.textLabel.font = [UIFont systemFontOfSize:14];
    self.textLabel.text = title;
    
    self.textField.frame = CGRectMake(80, 0, MTScreenW - 90, self.height);
    self.textField.placeholder = placeHolder;
    self.textField.clearButtonMode = UITextFieldViewModeAlways;
    [self.contentView addSubview:self.textField];
    
    self.height = 44;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


@end
