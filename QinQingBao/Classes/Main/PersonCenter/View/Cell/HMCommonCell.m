//
//  HMCommonCell.m
//
//  Created by apple on 14-7-21.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMCommonCell.h"
#import "HMCommonItem.h"
#import "HMCommonArrowItem.h"
#import "HMCommonSwitchItem.h"
#import "HMCommonLabelItem.h"
#import "HMCommonCenterItem.h"
#import "HMBadgeView.h"
#import "UIImage+Extension.h"
#import "UIView+Extension.h"
#import "HMCommonTextfieldItem.h"
#import "HMCommonButtonItem.h"

@interface HMCommonCell()

/**
 *  提醒数字
 */
@property (strong, nonatomic) HMBadgeView *bageView;
@end

@implementation HMCommonCell

#pragma mark - 懒加载右边的view
- (UIImageView *)rightArrow
{
    if (_rightArrow == nil) {
        self.rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"common_icon_arrow"]];
    }
    return _rightArrow;
}

- (UISwitch *)rightSwitch
{
    if (_rightSwitch == nil) {
        self.rightSwitch = [[UISwitch alloc] init];
    }
    return _rightSwitch;
}

- (UILabel *)rightLabel
{
    if (_rightLabel == nil) {
        self.rightLabel = [[UILabel alloc] init];
        self.rightLabel.textColor = [UIColor lightGrayColor];
        self.rightLabel.font = [UIFont systemFontOfSize:13];
    }
    return _rightLabel;
}

- (UITextField *)rightText
{
    if (_rightText == nil) {
        self.rightText = [[UITextField alloc] init];
        self.rightText.textColor = [UIColor lightGrayColor];
        self.rightText.font = [UIFont systemFontOfSize:15];
        self.rightText.secureTextEntry = self.item.secureTextEntry;
        self.rightText.keyboardType = self.item.keyboardType;
        self.item.rightText = _rightText;
    }
    return _rightText;
}

- (UIButton *)rightBtn
{
    if (_item.btn == nil) {
        _item.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _item.btn.width = 80;    _item.btn.height = 30;
        [_item.btn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        [_item.btn setTitleColor:MTNavgationBackgroundColor forState:UIControlStateNormal];
        [_item.btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [_item.btn setTitle:_item.btnTitle forState:UIControlStateNormal];
        [_item.btn.layer setBorderWidth:1];//设置边界的宽度
        [_item.btn.layer setCornerRadius:10.0];//设置矩形四个圆角半径
        [_item.btn.layer setBorderColor:[MTNavgationBackgroundColor CGColor]];
    }
    return _item.btn;
}

- (HMBadgeView *)bageView
{
    if (_bageView == nil) {
        self.bageView = [[HMBadgeView alloc] init];
    }
    return _bageView;
}

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"common";
    HMCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[HMCommonCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 设置标题的字体
        self.textLabel.font = [UIFont boldSystemFontOfSize:14];
        self.detailTextLabel.font = [UIFont systemFontOfSize:11];
        
        // 去除cell的默认背景色
        self.backgroundColor = [UIColor clearColor];
        
        // 设置背景view
        self.backgroundView = [[UIImageView alloc] init];
        self.selectedBackgroundView = [[UIImageView alloc] init];
    }
    return self;
}

#pragma mark - 调整子控件的位置
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //    if ([self.item isKindOfClass:[HMCommonCenterItem class]]) {
    //        self.textLabel.centerX = self.width * 0.5;
    //        self.textLabel.centerY = self.height * 0.5;
    //    } else {
    //        self.textLabel.x = 10;
    // 调整子标题的x
    if (self.item.isSubtitle)
        self.detailTextLabel.x = CGRectGetMaxX(self.textLabel.frame) + 5;
    //    }
}
#pragma mark - setter
- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(int)rows
{
    // 1.取出背景view
    UIImageView *bgView = (UIImageView *)self.backgroundView;
    UIImageView *selectedBgView = (UIImageView *)self.selectedBackgroundView;
    
    // 2.设置背景图片
    if (rows == 1) {
        bgView.image = [UIImage resizedImage:@"common_card_background"];
        selectedBgView.image = [UIImage resizedImage:@"common_card_background_highlighted"];
    } else if (indexPath.row == 0) { // 首行
        bgView.image = [UIImage resizedImage:@"common_card_top_background"];
        selectedBgView.image = [UIImage resizedImage:@"common_card_top_background_highlighted"];
    } else if (indexPath.row == rows - 1) { // 末行
        bgView.image = [UIImage resizedImage:@"common_card_bottom_background"];
        selectedBgView.image = [UIImage resizedImage:@"common_card_bottom_background_highlighted"];
    } else { // 中间
        bgView.image = [UIImage resizedImage:@"common_card_middle_background"];
        selectedBgView.image = [UIImage resizedImage:@"common_card_middle_background_highlighted"];
    }
}

