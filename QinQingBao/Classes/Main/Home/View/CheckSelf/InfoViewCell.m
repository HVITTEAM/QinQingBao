//
//  InfoViewCell.m
//  QinQingBao
//
//  Created by shi on 16/1/22.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#define  kMarginToLeft 25
#define  kMarginToRight 35
#define  kdefaultCellHeight 180

#import "InfoViewCell.h"

@interface InfoViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *conttenLb;          //症状内容 Label

@property(strong,nonatomic)NSString *contentStr;                  //症状内容

@end

@implementation InfoViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(InfoViewCell *)initInfoViewCellWithContent:(NSString *)content tableView:(UITableView *)tableView indexpath:(NSIndexPath *)idx
{
    static NSString *infoViewCellId = @"infoViewCell";
    InfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:infoViewCellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"InfoViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.contentStr = content;
    
    return cell;
}

/**
 *  重写 setter 方法，根据contentStr设置cell内容
 */
-(void)setContentStr:(NSString *)contentStr
{
    _contentStr = contentStr;
    
    self.conttenLb.attributedText = [self createAttributedStringWithString:contentStr];
}

-(CGFloat)getCellHeightWithContent:(NSString *)contentStr tableView:(UITableView *)tableView
{
    //设置preferredMaxLayoutWidth，计算文本高度时用
    self.conttenLb.preferredMaxLayoutWidth = tableView.frame.size.width - kMarginToLeft - kMarginToRight;
    
    //设置文本
    self.conttenLb.attributedText = [self createAttributedStringWithString:contentStr];
    
    //获取高度
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
    CGFloat cellHeight = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    
    //文本内容高度超过默认高度就使用默认高度
    return  cellHeight > kdefaultCellHeight ? kdefaultCellHeight:cellHeight;
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
