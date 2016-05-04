//
//  MTTextView.m
//  QinQingBao
//
//  Created by 董徐维 on 16/04/23.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "MTTextView.h"

@interface MTTextView() <UITextViewDelegate>
@property (nonatomic, weak) UILabel *placehoderLabel;
@end

@implementation MTTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
<<<<<<< HEAD
        // 添加一个显示提醒文字的label（显示占位文字的label）
=======
>>>>>>> 1e558a848deb81be2c4ef29eacdd428b1e3f63f7
        UILabel *placehoderLabel = [[UILabel alloc] init];
        placehoderLabel.numberOfLines = 0;
        placehoderLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:placehoderLabel];
        self.placehoderLabel = placehoderLabel;
<<<<<<< HEAD
        
        // 设置默认的占位文字颜色
        self.placehoderColor = [UIColor lightGrayColor];
        
        // 设置默认的字体
=======
        self.placehoderColor = [UIColor lightGrayColor];
>>>>>>> 1e558a848deb81be2c4ef29eacdd428b1e3f63f7
        self.font = [UIFont systemFontOfSize:14];
        
        // 监听内部文字改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 监听文字改变
- (void)textDidChange
{
<<<<<<< HEAD
    // text属性：只包括普通的文本字符串
    // attributedText：包括了显示在textView里面的所有内容（表情、text）
=======
>>>>>>> 1e558a848deb81be2c4ef29eacdd428b1e3f63f7
    self.placehoderLabel.hidden = self.hasText;
}

#pragma mark - 公共方法
- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [self textDidChange];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    [self textDidChange];
}

- (void)setPlacehoder:(NSString *)placehoder
{
    _placehoder = [placehoder copy];
    
    // 设置文字
    self.placehoderLabel.text = placehoder;
    
    // 重新计算子控件的fame
    [self setNeedsLayout];
}

- (void)setPlacehoderColor:(UIColor *)placehoderColor
{
    _placehoderColor = placehoderColor;
    
    // 设置颜色
    self.placehoderLabel.textColor = placehoderColor;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.placehoderLabel.font = font;
    
    // 重新计算子控件的fame
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.placehoderLabel.y = 8;
    self.placehoderLabel.x = 5;
    self.placehoderLabel.width = self.width - 2 * self.placehoderLabel.x;
<<<<<<< HEAD
    // 根据文字计算label的高度
=======
    
>>>>>>> 1e558a848deb81be2c4ef29eacdd428b1e3f63f7
    CGSize maxSize = CGSizeMake(self.placehoderLabel.width, MAXFLOAT);
    CGSize placehoderSize = [self.placehoder sizeWithFont:self.placehoderLabel.font constrainedToSize:maxSize];
    self.placehoderLabel.height = placehoderSize.height;
}

@end
