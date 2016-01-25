//
//  FoodCell.m
//  QinQingBao
//
//  Created by shi on 16/1/22.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#define  kMarginToLeft 25
#define  kMarginToRight 25

#import "FoodCell.h"

@interface FoodCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLb;         //标题Label(宜吃食物或忌吃食物)

@property (weak, nonatomic) IBOutlet UILabel *contentLb;       //具体内容Label(宜吃食物或忌吃食物具体内容)

@end

@implementation FoodCell

- (void)awakeFromNib {
    // Initialization code
}

-(FoodCell *)initFoodCellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)idx
{
    static NSString *foodCellId = @"foodCell";
    FoodCell *cell = [tableView dequeueReusableCellWithIdentifier:foodCellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FoodCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(void)setupCell
{
    //标题Label赋值
    self.titleLb.text = self.titleStr;
    
    if (!self.contentStr) {
        return;
    }
    //创建一个属性字符串
    //行距为10，字体为15，颜色为darkGrayColor
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 10;
    
    NSDictionary *attributeDict = @{
                                    NSParagraphStyleAttributeName:paragraph,
                                    NSFontAttributeName: [UIFont systemFontOfSize:15],
                                    NSForegroundColorAttributeName:[UIColor darkGrayColor]
                                    };
    
    NSAttributedString *attributedStr = [[NSAttributedString alloc] initWithString:self.contentStr
                                                                        attributes:attributeDict];
    //具体内容Label赋值
    self.contentLb.attributedText = attributedStr;
}

-(CGFloat)getCellHeightWithTableView:(UITableView *)tableView
{
    //设置preferredMaxLayoutWidth，计算 Label 文本高度时需要
    self.contentLb.preferredMaxLayoutWidth = tableView.frame.size.width - kMarginToRight - kMarginToLeft;
    
    //设置 cell 内容
    [self setupCell];
    
    //计算高度
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
    CGFloat cellHeight = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    
    return  cellHeight;
}

@end
