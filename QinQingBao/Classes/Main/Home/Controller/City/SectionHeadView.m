//
//  SectionHeadView.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/23.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "SectionHeadView.h"

@implementation SectionHeadView

- (id)initWithFrame:(CGRect)frame expanded:(BOOL)expanded
{
    if (self = [super initWithFrame:frame])
    {
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)setTitle:(NSString *)title indexSection:(NSInteger)indexSection
{
    self.title = title;
    self.indexSection = indexSection;
    [self initView];
}

-(void)initView
{
    //立刻购买
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(-10, 0, 100, self.height - 1)];
    [btn setTitle:self.title forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    [btn addTarget:self action:@selector(buyClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:btn];
    
    UIButton *arrowbtn = [[UIButton alloc]initWithFrame:CGRectMake(MTScreenW - 30, self.height/2 - 3, 13, 7)];
    [arrowbtn setBackgroundImage:[UIImage imageNamed:@"arrowdown.png"] forState:UIControlStateNormal];
    [arrowbtn setBackgroundImage:[UIImage imageNamed:@"arrowup.png"] forState:UIControlStateSelected];
    [arrowbtn addTarget:self action:@selector(buyClick:) forControlEvents:UIControlEventTouchUpInside];
    [arrowbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:arrowbtn];
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.height-0.5, self.width, 0.5)];
    line.backgroundColor=[UIColor colorWithRGB:@"e2e2e2"];
    [self addSubview:line];
    
    UITapGestureRecognizer  *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:singleTapGestureRecognizer];
}

-(void)singleTapGesture:(UITapGestureRecognizer *)tap
{
    self.expandedClick(self.indexSection);
}

-(void)buyClick:(UIButton *)btn
{
    self.expandedClick(self.indexSection);
}


@end
