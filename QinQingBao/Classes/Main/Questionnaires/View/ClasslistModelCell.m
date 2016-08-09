//
//  ClasslistModelCell.m
//  QinQingBao
//
//  Created by shi on 16/8/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ClasslistModelCell.h"
#import "ClasslistModel.h"

@interface ClasslistModelCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIImageView *bkImageView;

@property (weak, nonatomic) IBOutlet UILabel *numberLb;

@property (weak, nonatomic) IBOutlet UIView *numberBkView;

@end

@implementation ClasslistModelCell

+(instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString *cellid = @"classlistModelCell";
    ClasslistModelCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ClasslistModelCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(void)awakeFromNib
{
    self.containerView.layer.cornerRadius = 8;
    self.numberBkView.layer.cornerRadius = 8;
}

-(void)setModelWith:(ClasslistModel *)model
{
    self.numberLb.text = [NSString stringWithFormat:@"有%@人次参与",model.count?:@"0"];
    
    NSURL *url = [NSURL URLWithString:model.c_itemurl];
    
    [self.bkImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    
    [self getCellHeight];
}

-(CGFloat)getCellHeight
{
    self.width = MTScreenW;
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
    CGFloat height = CGRectGetMaxY(self.containerView.frame) + 15;
    self.height = height;
    return height;
}

@end
