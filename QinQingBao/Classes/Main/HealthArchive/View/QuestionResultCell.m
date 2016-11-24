//
//  QuestionResultCell.m
//  QinQingBao
//
//  Created by shi on 2016/11/7.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "QuestionResultCell.h"

@interface QuestionResultCell ()

@property (strong, nonatomic) UILabel *resultLb;

@property (strong, nonatomic) UILabel *detailLb;

@end

@implementation QuestionResultCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"questionResultCell";
    QuestionResultCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[QuestionResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.resultLb = [[UILabel alloc] init];
        self.resultLb.textColor = [UIColor colorWithRGB:@"fbb03b"];
        self.resultLb.font = [UIFont systemFontOfSize:21];
        self.resultLb.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.resultLb];
        
        self.detailLb = [[UILabel alloc] init];
        self.detailLb.textColor = [UIColor blackColor];
        self.detailLb.font = [UIFont systemFontOfSize:14];
        self.detailLb.numberOfLines = 0;
        [self.contentView addSubview:self.detailLb];
    }
    
    return self;
}

- (void)setItem:(ResultModel *)item
{
    self.resultLb.text = item.r_dangercoefficient;
    NSString *detailContent = item.r_result.hmd_advise;
    if (detailContent) {
        
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 5;
        NSDictionary *dict = @{
                               NSForegroundColorAttributeName:self.detailLb.textColor,
                               NSFontAttributeName:self.detailLb.font,
                               NSParagraphStyleAttributeName:paragraph
                               };
        
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:detailContent attributes:dict];
        self.detailLb.attributedText = attStr;
        
       CGSize size = [detailContent boundingRectWithSize:CGSizeMake(MTScreenW - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
       self.detailLb.frame = CGRectMake(0, 0, size.width, size.height);
    }
    
    [self.resultLb sizeToFit];
    self.resultLb.frame = CGRectMake(0, 18, MTScreenW, self.resultLb.height);

    self.detailLb.frame = CGRectMake(15, CGRectGetMaxY(self.resultLb.frame) + 15, self.detailLb.width, self.detailLb.height);
    
    CGFloat h = CGRectGetMaxY(self.detailLb.frame) + 18;
    
    if (detailContent.length == 0) {
        h = CGRectGetMinY(self.detailLb.frame);
    }
    
    self.height = h;
}

@end
