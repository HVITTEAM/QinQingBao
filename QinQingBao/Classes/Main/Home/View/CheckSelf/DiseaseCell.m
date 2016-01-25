//
//  DiseaseCell.m
//  QinQingBao
//
//  Created by shi on 16/1/22.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#define  kMarginToLeft 25
#define  kMarginToRight 35
#define kMarginToBrother 10

#import "DiseaseCell.h"
#import "DiseaseModel.h"

@interface DiseaseCell ()

@property (weak, nonatomic) IBOutlet UILabel *diseaseNameLb;          //疾病名字 Label

@property (weak, nonatomic) IBOutlet UILabel *symptomLb;              //症状 Label

@property (weak, nonatomic) IBOutlet UILabel *symptomTitleLb;         //症状标题 Label (“典型症状”)

@property (weak, nonatomic) IBOutlet UILabel *handleLb;               //就诊科室 Label

@end

@implementation DiseaseCell

- (void)awakeFromNib {
    // Initialization code
}

-(DiseaseCell *)initDiseaseCellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)idx
{
    static NSString *diseaseCellId = @"diseaseCell";
    DiseaseCell *cell = [tableView dequeueReusableCellWithIdentifier:diseaseCellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DiseaseCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

/**
 *  重写 setter 方法，根据DiseaseModel设置内容
 */
-(void)setDiseasemodel:(DiseaseModel *)diseasemodel
{
    _diseasemodel = diseasemodel;
    
    self.diseaseNameLb.text = diseasemodel.disease;
    self.symptomLb.attributedText = [self createAttributedStringWithString:diseasemodel.typical_symptom];
    self.handleLb.attributedText = [self createAttributedStringWithString:diseasemodel.handle];
}

-(CGFloat)getCellHeightWithModel:(DiseaseModel *)model tableView:(UITableView *)tableView
{
    //设置cell 内容
    self.diseaseNameLb.text = model.disease;
    self.symptomLb.attributedText = [self createAttributedStringWithString:model.typical_symptom];
    self.handleLb.attributedText = [self createAttributedStringWithString:model.handle];
    
    //计算症状标题Label的宽
    [self.symptomTitleLb sizeToFit];
    CGFloat symptomLbWidth = self.symptomTitleLb.frame.size.width;
    
    //计算preferredMaxLayoutWidth，计算 Label 文本高度时需要
    CGFloat maxLayoutWidth = tableView.frame.size.width - kMarginToRight - kMarginToLeft -symptomLbWidth - kMarginToBrother;
    
    self.symptomLb.preferredMaxLayoutWidth = maxLayoutWidth;
    self.handleLb.preferredMaxLayoutWidth = maxLayoutWidth;
    
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
