//
//  GeneDetectionCell.m
//  QinQingBao
//
//  Created by 董徐维 on 2017/1/8.
//  Copyright © 2017年 董徐维. All rights reserved.
//

#import "GeneDetectionCell.h"

@interface GeneDetectionCell ()
@property (weak, nonatomic) IBOutlet UIView *content;
@property (weak, nonatomic) IBOutlet UILabel *titlelab;
@property (weak, nonatomic) IBOutlet UILabel *subLab;
@property (weak, nonatomic) IBOutlet UILabel *headLab;
@property (weak, nonatomic) IBOutlet UITextView *textview;

@end

@implementation GeneDetectionCell


+ (GeneDetectionCell*) geneDetectionCell
{
    GeneDetectionCell * geneDetectionCell = [[[NSBundle mainBundle] loadNibNamed:@"GeneDetectionCell" owner:self options:nil] objectAtIndex:0];
    geneDetectionCell.selectionStyle = UITableViewCellSelectionStyleNone;
    geneDetectionCell.backgroundColor = [UIColor clearColor];
    return geneDetectionCell;
}

-(void)setDataItem:(GenesModel *)dataItem
{
    _dataItem = dataItem;
    self.titlelab.text =  dataItem.ycjd_name;
    self.subLab.text =  dataItem.ycjd_score;
    
    NSString *string                            = [NSString stringWithFormat:@"%@ 基因型",dataItem.ycjd_level];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    // 设置富文本样式
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor blackColor]
                             range:NSMakeRange(0, dataItem.ycjd_level.length)];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont boldSystemFontOfSize:21.f]
                             range:NSMakeRange(0, dataItem.ycjd_level.length)];
    
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor colorWithRGB:@"666666"]
                             range:NSMakeRange(dataItem.ycjd_level.length,4)];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:12.f]
                             range:NSMakeRange(dataItem.ycjd_level.length,4)];
    
    self.headLab.attributedText =  attributedString;
}

-(void)setParagraphValue:(NSString *)paragraphValue
{
    _paragraphValue = paragraphValue;
    
    self.textview.userInteractionEnabled = NO;
    self.textview.text = [NSString stringWithFormat:@"说明:%@",_paragraphValue];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 7;
    
    NSDictionary *attrDict = @{ NSParagraphStyleAttributeName:paragraph,
                                NSForegroundColorAttributeName:[UIColor colorWithRGB:@"666666"],
                                NSFontAttributeName:[UIFont systemFontOfSize:14] };
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"说明:%@",_paragraphValue] attributes:attrDict];
    self.textview.attributedText = attrString;
    
    CGSize size = [self.textview sizeThatFits:CGSizeMake(MTScreenW - 20, MAXFLOAT)];
    self.textview.height = size.height;
    self.height = CGRectGetMaxY(self.textview.frame) + 30;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.content.layer.borderColor = [UIColor colorWithRGB:@"dbdbdb"].CGColor;
    self.content.layer.borderWidth = 0.5f;
    self.content.layer.cornerRadius = 6;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
