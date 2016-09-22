//
//  QuestionCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/9/20.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "QuestionCell.h"

@implementation QuestionCell


+ (instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString *siglePicCardCellId = @"questionCell";
    QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:siglePicCardCellId];
    if (!cell) {
        cell.height = 85;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = [[[NSBundle mainBundle] loadNibNamed:@"QuestionCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
