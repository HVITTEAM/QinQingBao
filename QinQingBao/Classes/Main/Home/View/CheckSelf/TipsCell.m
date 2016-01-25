//
//  TipsCell.m
//  QinQingBao
//
//  Created by shi on 16/1/23.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#define  kMarginToLeft 25
#define  kMarginToRight 25

#import "TipsCell.h"

@interface TipsCell ()

@property (weak, nonatomic) IBOutlet UILabel *conttenLb;        //cell 内容 Label(提示内容)

@end

@implementation TipsCell

- (void)awakeFromNib {
    // Initialization code
}

-(TipsCell *)initTipsCellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)idx
{
    static NSString *tipsCellId = @"tipsCell";
    TipsCell *cell = [tableView dequeueReusableCellWithIdentifier:tipsCellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TipsCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

/**
 *  重写 setter 方法，根据contentStr设置cell 的内容
 */
-(void)setContentStr:(NSString *)contentStr
{
    _contentStr = contentStr;
    
    self.conttenLb.attributedText = [self createAttributedStringWithString:contentStr];
}

-(CGFloat)getCellHeightWithContent:(NSString *)contentStr tableView:(UITableView *)tableView
{
    //设置preferredMaxLayoutWidth，计算 Label 文本高度时需要
    self.conttenLb.preferredMaxLayoutWidth = tableView.frame.size.width - kMarginToLeft - kMarginToRight;
    
    //设置 cell 内容
    self.conttenLb.attributedText = [self createAttributedStringWithString:contentStr];
    
    //计算高度
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
    CGFloat cellHeight = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    
    return  cellHeight;
}

/**
 *  创建一个属性字符串
 */
-(NSAttributedString *)createAttributedStringWithString:(NSString *)string
{
    if (!string) {
        return nil;
    }
    
    //行距为10，字体为15，颜色为darkGrayColor
//    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
//    paragraph.lineSpacing = 1;
    
    NSDictionary *attributeDict = @{
                                    //NSParagraphStyleAttributeName:paragraph,
                                    NSFontAttributeName: [UIFont systemFontOfSize:15],
                                    NSForegroundColorAttributeName:[UIColor darkGrayColor]
                                    };
    
    NSAttributedString *attributedStr = [[NSAttributedString alloc] initWithString:string
                                                                        attributes:attributeDict];
    
    return attributedStr;
}



@end
