//
//  CommonMarketCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/6/21.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CommonExamCell.h"
#import "ExamModel.h"

@interface CommonExamCell ()

@property (strong, nonatomic) IBOutlet UIView *bgview;
@property (strong, nonatomic) IBOutlet UIImageView *markImg;
@property (strong, nonatomic) IBOutlet UIImageView *headImg;
@property (strong, nonatomic) IBOutlet UILabel *sellnumLab;

@end

@implementation CommonExamCell


+ (CommonExamCell*) commonExamCell
{
    CommonExamCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"CommonExamCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.bgview.layer.cornerRadius = 8;
    return cell;
}

-(void)setItem:(ExamModel *)item
{
    _item = item;
    
    NSString *string                            =  [NSString stringWithFormat:@"有%@人参与",self.item.count];
    
    //已售单数
    self.sellnumLab.text = string;
    
    //头像
    NSURL *iconUrl = [NSURL URLWithString:self.item.e_itemurl];
    [self.headImg sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholder_serviceMarket"]];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, MTScreenW - 20, 115) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.headImg.bounds;
    maskLayer.path = maskPath.CGPath;
    self.headImg.layer.mask = maskLayer;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
