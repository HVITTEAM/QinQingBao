//
//  ServiceDetailCell.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/9.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "ServiceDetailCell.h"

@implementation ServiceDetailCell

+(ServiceDetailCell *)serviceCell
{
    ServiceDetailCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"ServiceDetailCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib
{
    self.contentView.backgroundColor = HMGlobalBg;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setItemInfo:(ServiceItemModel *)itemInfo
{
    _itemInfo = itemInfo;
    
    self.titleLab.font = [UIFont systemFontOfSize:16];
    
    UILabel *lab = [[UILabel alloc] init];
    
    lab.numberOfLines = 0;
    
    lab.font = [UIFont systemFontOfSize:13];
    
    lab.textColor = [UIColor darkGrayColor];

    lab.text = itemInfo.icontent;
    
    CGRect tmpRect = [lab.text boundingRectWithSize:CGSizeMake(MTScreenW - 20, 1000)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:[NSDictionary dictionaryWithObjectsAndKeys:lab.font,NSFontAttributeName, nil]
                                            context:nil];
    
    lab.frame = CGRectMake(10, 50, tmpRect.size.width, tmpRect.size.height);
    
    [self addSubview:lab];
    
    self.height = CGRectGetMaxY(lab.frame) + 10;
    
}

@end
