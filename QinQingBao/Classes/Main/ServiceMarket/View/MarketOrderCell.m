//
//  MarketOrderCell.m
//  QinQingBao
//
//  Created by shi on 16/6/21.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "MarketOrderCell.h"

@interface MarketOrderCell ()

@end

@implementation MarketOrderCell

+(instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"marketOrderCell";
    MarketOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MarketOrderCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLb.text = nil;
    self.subTitleLb.text = nil;
}

-(void)setItem:(MassageModel *)dataItem
{
    self.titleLb.text = dataItem.iname;
    self.subTitleLb.text = [NSString stringWithFormat:@"%@ 元/位",dataItem.price_mem];
    
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Img,dataItem.item_url_big]];
    [self.cellImageView sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderDetail"]];
}

- (IBAction)leftBtnClickAction:(id)sender
{
    //TODO
    [NoticeHelper AlertShow:@"暂未开通此功能" view:nil];
}

- (IBAction)rightBtnClickAction:(id)sender
{
    NSURL *url  = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",ShopTel1]];
    [[UIApplication sharedApplication] openURL:url];
}

@end
