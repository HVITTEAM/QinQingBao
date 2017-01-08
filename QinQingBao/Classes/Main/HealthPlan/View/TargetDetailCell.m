//
//  TargetDetailCell.m
//  QinQingBao
//
//  Created by 董徐维 on 2017/1/6.
//  Copyright © 2017年 董徐维. All rights reserved.
//

#import "TargetDetailCell.h"

@interface TargetDetailCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *subLab;
@property (weak, nonatomic) IBOutlet UILabel *numlab;
@property (weak, nonatomic) IBOutlet UILabel *rangeLab;

@end

@implementation TargetDetailCell

+ (TargetDetailCell*) targetDetailCell
{
    TargetDetailCell * targetDetailCell = [[[NSBundle mainBundle] loadNibNamed:@"TargetDetailCell" owner:self options:nil] objectAtIndex:0];
    targetDetailCell.selectionStyle = UITableViewCellSelectionStyleNone;
    targetDetailCell.backgroundColor = [UIColor clearColor];
    return targetDetailCell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.content.layer.borderColor = [UIColor colorWithRGB:@"dbdbdb"].CGColor;
    self.content.layer.borderWidth = 0.5f;
    self.content.layer.cornerRadius = 6;
    
}

-(void)setParagraphValue:(NSString *)paragraphValue
{
    _paragraphValue = paragraphValue;
    
    self.descTxtview.userInteractionEnabled = NO;
    self.descTxtview.text = _paragraphValue;
    CGSize size = [self.descTxtview sizeThatFits:CGSizeMake(MTScreenW - 20, MAXFLOAT)];
    self.descTxtview.height = size.height;
    self.height = CGRectGetMaxY(self.descTxtview.frame) + 5;
}

-(void)setDataItem:(GenesModel *)dataItem
{
    _dataItem = dataItem;
    
    self.titleLab.text = self.dataItem.ycjd_name;

    self.subLab.text = self.dataItem.entry_name_en;
    
    self.numlab.text = self.dataItem.ycjd_score;

    self.rangeLab.text = self.dataItem.entry_standardscore;
    
    NSArray *arr = self.dataItem.ea_score_start;
    if (arr.count > 0)
    [self initTargetWithValue:[self.dataItem.ycjd_score floatValue] totalValue:[arr.lastObject floatValue]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

/**
 初始化指标图

 @param value 当前指标
 @param totalValue 总指标
 */
-(void)initTargetWithValue:(CGFloat)value totalValue:(CGFloat)totalValue
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, MTScreenW-30, 6)];
    [self.targetView addSubview:lineView];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRGB:@"11b700"].CGColor, (__bridge id)[UIColor colorWithRGB:@"c7ca00"].CGColor, (__bridge id)[UIColor colorWithRGB:@"ff8d00"].CGColor,(__bridge id)[UIColor colorWithRGB:@"f84e08"].CGColor,(__bridge id)[UIColor colorWithRGB:@"dd0e27"].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(0, 0, MTScreenW - 30, 6);
    gradientLayer.cornerRadius = 3;
    [lineView.layer addSublayer:gradientLayer];
    
    // 每个区间的宽度
    CGFloat xPositionUnit = (gradientLayer.frame.size.width/(self.dataItem.ea_score_start.count-1)) - 5;
    
    // 刻度button的位置
    CGFloat btnX = [self findPositionWithValue:self.dataItem.ycjd_score];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnX *xPositionUnit, 0, 30, 17)];
    [btn setContentEdgeInsets:UIEdgeInsetsMake(-3, 0, 0, 0)];
    [btn setTitle:self.dataItem.ycjd_level forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:10];
    btn.titleLabel.textColor = [UIColor whiteColor];
    [btn setBackgroundImage:[self imageWithStr:self.dataItem.ycjd_level] forState:UIControlStateNormal];
    [self.targetView addSubview:btn];
    
    //刻度值label
    for (NSString *value in self.dataItem.ea_score_start)
    {
        CGFloat xValue = xPositionUnit *[self.dataItem.ea_score_start indexOfObject:value];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(xValue, CGRectGetMaxY(lineView.frame)+3, 30, 20)];
        lab.text = [NSString stringWithFormat:@"%.2f",[value floatValue]];
        lab.textColor = [UIColor colorWithRGB:@"999999"];
        lab.font = [UIFont systemFontOfSize:10];
        [lab sizeToFit];
        [self.targetView addSubview:lab];
    }
}

-(UIImage *)imageWithStr:(NSString *)str
{
    if ([str isEqualToString:@"正常"]) {
        return [UIImage imageNamed:@"value-1"];
    }
    else if ([str isEqualToString:@"临界"]) {
        return [UIImage imageNamed:@"value-2"];
    }
    else if ([str isEqualToString:@"中危"]) {
        return [UIImage imageNamed:@"value-3"];
    }
    else if ([str isEqualToString:@"高危"]) {
        return [UIImage imageNamed:@"value-4"];
    }
    else if ([str isEqualToString:@"极高危"]) {
        return [UIImage imageNamed:@"value-5"];
    }
    else
        return [UIImage imageNamed:@"value-1"];
}

/**
 根据所得得值获取btn该属于第几区间
 @param value 值
 @return 区间
 */
-(CGFloat)findPositionWithValue:(NSString*)value
{
    for (int i = 0; i < self.dataItem.ea_score_start.count - 1;  i ++ )
    {
        if ([value floatValue] == [self.dataItem.ea_score_start[i] floatValue])
        {
            return i;
        }
        else if ([value floatValue] > [self.dataItem.ea_score_start[i] floatValue] &&
                 [value floatValue] < [self.dataItem.ea_score_start[i + 1] floatValue])
        {
            return i + 0.5;
        }
    }
    return 0;
}

@end
