//
//  RepotDetailCell.m
//  QinQingBao/Users/dongxuwei/Desktop/workSpace/QQB/QinQingBao/Classes/Main/HealthPlan/View/RepotDetailCell.m
//
//  Created by 董徐维 on 2017/1/5.
//  Copyright © 2017年 董徐维. All rights reserved.
//

#import "RepotDetailCell.h"

@interface RepotDetailCell()
@property (weak, nonatomic) IBOutlet UIButton *desbtn;

@property (weak, nonatomic) IBOutlet UILabel *scorelab;

@property (strong, nonatomic) UILabel *titleLab;

@property (strong, nonatomic) UILabel *subtitleLab;

@end

@implementation RepotDetailCell

+ (RepotDetailCell*) repotDetailCell
{
    RepotDetailCell * repotDetailCell = [[[NSBundle mainBundle] loadNibNamed:@"RepotDetailCell" owner:self options:nil] objectAtIndex:0];
    repotDetailCell.selectionStyle = UITableViewCellSelectionStyleNone;
    repotDetailCell.height = 47;
    return repotDetailCell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.txtView.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (UILabel *)titleLab
{
    if (_titleLab == nil) {
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 200, 23)];
        self.titleLab.font = [UIFont systemFontOfSize:14];
        self.titleLab.textColor = [UIColor blackColor];
        [self addSubview:self.titleLab];
    }
    return _titleLab;
}

- (UILabel *)subtitleLab
{
    if (_subtitleLab == nil) {
        self.subtitleLab =  [[UILabel alloc] initWithFrame:CGRectMake(15, 22, 200, 23)];
        self.subtitleLab.font = [UIFont systemFontOfSize:10];
        self.subtitleLab.textColor = [UIColor colorWithRGB:@"999999"];
        [self addSubview:self.subtitleLab];
    }
    return _subtitleLab;
}

-(void)setDataItem:(GenesModel *)dataItem
{
    _dataItem = dataItem;
    
    self.titleLab.text = self.dataItem.ycjd_name;
    
    if (self.dataItem.unit && ![self.dataItem.unit isEqualToString:@"null"])
        self.subtitleLab.text = [NSString stringWithFormat:@"%@  (%@)",self.dataItem.entry_name_en,self.dataItem.unit];
    else
        self.subtitleLab.text = self.dataItem.entry_name_en;
    
    [_desbtn setTitle:self.dataItem.ycjd_level forState:UIControlStateNormal];
    _desbtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [_desbtn setBackgroundImage:[self imageWithStr:self.dataItem.ycjd_level] forState:UIControlStateNormal];
    [_desbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    _scorelab.font = [UIFont systemFontOfSize:21];
    _scorelab.textColor = [UIColor blackColor];
    _scorelab.text = self.dataItem.ycjd_score;
}

-(void)setParagraphValue:(NSString *)paragraphValue
{
    _paragraphValue = paragraphValue;
    
    self.txtView.text = _paragraphValue;
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 7;
    
    NSDictionary *attrDict = @{ NSParagraphStyleAttributeName:paragraph,
                                NSForegroundColorAttributeName:[UIColor colorWithRGB:@"666666"],
                                NSFontAttributeName:[UIFont systemFontOfSize:14] };
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"说明:%@",_paragraphValue] attributes:attrDict];
    self.txtView.attributedText = attrString;
    
    CGSize size = [self.txtView sizeThatFits:CGSizeMake(MTScreenW - 30, MAXFLOAT)];
    self.txtView.height = size.height;
    self.height = CGRectGetMaxY(self.txtView.frame) + 8;
}

- (void)setFrame:(CGRect)frame
{
    static CGFloat margin = 10;
    frame.origin.x = margin;
    frame.size.width -= 2 * frame.origin.x;
    [super setFrame:frame];
}

-(void)setBorderType:(MTCellBorderType)borderType
{
    _borderType = borderType;
    switch (borderType)
    {
        case MTCellBorderTypeTOP:
        {
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, MTScreenW - 20, self.height) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(6, 6)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = self.bounds;
            maskLayer.path = maskPath.CGPath;
            self.layer.mask = maskLayer;
        }
            break;
        case MTCellBorderTypeBottom:
        {
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, MTScreenW - 20, self.height) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(6, 6)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = self.bounds;
            maskLayer.path = maskPath.CGPath;
            self.layer.mask = maskLayer;
            
        }
            break;
        case MTCellBorderTypeTOPAll:
        {
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, MTScreenW - 20, self.height) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight|UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(6, 6)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = self.bounds;
            maskLayer.path = maskPath.CGPath;
            self.layer.mask = maskLayer;
        }
            break;
        case MTCellBorderTypeTOPNone:
        {
            
        }
            break;
        default:
            break;
    }
}

-(UIImage *)imageWithStr:(NSString *)str
{
    if ([str isEqualToString:@"正常"]) {
        return [UIImage imageNamed:@"warning-1"];
    }
    else if ([str isEqualToString:@"临界"]) {
        return [UIImage imageNamed:@"warning-2"];
    }
    else if ([str isEqualToString:@"中危"]) {
        return [UIImage imageNamed:@"warning-3"];
    }
    else if ([str isEqualToString:@"高危"]) {
        return [UIImage imageNamed:@"warning-4"];
    }
    else if ([str isEqualToString:@"极高危"]) {
        return [UIImage imageNamed:@"warning-5"];
    }
    else
        return [UIImage imageNamed:@"warning-1"];
}
@end
