//
//  CommonMarketCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/6/21.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CommonMarketCell.h"
#import "MassageModel.h"
#import "TQStarRatingView.h"

@interface CommonMarketCell ()

@property (strong, nonatomic) IBOutlet UIView *bgview;
@property (strong, nonatomic) IBOutlet UIImageView *markImg;
@property (strong, nonatomic) IBOutlet UIImageView *headImg;
@property (strong, nonatomic) IBOutlet UILabel *priceLab;
@property (strong, nonatomic) IBOutlet UILabel *markPrice;
@property (strong, nonatomic) IBOutlet UILabel *sellnumLab;
@property (strong, nonatomic) IBOutlet TQStarRatingView *evaView;

@end

@implementation CommonMarketCell


+ (CommonMarketCell*) commonMarketCell
{
    CommonMarketCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"CommonMarketCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.bgview.layer.cornerRadius = 8;
    return cell;
}

-(void)setItem:(MassageModel *)item
{
    _item = item;
    
    //会员价
    if (self.item.promotion_price)
    {
        self.priceLab.text = [NSString stringWithFormat:@"%@元/位",self.item.promotion_price];
    }
    else  if ([self.item.price_mem_max floatValue] == [self.item.price_mem_min floatValue])
    {
        self.priceLab.text = [NSString stringWithFormat:@"%@元/位",self.item.price_mem_min];
    }
    else
    {
        self.priceLab.text = [NSString stringWithFormat:@"%@-%@元/位",self.item.price_mem_min,self.item.price_mem_max];
    }
    
    //标价
    if ([self.item.price_min floatValue] == [self.item.price_max floatValue])
    {
        NSString *markpriceStr = [NSString stringWithFormat:@"%@元/位",self.item.price_max];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:markpriceStr];
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid |NSUnderlineStyleSingle) range:NSMakeRange(0, markpriceStr.length)];
        [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, markpriceStr.length)];
        self.markPrice.attributedText = attri;
    }
    else
    {
        NSString *markpriceStr = [NSString stringWithFormat:@"%@-%@元/位",self.item.price_min,self.item.price_max];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:markpriceStr];
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid |NSUnderlineStyleSingle) range:NSMakeRange(0, markpriceStr.length)];
        [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, markpriceStr.length)];
        self.markPrice.attributedText = attri;
    }
    
    if (self.item.promotion_price)
    {
        self.markImg.hidden = NO;
        self.markImg.image = [UIImage imageNamed:@"sell.png"];
    }
    else if ([self.item.sell_month floatValue] > 100)
    {
        self.markImg.hidden = NO;
        self.markImg.image = [UIImage imageNamed:@"hot.png"];
    }
    else
    {
        self.markImg.hidden = YES;
    }
    
    
    NSString *string                            =  [NSString stringWithFormat:@"已售%@单",self.item.sell];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    // 设置富文本样式
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor redColor]
                             range:NSMakeRange(2, self.item.sell.length)];
    
    //已售单数
    self.sellnumLab.attributedText = attributedString;
    
    
    //评价星级
    float score = [self.item.wgrade floatValue];
    
    if (score >= 0 && score <= 5)
        [self.evaView setScore:score/5 withAnimation:NO];
    else
        [self.evaView setScore:0 withAnimation:NO];
    
    self.evaView.userInteractionEnabled = NO;
    
    //头像
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Img,self.item.item_url_big]];
    [self.headImg sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderDetail"]];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, MTScreenW - 16, 140) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.headImg.bounds;
    maskLayer.path = maskPath.CGPath;
    self.headImg.layer.mask = maskLayer;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
