//
//  PlanReportTitleCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/8/17.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "PlanReportTitleCell.h"
#import "InterveneModel.h"

@interface PlanReportTitleCell ()
//@property (strong, nonatomic) IBOutlet UILabel *titleLab;
//@property (strong, nonatomic) IBOutlet UILabel *timeLab;
//@property (strong, nonatomic) IBOutlet UILabel *contentLab;
@property (strong, nonatomic) IBOutlet UILabel *tipLab;

@end

@implementation PlanReportTitleCell


+ (PlanReportTitleCell*) planReportTitleCell
{
    PlanReportTitleCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"PlanReportTitleCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)setItem:(InterveneModel *)item
{
    _item = item;
    
//    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *date =[dateFormat dateFromString:item.create_time];
//    NSDateFormatter* dateFormat1 = [[NSDateFormatter alloc] init];
//    [dateFormat1 setDateFormat:@"yyyy-MM-dd"];
//    self.timeLab.text = [dateFormat1 stringFromDate:date];

    self.tipLab.text = [NSString stringWithFormat:@"精准健康管理建议:%@",item.wp_advice_health];
    CGSize size = [self.tipLab sizeThatFits:CGSizeMake(MTScreenW - 40, MAXFLOAT)];
    self.tipLab.height = size.height;
    
    self.height = CGRectGetMaxY(self.tipLab.frame) + 5;
}


@end
