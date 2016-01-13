//
//  GoodsTitleCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "GoodsTitleCell.h"
#import "GoodsInfoModel.h"

@implementation GoodsTitleCell


+(GoodsTitleCell *)goodsTitleCell
{
    GoodsTitleCell * cell = [[self alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - setter
- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(int)rows
{
    // 1.取出背景view
    UIImageView *bgView = (UIImageView *)self.backgroundView;
    UIImageView *selectedBgView = (UIImageView *)self.selectedBackgroundView;
    
    // 2.设置背景图片
    if (rows == 1) {
        bgView.image = [UIImage resizedImage:@"common_card_background"];
        selectedBgView.image = [UIImage resizedImage:@"common_card_background_highlighted"];
    } else if (indexPath.row == 0) { // 首行
        bgView.image = [UIImage resizedImage:@"common_card_top_background"];
        selectedBgView.image = [UIImage resizedImage:@"common_card_top_background_highlighted"];
    } else if (indexPath.row == rows - 1) { // 末行
        bgView.image = [UIImage resizedImage:@"common_card_bottom_background"];
        selectedBgView.image = [UIImage resizedImage:@"common_card_bottom_background_highlighted"];
    } else { // 中间
        bgView.image = [UIImage resizedImage:@"common_card_middle_background"];
        selectedBgView.image = [UIImage resizedImage:@"common_card_middle_background_highlighted"];
    }
}

- (void)setItem:(GoodsInfoModel *)goodsInfo
{
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MTScreenW, 0.5)];
    line.backgroundColor=[UIColor colorWithRGB:@"e2e2e2"];
    [self addSubview:line];
    
    self.textLabel.textColor = [UIColor colorWithRGB:@"333333"];
    self.textLabel.text = goodsInfo.goods_name;
    self.textLabel.numberOfLines = 0;
    self.textLabel.font = [UIFont systemFontOfSize:16];
    self.textLabel.y = 5;
    CGRect tmpRect = [self.textLabel.text boundingRectWithSize:CGSizeMake(MTScreenW - 20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.textLabel.font,NSFontAttributeName, nil] context:nil];
    self.textLabel.height = tmpRect.size.height;
   
    self.height = CGRectGetMaxY(self.textLabel.frame) + 10;
    
//    UIImageView *rightView = [[UIImageView alloc]initWithFrame:CGRectMake(MTScreenW - 34, self.height/2 - 12, 24, 24)];
//    rightView.image = [UIImage imageNamed:@"common_icon_arrow"];
//    [self addSubview:line];
    
}


@end
