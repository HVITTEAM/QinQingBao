//
//  RadianView.m
//  Circle
//
//  Created by shi on 16/7/6.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "RadianView.h"

@interface RadianView ()
{
    UILabel *lab;
}

@property (strong)CAShapeLayer *upperLayer;

@property (strong)CAShapeLayer *lowerLayer;

@property (strong)CAShapeLayer *middleLayer;


@end

@implementation RadianView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupUI];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.upperLayer.frame = self.bounds;
    self.lowerLayer.frame = self.upperLayer.frame;
    self.middleLayer.frame = self.upperLayer.frame;

    [self setPathByLineWidth:self.lineWidth];
}

/**
 *  初始化界面
 */
-(void)setupUI
{
    //设置默认值
    _lowerCircleColor = [UIColor whiteColor];
    _upperCircleColor = [UIColor redColor];
    _percentValue = 0;
    _lineWidth = 20.0;
    _lineThick = 2.0;
    _lineSpace = 6.0;
    
    //创建上层的圆
    self.upperLayer = [CAShapeLayer layer];
    self.upperLayer.strokeColor = self.upperCircleColor.CGColor;
    self.upperLayer.fillColor = [UIColor clearColor].CGColor;
    self.upperLayer.strokeStart = 0;
    self.upperLayer.strokeEnd = self.percentValue;
    self.upperLayer.lineDashPattern =@[@(self.lineThick),@(self.lineSpace)];
    self.upperLayer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0 );
    
    //创建下层的圆
    self.lowerLayer = [CAShapeLayer layer];
    self.lowerLayer.strokeColor = self.lowerCircleColor.CGColor;
    self.lowerLayer.fillColor = self.upperLayer.fillColor;
    self.lowerLayer.strokeStart = 0;
    self.lowerLayer.strokeEnd = 1.0f;
    self.lowerLayer.lineDashPattern = self.upperLayer.lineDashPattern;
    self.lowerLayer.transform = self.upperLayer.transform;
    
    //创建下层的圆
    self.middleLayer = [CAShapeLayer layer];
    self.middleLayer.strokeColor = [[UIColor orangeColor] CGColor];
    self.middleLayer.fillColor = [[UIColor whiteColor] CGColor];
    self.middleLayer.strokeStart = 0;
    self.middleLayer.strokeEnd = 1.0f;
    self.middleLayer.transform = self.upperLayer.transform;


    [self.layer addSublayer:self.middleLayer];
    [self.layer addSublayer:self.lowerLayer];
    [self.layer addSublayer:self.upperLayer];
    
    lab = [[UILabel alloc] initWithFrame:CGRectMake(MTScreenW/2, self.upperLayer.bounds.size.height, 100, 100)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont boldSystemFontOfSize:20];
    lab.textColor = [UIColor orangeColor];
    lab.text = @"健康";
    [self addSubview:lab];
}

/**
 *  设置上下两个CALayer的path
 */
-(void)setPathByLineWidth:(CGFloat)lineWidth
{
    CGFloat width = self.upperLayer.bounds.size.width;
    CGFloat height = self.upperLayer.bounds.size.height;
    CGFloat r = 0;
    
    //让圆居中显示,且与view的短边相切
    if (width >= height) {
        r = (height - lineWidth) / 2.0;
    }else{
        r = (width - lineWidth) / 2.0;
    }
    
    lab.center = CGPointMake(width / 2, height / 2);

    CGPathRef circlePath1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width / 2, height / 2) radius:r - 20 startAngle:0 endAngle:M_PI *2  clockwise:NO].CGPath;

    
    CGPathRef circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width / 2, height / 2) radius:r startAngle:M_PI_4 endAngle:M_PI_4 * 3  clockwise:NO].CGPath;
    
    //设置path和lineWidth;
    self.upperLayer.path = circlePath;
    self.upperLayer.lineWidth = lineWidth + 2;
    
    self.lowerLayer.lineWidth = lineWidth;
    self.lowerLayer.path = circlePath;
    
    self.middleLayer.lineWidth = 1;
    self.middleLayer.path = circlePath1;
}

#pragma mark - 以下都是属性的setter方法

-(void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    //重新设置path和线宽
    [self setPathByLineWidth:lineWidth];
}

-(void)setLowerCircleColor:(UIColor *)lowerCircleColor
{
    _lowerCircleColor = lowerCircleColor;
    self.lowerLayer.strokeColor = lowerCircleColor.CGColor;
}

-(void)setUpperCircleColor:(UIColor *)upperCircleColor
{
    _upperCircleColor = upperCircleColor;
    self.upperLayer.strokeColor = upperCircleColor.CGColor;
}

-(void)setLineThick:(CGFloat)lineThick
{
    _lineThick = lineThick;
    
    self.upperLayer.lineDashPattern =@[@(lineThick),@(self.lineSpace)];
    self.lowerLayer.lineDashPattern = self.upperLayer.lineDashPattern;
}

-(void)setLineSpace:(CGFloat)lineSpace
{
    _lineSpace = lineSpace;
    self.upperLayer.lineDashPattern =@[@(self.lineThick),@(lineSpace)];
    self.lowerLayer.lineDashPattern = self.upperLayer.lineDashPattern;
}

-(void)setPercentValue:(CGFloat)percentValue
{
    _percentValue = percentValue;
    CGFloat lastStrokeEnd = self.upperLayer.strokeEnd;
    
    CGFloat value = percentValue / 100.0;
    self.upperLayer.strokeEnd = value;
    
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    anima.duration = 1.0f;
    anima.delegate = self;
    anima.fromValue = @(lastStrokeEnd);
    anima.toValue = @(value);
    anima.removedOnCompletion = YES;
    
    [self.upperLayer addAnimation:anima forKey:nil];
}

- (void)animationDidStart:(CAAnimation *)anim
{
    NSLog(@"start");
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"stop");
}

@end
