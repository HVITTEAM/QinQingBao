//
//  RemarkDetailCell.m
//  QinQingBao
//
//  Created by 董徐维 on 15/11/17.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "RemarkDetailCell.h"

@implementation RemarkDetailCell

+ (RemarkDetailCell*) remarkDetailCell
{
    RemarkDetailCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"RemarkDetailCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib
{
    self.contentView.backgroundColor = HMGlobalBg;
    self.topLine.backgroundColor = HMColor(223, 223, 223);
    self.topLine.height = 0.50f;
    
}

- (void)drawRect:(CGRect)rect
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)setItemInfo:(ServiceItemModel *)itemInfo
{
    _itemInfo = itemInfo;
    
    self.titleLab.font = [UIFont systemFontOfSize:16];
    
    UILabel *remarkLab = [[UILabel alloc] init];
    
    remarkLab.numberOfLines = 0;
    
    remarkLab.font = [UIFont systemFontOfSize:13];
    
    remarkLab.text = itemInfo.remakr;
    
    remarkLab.textColor = [UIColor darkGrayColor];

    CGRect tmpRect = [remarkLab.text boundingRectWithSize:CGSizeMake(MTScreenW - 20, 1000)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:[NSDictionary dictionaryWithObjectsAndKeys:remarkLab.font,NSFontAttributeName, nil]
                                                  context:nil];

    remarkLab.frame = CGRectMake(10, 35, tmpRect.size.width, tmpRect.size.height);
    
    [self addSubview:remarkLab];
    
    self.height = CGRectGetMaxY(remarkLab.frame) + 10;
}

@end
