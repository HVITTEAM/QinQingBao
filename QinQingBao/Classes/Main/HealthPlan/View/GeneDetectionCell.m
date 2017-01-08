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
    
}

-(void)setParagraphValue:(NSString *)paragraphValue
{
    _paragraphValue = paragraphValue;
    
    self.textview.userInteractionEnabled = NO;
    self.textview.text = _paragraphValue;
    CGSize size = [self.textview sizeThatFits:CGSizeMake(MTScreenW - 20, MAXFLOAT)];
    self.textview.height = size.height;
    self.height = CGRectGetMaxY(self.textview.frame) + 5;
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
