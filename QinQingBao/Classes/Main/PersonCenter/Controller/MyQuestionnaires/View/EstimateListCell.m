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

@property (strong, nonatomic) IBOutlet UIImageView *levelImg;

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
    self.resultLb.text = item.r_hmtitle;
   
    if ([item.r_danger isEqualToString:@"健康达人"])
    {
        self.levelImg.image = [UIImage imageNamed:@"level_1.png"];
    }
    else if ([item.r_danger isEqualToString:@"蓝色预警"])
    {
        self.levelImg.image = [UIImage imageNamed:@"level_2.png"];
    }
    else if ([item.r_danger isEqualToString:@"黄色语境"])
    {
        self.levelImg.image = [UIImage imageNamed:@"level_3.png"];
    }
    else if ([item.r_danger isEqualToString:@"橙色预警"])
    {
        self.levelImg.image = [UIImage imageNamed:@"level_4.png"];
    }
    else if ([item.r_danger isEqualToString:@"极低危"])
    {
        self.levelImg.image = [UIImage imageNamed:@"level_5.png"];
    }
    else if ([item.r_danger isEqualToString:@"低危"])
    {
        self.levelImg.image = [UIImage imageNamed:@"level_6.png"];
    }
    else if ([item.r_danger isEqualToString:@"中危"])
    {
        self.levelImg.image = [UIImage imageNamed:@"level_7.png"];
    }
    else if ([item.r_danger isEqualToString:@"高危"])
    {
        self.levelImg.image = [UIImage imageNamed:@"level_8.png"];
    }
    else if ([item.r_danger isEqualToString:@"极高危"])
    {
        self.levelImg.image = [UIImage imageNamed:@"level_9.png"];
    }
}

@end
