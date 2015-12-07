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
    self.remarkLab.enabled = NO;
    self.remarkLab.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)setItemInfo:(ServiceItemModel *)itemInfo
{
    _itemInfo = itemInfo;
    
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 5;// 字体的行间距
//    NSDictionary *attributes = @{
//                                 NSFontAttributeName:[UIFont fontWithName:@"Helvetica Neue" size:12],
//                                 NSParagraphStyleAttributeName:paragraphStyle
//                                 };
//    self.remarkLab.attributedText = [[NSAttributedString alloc] initWithString:itemInfo.remakr attributes:attributes];
    
    self.remarkLab.text = itemInfo.remakr;
}

@end
