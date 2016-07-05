//
//  ReportInfoCell.m
//  QinQingBao
//
//  Created by shi on 16/7/4.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ReportInfoCell.h"
#import "WorkReportModel.h"

@interface ReportInfoCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation ReportInfoCell

+(instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"reportInfoCell";
    ReportInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ReportInfoCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLb.text = nil;
    self.imgView.image = nil;
    self.contentLb.text = nil;
    
    self.containerView.layer.cornerRadius = 7.0f;
    self.containerView.layer.borderColor = HMColor(230, 230, 230).CGColor;
    self.containerView.layer.borderWidth = 1.0f;

}

-(void)computeCellHeight
{
    self.contentLb.preferredMaxLayoutWidth = MTScreenW - 40;
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
    
    CGFloat cellHeight = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    self.height = cellHeight;
}


@end
