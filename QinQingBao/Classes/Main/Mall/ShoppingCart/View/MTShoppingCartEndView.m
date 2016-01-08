//
//  MTShoppingCartEndView.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/7.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "MTShoppingCartEndView.h"

#import "MTShoppingCarController.h"


@interface MTShoppingCartEndView ()

@end

static CGFloat VIEW_HEIGHT = 50;

@implementation MTShoppingCartEndView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addObserver:self forKeyPath:@"isEdit" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        [self initView];
    }
    return self;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"isEdit"])
    {
        if (self.isEdit)
        {
            _Lab.hidden=YES;
            _deleteBt.hidden=NO;
            _pushBt.hidden=YES;
        }
        else
        {
            _Lab.hidden=NO;
            _deleteBt.hidden=YES;
            _pushBt.hidden=NO;
        }
    }
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"isEdit"];
}

-(void)initView
{
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MTScreenW, 0.5)];
    line.backgroundColor=[UIColor colorWithRGB:@"e2e2e2"];
    [self addSubview:line];
    UIImage *btimg = [UIImage imageNamed:@"Unselected.png"];
    UIImage *selectImg = [UIImage imageNamed:@"Selected.png"];
    
    _selectedAllbt = [[UIButton alloc]initWithFrame:CGRectMake(-10, self.frame.size.height/2-btimg.size.height/2, btimg.size.width+60, btimg.size.height)];
    _selectedAllbt.selected = YES;
    [_selectedAllbt addTarget:self action:@selector(clickAllEnd:) forControlEvents:UIControlEventTouchUpInside];
    [_selectedAllbt setImage:btimg forState:UIControlStateNormal];
    [_selectedAllbt setImage:selectImg forState:UIControlStateSelected];
    
    [_selectedAllbt setTitle:@"全选" forState:UIControlStateNormal];
    _selectedAllbt.titleLabel.textAlignment = NSTextAlignmentLeft;
    _selectedAllbt.titleLabel.font =[UIFont systemFontOfSize:13];
    [_selectedAllbt setTitle:@"全选" forState:UIControlStateSelected];
    [_selectedAllbt setTitleColor:[UIColor colorWithRGB:@"333333"] forState:UIControlStateNormal];
    
    [self addSubview:_selectedAllbt];
    
    _pushBt = [[UIButton alloc]initWithFrame:CGRectMake(MTScreenW-100, 0, 100, self.height)];
    _pushBt.hidden = NO;
    _pushBt.tag=18;
    [_pushBt setTitle:@"结算" forState:UIControlStateNormal];
    _pushBt.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [_pushBt setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:@"dd2726"]] forState:UIControlStateNormal];
    [_pushBt setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];

    [[_pushBt layer]setCornerRadius:3.0];
    [_pushBt addTarget:self action:@selector(clickRightBT:) forControlEvents:UIControlEventTouchUpInside];
    [_pushBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_pushBt];
    
    _Lab =[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_pushBt.frame)-10 - 150, 3, 150, 25)];
    _Lab.textAlignment = NSTextAlignmentRight;
    _Lab.textColor=[UIColor colorWithRGB:@"dd2726"];
    _Lab.text=[NSString stringWithFormat:@"合计: ￥ 0"];
    _Lab.font=[UIFont systemFontOfSize:14];
    [self addSubview:_Lab];
    
    _freightLab =[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_pushBt.frame)-10 - 150, 23, 150, 25)];
    _freightLab.textColor=[UIColor colorWithRGB:@"666666"];
    _freightLab.text=[NSString stringWithFormat:@"不含运费"];
    _freightLab.font=[UIFont systemFontOfSize:12];
    _freightLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_freightLab];
    
    _deleteBt = [[UIButton alloc]initWithFrame:_pushBt.frame];
    _deleteBt.hidden=YES;
    [_deleteBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _deleteBt.tag = 19;
    [_deleteBt setTitle:@"删除" forState:UIControlStateNormal];
    _deleteBt.titleLabel.font = [UIFont systemFontOfSize:14];
    [_deleteBt setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:@"dd2726"]] forState:UIControlStateNormal];
    [_deleteBt setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    [[_deleteBt layer]setCornerRadius:3.0];
    [_deleteBt.layer setBorderWidth:0.5];
    [_deleteBt addTarget:self action:@selector(clickRightBT:) forControlEvents:UIControlEventTouchUpInside];
    _deleteBt.layer.borderColor = [[UIColor colorWithRGB:@"fb5d5d"] CGColor];
    
    [self addSubview:_deleteBt];
}

-(void)clickRightBT:(UIButton *)bt
{
    [self.delegate clickRightBT:bt];
}

-(void)clickAllEnd:(UIButton *)bt
{
    [self.delegate clickALLEnd:bt];
}

- (void)setIsEdit:(BOOL)isEdit
{
    _isEdit = isEdit;
}

+ (CGFloat)getViewHeight
{
    return VIEW_HEIGHT;
}
@end