- (void)setItem:(HMCommonItem *)item
{
    _item = item;
    
    // 1.设置基本数据
    if (item.icon.length > 0)
        self.imageView.image = [UIImage imageWithName:item.icon];
    self.textLabel.text = item.title;
    self.detailTextLabel.text = item.subtitle;
    self.imageView.width = self.imageView.height = 24;
    
    self.detailTextLabel.font = [UIFont systemFontOfSize:13];
    
    // 2.设置右边的内容
    if (item.badgeValue) { // 紧急情况：右边有提醒数字
        self.bageView.badgeValue = item.badgeValue;
        self.accessoryView = self.bageView;
    } else if ([item isKindOfClass:[HMCommonArrowItem class]]) {
        self.accessoryView = self.rightArrow;
    } else if ([item isKindOfClass:[HMCommonTextfieldItem class]]) {
        [self.contentView addSubview:self.rightText];
        HMCommonTextfieldItem *hitem = (HMCommonTextfieldItem *)item;
        self.rightText.placeholder = hitem.placeholder;
        _item.rightText = self.rightText;
        self.rightText.x = 110;
        self.rightText.y = (self.height - 21)/ 2;
        self.rightText.width = MTScreenW - 120;
        self.rightText.height = 21;
        self.rightText.clearButtonMode = UITextFieldViewModeAlways;
        self.rightText.adjustsFontSizeToFitWidth = YES;
    } else if ([item isKindOfClass:[HMCommonButtonItem class]])
    {
        [self.contentView addSubview:self.rightText];
        HMCommonTextfieldItem *hitem = (HMCommonTextfieldItem *)item;
        self.rightText.placeholder = hitem.placeholder;
        self.rightText.x = 110;
        self.rightText.width = MTScreenW - 200;
        self.rightText.height = 42;
        self.rightText.adjustsFontSizeToFitWidth = YES;
        self.accessoryView = self.rightBtn;
        [self.rightBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    } else if ([item isKindOfClass:[HMCommonSwitchItem class]]) {
        self.accessoryView = self.rightSwitch;
        [self.rightSwitch setOn:_item.selected animated:YES];
        [self.rightSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    } else if ([item isKindOfClass:[HMCommonLabelItem class]]) {
        HMCommonLabelItem *labelItem = (HMCommonLabelItem *)item;
        // 设置文字
        self.rightLabel.text = labelItem.text;
        // 根据文字计算尺寸
        self.rightLabel.size = [labelItem.text sizeWithAttributes:@{NSFontAttributeName:self.rightLabel.font}];
        self.accessoryView = self.rightLabel;
    } else { // 取消右边的内容
        self.accessoryView = nil;
    }
}

/**
 *  点击switch的回掉函数
 */
-(void)buttonClick:(UIButton *)sender
{
    if (_item.buttonClickBlock) {
        _item.buttonClickBlock(sender);
    }
}

/**
 *  点击switch的回掉函数
 */
-(void)switchChanged:(UISwitch *)uiSwitch
{
    if (_item.switchChangeBlock) {
        _item.switchChangeBlock(uiSwitch);
    }
    
}
@end
