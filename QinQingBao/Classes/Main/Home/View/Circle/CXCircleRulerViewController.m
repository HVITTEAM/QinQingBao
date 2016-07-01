//
//  CXCircleRulerViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/7/1.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CXCircleRulerViewController.h"

@interface CXCircleRulerViewController ()

@end

@implementation CXCircleRulerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //画背景
    [self drawCircleWithAngle:360 animated:NO];
    
    
    [self drawCircleWithAngle:170 animated:YES];
    
}

-(void)drawCircleWithAngle:(CGFloat)Angle animated:(Boolean)animated
{
    CAShapeLayer *dotteLine =  [CAShapeLayer layer];
    CGMutablePathRef dottePath =  CGPathCreateMutable();
    dotteLine.lineWidth = 15.0f ;
    
    if (animated)
        dotteLine.strokeColor = [UIColor orangeColor].CGColor;
    else
        dotteLine.strokeColor = [UIColor lightGrayColor].CGColor;
    
    dotteLine.fillColor = [UIColor clearColor].CGColor;
    CGPathAddEllipseInRect(dottePath, nil, CGRectMake(50.0f,  150.0f, 200.0f, 200.0f));
    dotteLine.path = dottePath;
    NSArray *arr = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:5], nil];
    dotteLine.lineDashPhase = 1.0;
    dotteLine.lineDashPattern = arr;
    CGPathRelease(dottePath);
    
    if (animated)
        [self drawLineAnimation:dotteLine];
    [self.view.layer addSublayer:dotteLine];
    
    UIBezierPath *thePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(200, 200) radius:75 startAngle:0 endAngle:(M_PI * Angle)/180 clockwise:YES];
    dotteLine.path = thePath.CGPath;
    [self.view.layer addSublayer:dotteLine];
    
}

-(void)drawLineAnimation:(CALayer*)layer
{
    CABasicAnimation *bas = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration = 1;
    bas.delegate = self;
    bas.fromValue = [NSNumber numberWithInteger:0];
    bas.toValue = [NSNumber numberWithInteger:1];
    [layer addAnimation:bas forKey:@"key"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
