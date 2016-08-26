//
//  CommonPlanCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/6/21.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CommonPlanCell.h"
#import "CommonPlanModel.h"

@interface CommonPlanCell ()

@property (strong, nonatomic) IBOutlet UIView *bgview;
@property (strong, nonatomic) IBOutlet UIImageView *headImg;
@property (strong, nonatomic) IBOutlet UILabel *priceLab;
@property (strong, nonatomic) IBOutlet UILabel *markPrice;
@property (strong, nonatomic) IBOutlet UILabel *sellnumLab;

@end

@implementation CommonPlanCell


+ (CommonPlanCell*) commonPlanCell
{
    CommonPlanCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"CommonPlanCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.bgview.layer.cornerRadius = 8;
    return cell;
}

-(void)setItem:(CommonPlanModel *)item
{
    _item = item;
    
    self.priceLab.text = item.wname;
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date =[dateFormat dateFromString:item.wtime];
    NSDateFormatter* dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"yyyy-MM-dd"];
    
    self.markPrice.text  = [dateFormat1 stringFromDate:date];
    
    //头像
    NSURL *iconUrl = [NSURL URLWithString:self.item.item_url_big];
    [self.headImg sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholder_serviceMarket"]];

    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, MTScreenW - 20, 115) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.headImg.bounds;
    maskLayer.path = maskPath.CGPath;
    self.headImg.layer.mask = maskLayer;
}

@end
