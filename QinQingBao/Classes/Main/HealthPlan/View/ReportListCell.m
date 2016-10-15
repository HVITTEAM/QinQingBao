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
@property (strong, nonatomic) IBOutlet UILabel *timelab;
@property (strong, nonatomic) IBOutlet UILabel *sizeLabel;

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

-(void)setItem:(InterveneModel *)item
{
    _item = item;
    
    self.titleLb.text = item.iname;
    self.subTitleLb.text = item.wname;
    self.timelab.text = item.create_time;
    if ([item.filesize integerValue] > 1)
    {
        float size = [item.filesize integerValue]/1024;
        self.sizeLabel.text = [NSString stringWithFormat:@"%.0fkb",size];
    }
    else
        self.sizeLabel.hidden = YES;

//    NSURL *iconUrl = [NSURL URLWithString:item.item_url];
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Img,self.item.item_url]];
    [self.imgView sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
}

@end
