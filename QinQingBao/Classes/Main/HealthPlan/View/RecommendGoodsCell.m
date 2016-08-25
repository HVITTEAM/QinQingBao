//
//  RecommendGoodsCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/8/15.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "RecommendGoodsCell.h"
#import "GoodsInfoModel.h"


@interface RecommendGoodsCell ()
@property (strong, nonatomic) IBOutlet UIImageView *headImg;
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *priceLab;
@property (strong, nonatomic) IBOutlet UILabel *subtitleLab;
@property (strong, nonatomic) IBOutlet UILabel *sunLab;
@property (strong, nonatomic) IBOutlet UIButton *selectedBtn;

@end

@implementation RecommendGoodsCell

- (IBAction)selectedHandler:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    self.goodsItem.selected = btn.selected;
    self.changeClick(sender);
}

+ (RecommendGoodsCell*) recommendGoodsCell
{
    RecommendGoodsCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"RecommendGoodsCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)setGoodsItem:(GoodsInfoModel *)goodsItem
{
    _goodsItem = goodsItem;
    self.selectedBtn.selected = self.goodsItem.selected;
    self.nameLab.text = self.goodsItem.goods_name;
    
    self.subtitleLab.text = [NSString stringWithFormat:@"选项:%@",goodsItem.goods_spec && [goodsItem.goods_spec allValues].count > 0 ? [goodsItem.goods_spec allValues][0] : @"标配"];
    self.priceLab.text = [NSString stringWithFormat:@"￥%@",self.goodsItem.goods_price];
    
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/shop/data/upload/shop/store/goods/%@/%@",URL_Local,goodsItem.store_id,goodsItem.goods_image]];

    [self.headImg sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
}

@end
