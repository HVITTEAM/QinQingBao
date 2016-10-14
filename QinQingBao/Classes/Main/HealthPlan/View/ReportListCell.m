//
//  ReportListCell.m
//  QinQingBao
//
//  Created by shi on 2016/10/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ReportListCell.h"

@interface ReportListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLb;

@end

@implementation ReportListCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString *reportListCellId = @"reportListCell";
    ReportListCell *cell = [tableView dequeueReusableCellWithIdentifier:reportListCellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ReportListCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}



@end
