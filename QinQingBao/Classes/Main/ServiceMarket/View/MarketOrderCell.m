//
//  MarketOrderCell.m
//  QinQingBao
//
//  Created by shi on 16/6/21.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "MarketOrderCell.h"
#import "ChattingViewController.h"

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

    self.subTitleLb.text = [NSString stringWithFormat:@"%@ 元/位",dataItem.promotion_price ? dataItem.promotion_price : dataItem.price_mem];
    
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Img,dataItem.item_url]];
    [self.cellImageView sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderDetail"]];
}

- (IBAction)leftBtnClickAction:(id)sender
{
    if (![SharedAppUtil checkLoginStates])
        return;
    ChattingViewController *vx = [[ChattingViewController alloc] initWithConversationChatter:@"qqb4151" conversationType:eConversationTypeChat];
    vx.hidesBottomBarWhenPushed = YES;
    UITabBarController *nav = (UITabBarController *)self.window.rootViewController;
    [nav.viewControllers[0].navigationController pushViewController:vx animated:YES];
}

- (IBAction)rightBtnClickAction:(id)sender
{
    NSURL *url  = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",ShopTel1]];
    [[UIApplication sharedApplication] openURL:url];
}

@end
