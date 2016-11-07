//
//  TopCell.m
//  QinQingBao
//
//  Created by 董徐维 on 2016/11/3.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "TopCell.h"

@implementation TopCell

+ (TopCell*)topCell
{
    TopCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"TopCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.zdlab.layer.borderColor = [UIColor redColor].CGColor;
    self.zdlab.layer.borderWidth = 0.5f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
