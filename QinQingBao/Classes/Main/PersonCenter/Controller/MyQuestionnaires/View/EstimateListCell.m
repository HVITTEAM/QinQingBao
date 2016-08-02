//
//  EstimateListCell.m
//  QinQingBao
//
//  Created by shi on 16/7/27.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "EstimateListCell.h"
#import "ReportListModel.h"

@interface EstimateListCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLb;

@property (weak, nonatomic) IBOutlet UILabel *timeLb;

@property (weak, nonatomic) IBOutlet UILabel *resultLb;

@end

@implementation EstimateListCell

+(instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString *cellid = @"estimateListCell";
    EstimateListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EstimateListCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLb.text = nil;
    self.timeLb.text = nil;
    self.resultLb.text = nil;
}


-(void)setItem:(ReportListModel *)item
{
    self.nameLb.text = item.r_etitle;
    self.timeLb.text = [MTDateHelper getDaySince1970:item.r_createtime dateformat:@"yyyy-MM-dd hh:mm"];
    self.resultLb.text = item.r_danger;
}

@end
