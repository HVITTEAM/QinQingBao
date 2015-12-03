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
    
    NSString *str = [itemInfo.servicetime stringByReplacingOccurrencesOfString:@"#" withString:@"\n"];
    
    UILabel *lab = [[UILabel alloc] init];
    
    lab.numberOfLines = 0;
    
    lab.font = [UIFont systemFontOfSize:12];
    
    lab.text = str;
    
    CGSize size = [lab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    
    lab.frame = CGRectMake(10, 70, MTScreenW, size.height);
    
    [self addSubview:lab];
    
    self.height = CGRectGetMaxY(lab.frame) + 10;
    
}

@end
