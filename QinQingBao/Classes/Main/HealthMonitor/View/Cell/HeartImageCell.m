//
//  HeartImageCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "HeartImageCell.h"

@implementation HeartImageCell

+(HeartImageCell *)heartImageCell
{
    HeartImageCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"HeartImageCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)setItem:(HealthModel *)item
{
    _item = item;
    
    UILabel *lab = [self viewWithTag:10];
    if (lab)
    {
        NSString *time                            = [NSString stringWithFormat:@"更新时间: %@",item.ect_time];
        lab.text = time;
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
