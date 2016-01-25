//
//  SectionHeaderView.m
//  QinQingBao
//
//  Created by shi on 16/1/22.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#define kMarginToSupper 25
#define kMarginToBrother 20
#define kIconWidth 20

#import "SectionHeaderView.h"

@interface SectionHeaderView ()

@property(strong,nonatomic)UIImageView *iconView;         //图标

@property(strong,nonatomic)UILabel *titleLb;              //Section标题

@end

@implementation SectionHeaderView

+(SectionHeaderView *)createSectionHeaderWithSectionName:(NSString *)name iconName:(NSString*)iconName
{
    SectionHeaderView *headerView = [[SectionHeaderView alloc] init];
    headerView.backgroundColor = HMGlobalBg;
    
    //标题UILabel
    UILabel *tempTitleView = [[UILabel alloc] init];
    tempTitleView.font = [UIFont boldSystemFontOfSize:17];
    tempTitleView.textAlignment = NSTextAlignmentLeft;
    tempTitleView.textColor = UIColorFromRGB(333333, 1.0);
    tempTitleView.text = name;
    headerView.titleLb = tempTitleView;
    [headerView addSubview:tempTitleView];
    
    //图标
    UIImageView *tempImgView = [[UIImageView alloc] init];
    tempImgView.image = [UIImage imageNamed:iconName];
    headerView.iconView = tempImgView;
    [headerView addSubview:tempImgView];
    
    return headerView;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.iconView.frame = CGRectMake(kMarginToSupper, (self.height - kIconWidth)/2, kIconWidth, kIconWidth);
    
    [self.titleLb sizeToFit];
    
    self.titleLb.frame = CGRectMake(CGRectGetMidX(self.iconView.frame) + kMarginToBrother, (self.height - self.titleLb.height)/2, self.titleLb.width, self.titleLb.height);
}

@end
