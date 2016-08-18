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
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;
@property (strong, nonatomic) IBOutlet UILabel *contentLab;
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
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date =[dateFormat dateFromString:item.wp_create_time];
    NSDateFormatter* dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"yyyy-MM-dd"];
    self.timeLab.text = [dateFormat1 stringFromDate:date];
    
    self.contentLab.text = item.wp_general_analysis;
    CGSize size = [self.contentLab sizeThatFits:CGSizeMake(MTScreenW - 20, MAXFLOAT)];
    self.contentLab.height = size.height;
    
    self.height = CGRectGetMaxY(self.contentLab.frame) + 50;
}


@end
