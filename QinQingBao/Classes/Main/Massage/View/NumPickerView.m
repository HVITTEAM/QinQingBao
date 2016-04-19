
//
//  NumPickerView.m
//  QinQingBao
//
//  Created by shi on 16/4/15.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#define kDefaultBtnWidth 30
#define kDefaultViewColor HMColor(220, 220, 220)

#import "NumPickerView.h"

@interface NumPickerView ()

@property(strong,nonatomic)UIButton *addBtn;

@property(strong,nonatomic)UIButton *minusBtn;

@property(strong,nonatomic)UILabel *numLb;

@end

@implementation NumPickerView

+(instancetype)numPickerViewWithFrame:(CGRect)frame
{
    NumPickerView *numPickerView = [[NumPickerView alloc] initWithFrame:frame];
    [numPickerView setupUI];
    
    return numPickerView;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupUI];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat addMinusBtnWidth = self.buttonWidth > 10?self.buttonWidth:kDefaultBtnWidth;
    
    self.minusBtn.frame = CGRectMake(0, 0, addMinusBtnWidth, self.frame.size.height);
    self.addBtn.frame = CGRectMake(self.frame.size.width - addMinusBtnWidth, 0, addMinusBtnWidth, self.frame.size.height);
    self.numLb.frame = CGRectMake(CGRectGetMaxX(self.minusBtn.frame), 0, self.frame.size.width - 2 * addMinusBtnWidth, self.frame.size.height);
}

-(void)setPickerViewButtonColor:(UIColor *)pickerViewButtonColor
{
    _pickerViewButtonColor = pickerViewButtonColor;
    
    UIColor *pickerViewColor = self.pickerViewButtonColor?:kDefaultViewColor;
    
    self.addBtn.backgroundColor = pickerViewColor;
    self.minusBtn.backgroundColor = pickerViewColor;
    self.layer.borderColor = pickerViewColor.CGColor;
}

-(void)setNumber:(CGFloat)number
{
    _number = number;
    if (_number < 0) {
        _number = 0;
    }
    
    self.numLb.text = [[NSString alloc] initWithFormat:@"%d",(int)self.number];
}

-(void)setupUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = kDefaultViewColor.CGColor;
    self.layer.borderWidth = 1.0f;
    
    UIButton *addButton = [[UIButton alloc] init];
    [addButton setTitle:@"+" forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont systemFontOfSize:20];
    addButton.backgroundColor = kDefaultViewColor;
    [addButton addTarget:self action:@selector(numberChange:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addButton];
    self.addBtn = addButton;
    
    UIButton *minusButton = [[UIButton alloc] init];
    [minusButton setTitle:@"-" forState:UIControlStateNormal];
    minusButton.titleLabel.font = [UIFont systemFontOfSize:20];
    minusButton.backgroundColor = kDefaultViewColor;
    [minusButton addTarget:self action:@selector(numberChange:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:minusButton];
    self.minusBtn = minusButton;
    
    UILabel *lb = [[UILabel alloc] init];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.font = [UIFont systemFontOfSize:12];
    
    lb.text = [[NSString alloc] initWithFormat:@"%d",(int)self.number];
    [self addSubview:lb];
    self.numLb = lb;
    
}

-(void)numberChange:(UIButton *)sender
{
    if (0 == self.number && sender == self.minusBtn) {
        return;
    }
    
    if (sender == self.addBtn) {
        self.number++;
    }else{
        self.number--;
    }
    
    self.numLb.text = [[NSString alloc] initWithFormat:@"%d",(int)self.number];
    
    if (self.numberDidChangeHandle) {
        self.numberDidChangeHandle(self.number);
    }
}


@end
