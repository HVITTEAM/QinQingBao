//
//  ExtendFooterView.m
//  QinQingBao
//
//  Created by shi on 16/8/15.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ExtendFooterView.h"

@interface ExtendFooterView ()

@property(strong,nonatomic)UIImageView *iconImageView;

@property(strong,nonatomic)UILabel *lb;

@property (assign,nonatomic)BOOL isExtend;

@property(assign)NSInteger section;

@property(strong)NSString *title;

@property(strong)NSString *extendTitle;

@end

@implementation ExtendFooterView

-(instancetype)initWithTitle:(NSString *)title extendTitle:(NSString *)extendTitle imageName:(NSString *)imageName extend:(BOOL)isExtend section:(NSInteger)section
{
    if (self = [super init]) {
    
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)];
        recognizer.numberOfTapsRequired = 1;
        [self addGestureRecognizer:recognizer];
        
        self.lb = [[UILabel alloc] init];
        self.lb.textColor = [UIColor lightGrayColor];
        self.lb.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.lb];
        
        self.iconImageView = [[UIImageView alloc] init];
        self.iconImageView.image = [UIImage imageNamed:imageName];
        [self addSubview:self.iconImageView];
        
        self.section = section;
        self.title = title;
        self.extendTitle = extendTitle;
        
        self.isExtend = isExtend;
    }
    
    return self;
}

-(void)setIsExtend:(BOOL)isExtend
{
    _isExtend = isExtend;

    if (isExtend) {
        self.lb.text = self.extendTitle;
    }else{
        self.lb.text = self.title;
    }
    
    [self.lb sizeToFit];
    self.lb.frame = CGRectMake((MTScreenW - self.lb.bounds.size.width)/2 -20, 0, self.lb.bounds.size.width, 45);
    
    self.iconImageView.frame = CGRectMake(CGRectGetMaxX(self.lb.frame) + 5, (44 - 10) / 2, 10, 10);
    
    if (isExtend) {
        self.iconImageView.transform = CGAffineTransformRotate(self.iconImageView.transform, M_PI);
    }else{
        self.iconImageView.transform = CGAffineTransformIdentity;
    }
}

-(void)viewDidTap:(UITapGestureRecognizer *)recognizer
{
    self.isExtend = !self.isExtend;
    
    if (self.extendFooterViewTapCallBack) {
        self.extendFooterViewTapCallBack(self.section,self.isExtend);
    }
}


@end
