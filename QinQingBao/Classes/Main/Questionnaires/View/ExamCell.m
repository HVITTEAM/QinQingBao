//
//  ExamCell.m
//  QinQingBao
//
//  Created by shi on 16/8/11.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ExamCell.h"
#import "ExamModel.h"

@interface ExamCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIImageView *bkImageView;

@property (weak, nonatomic) IBOutlet UILabel *numberLb;

@property (weak, nonatomic) IBOutlet UIView *numberBkView;

@end

@implementation ExamCell

+(instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString *cellid = @"examCell";
    ExamCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ExamCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(void)awakeFromNib
{
    self.containerView.layer.cornerRadius = 8;
    self.numberBkView.layer.cornerRadius = 8;
    self.numberLb.text = nil;
}

-(void)setModelWith:(ExamModel *)model
{
    self.numberLb.text = [NSString stringWithFormat:@"有%@人次参与",model.count?:@"0"];
    
    NSURL *url = [NSURL URLWithString:model.e_itemurl];
    
    [self.bkImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"advplaceholderImage"]];
}

@end
