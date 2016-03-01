//
//  RefundContentCell.m
//  QinQingBao
//
//  Created by shi on 16/2/25.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "RefundContentCell.h"

@interface RefundContentCell ()
{
    UILabel *_contentLb;
    UILabel *_titleLb;
}

@property(assign,nonatomic)CGFloat cellHeight;

@end

@implementation RefundContentCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _contentLb = [[UILabel alloc] init];
        _contentLb.numberOfLines = 0;
        [self.contentView addSubview:_contentLb];
        
        _titleLb = [[UILabel alloc] init];
        _titleLb.textColor = [UIColor darkGrayColor];
        _titleLb.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleLb];
    }
    return self;
}

-(void)setupCell
{

    _titleLb.text = self.titleStr;
    [_titleLb sizeToFit];
    _titleLb.frame = CGRectMake(20, 10, _titleLb.frame.size.width, _titleLb.frame.size.height);

    if (self.contentStr == nil) {
        return;
    }
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 5;
    NSDictionary *attrDict = @{
                               NSFontAttributeName:[UIFont systemFontOfSize:15],
                               NSForegroundColorAttributeName:[UIColor darkGrayColor],
                               NSParagraphStyleAttributeName:paragraph
                               };
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self.contentStr attributes:attrDict];
    _contentLb.attributedText = attrString;
    
    CGSize sizeTemp = CGSizeMake(MTScreenW - _titleLb.frame.size.width - 15 -10 - 10, MAXFLOAT);
    CGSize contentSize = [attrString boundingRectWithSize:sizeTemp options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    _contentLb.frame = CGRectMake(CGRectGetMaxX(_titleLb.frame) + 15, 10, contentSize.width, contentSize.height);
    self.cellHeight = 10 + contentSize.height + 10;
}


@end
