//
//  CXCircleRulerViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/7/1.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CXCircleRulerViewController.h"

@interface CXCircleRulerViewController ()
@property (strong)CAShapeLayer *circleLayer;
@end

@implementation CXCircleRulerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //画背景
//    [self drawCircleWithAngle:360 animated:NO];
//    
//    
//    [self drawCircleWithAngle:170 animated:YES];
    
    self.circleLayer = [CAShapeLayer layer];
    self.circleLayer.frame = CGRectMake(150, 150, 100, 100);
    self.circleLayer.strokeColor = [UIColor orangeColor].CGColor;
    self.circleLayer.fillColor = [UIColor clearColor].CGColor;
    self.circleLayer.lineWidth = 10;
    CGPathRef circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(50, 50) radius:70 startAngle:M_PI_4 endAngle:M_PI_4 * 3  clockwise:NO].CGPath;
    self.circleLayer.path = circlePath;
    self.circleLayer.strokeStart = 0;
    self.circleLayer.strokeEnd = 0.3f;//刻度
    self.circleLayer.lineDashPattern =@[@3,@6];
    self.circleLayer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0 );
    
        CAShapeLayer *circleLayerGray = [CAShapeLayer layer];
    circleLayerGray.frame = self.circleLayer.frame;
    circleLayerGray.strokeColor = [UIColor grayColor].CGColor;
    circleLayerGray.fillColor = self.circleLayer.fillColor;
    circleLayerGray.lineWidth = self.circleLayer.lineWidth;
    circleLayerGray.path = circlePath;
    circleLayerGray.strokeStart = 0;
    circleLayerGray.strokeEnd = 1.0f;
    circleLayerGray.lineDashPattern = self.circleLayer.lineDashPattern;
    circleLayerGray.transform = self.circleLayer.transform;
    
    
    [self.view.layer addSublayer:circleLayerGray];
    [self.view.layer addSublayer:self.circleLayer];
    
    
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    anima.duration = 2.0f;
    anima.fromValue = @0;
    anima.toValue = @0.3f;//刻度
    
    [self.circleLayer addAnimation:anima forKey:nil];
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
