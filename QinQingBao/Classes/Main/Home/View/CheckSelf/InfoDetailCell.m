//
//  DiseaseDetailCell.m
//  QinQingBao
//
//  Created by shi on 16/1/23.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#define  kMarginToLeft 25
#define  kMarginToRight 25

#import "InfoDetailCell.h"

@interface InfoDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *conttenLb;        //InfoDetailCell内容Label

@end

@implementation InfoDetailCell

- (void)awakeFromNib {
    // Initialization code
}

-(InfoDetailCell *)initInfoDetailWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)idx
{
    static NSString *infoDetailCellId = @"infoDetailCell";
    InfoDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:infoDetailCellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"InfoDetailCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

/**
 *  重写 setter 方法，根据contentStr设置内容
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
    
    //设置cell 内容
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
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 10;
    
    NSDictionary *attributeDict = @{
                                    NSParagraphStyleAttributeName:paragraph,
                                    NSFontAttributeName: [UIFont systemFontOfSize:15],
                                    NSForegroundColorAttributeName:[UIColor darkGrayColor]
                                    };
    
    NSAttributedString *attributedStr = [[NSAttributedString alloc] initWithString:string
                                                                        attributes:attributeDict];
    
    return attributedStr;
}

@end
