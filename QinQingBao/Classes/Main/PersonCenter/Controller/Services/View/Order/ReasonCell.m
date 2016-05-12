//
//  ReasonCell.m
//  QinQingBao
//
//  Created by shi on 16/4/1.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ReasonCell.h"
#define kMarginHoriz 22
#define kMarginVert 10

@interface ReasonCell ()

@property(assign,nonatomic)CGFloat cellHeight;

@property(strong,nonatomic)UILabel *contentLb;

@end

@implementation ReasonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)createReasonCellWithTableView:(UITableView *)tableview
{
    static NSString *reasonCellId = @"reasonCell";
    ReasonCell *cell = [tableview dequeueReusableCellWithIdentifier:reasonCellId];
    if (!cell) {
        cell = [[ReasonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reasonCellId];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentLb = [[UILabel alloc] init];
        self.contentLb.font = [UIFont systemFontOfSize:14];
        self.contentLb.textColor = [UIColor darkGrayColor];
        self.contentLb.numberOfLines = 0;
        [self.contentView addSubview:self.contentLb];
    }
    return self;
}

-(void)setContent:(NSString *)content
{
    _content = content;
    self.contentLb.text = content;
    CGSize size = [self.contentLb sizeThatFits:CGSizeMake(MTScreenW - 2 * kMarginHoriz, MAXFLOAT)];
    self.contentLb.frame = CGRectMake(kMarginHoriz, kMarginVert,MTScreenW - 2 * kMarginHoriz, size.height);
    
    if (size.height == 0) {
        self.cellHeight = 0;
    }else{
      self.cellHeight = 2 * kMarginVert + size.height;
    }
}

@end
