//
//  HistoryViewCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/27.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "HistoryViewCell.h"
CGFloat heightForCell = 28;
@interface HistoryViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation HistoryViewCell

- (void)awakeFromNib
{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 4;
    self.layer.borderColor = [[UIColor colorWithRGB:@"979797"] CGColor];
    self.layer.borderWidth = 1;
}

- (void)setKeyword:(NSString *)keyword {
    _keyword = keyword;
    _titleLabel.text = _keyword;
    [self layoutIfNeeded];
    [self updateConstraintsIfNeeded];
}

- (CGSize)sizeForCell
{
    return CGSizeMake([_titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].width + heightForCell, heightForCell);
}
@end
