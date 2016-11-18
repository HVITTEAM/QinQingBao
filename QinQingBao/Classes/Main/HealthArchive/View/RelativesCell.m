//
//  RelativesCell.m
//  QinQingBao
//
//  Created by shi on 2016/11/7.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "RelativesCell.h"

@interface RelativesCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconWidthCon;

@end

@implementation RelativesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.imgView.layer.borderColor = [UIColor colorWithRGB:@"f7931e"].CGColor;
    self.imgView.layer.borderWidth = 0.0f;
    self.imgView.layer.masksToBounds = YES;
}

- (void)updateConstraints
{
    self.iconWidthCon.constant = MTScreenW / 320 * 40;
    
    [super updateConstraints];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imgView.layer.cornerRadius = self.imgView.bounds.size.width / 2;
}

- (void)setShowBorderLine:(BOOL)showBorderLine
{
    if (showBorderLine) {
        self.imgView.layer.borderWidth = 2.0f;
    }else{
        self.imgView.layer.borderWidth = 0.0f;
    }
}

@end
