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
    
    UILabel *la1;
    
    UILabel *la;
    
    CGFloat currentValue;
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

-(void)setDangerText:(NSString *)dangerText
{
    _dangerText = dangerText;
    la.text = dangerText;
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
    
    //创建中间的圆
    self.middleLayer = [CAShapeLayer layer];
    self.middleLayer.strokeColor = [[UIColor whiteColor] CGColor];
    self.middleLayer.fillColor = [[UIColor whiteColor] CGColor];
    self.middleLayer.strokeStart = 0;
    self.middleLayer.strokeEnd = 1.0f;
    self.middleLayer.transform = self.upperLayer.transform;
    
    
    [self.layer addSublayer:self.middleLayer];
    [self.layer addSublayer:self.lowerLayer];
    [self.layer addSublayer:self.upperLayer];
    
    lab = [[UILabel alloc] initWithFrame:CGRectMake(MTScreenW/2 - 50, self.upperLayer.bounds.size.height, 100, 50)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont boldSystemFontOfSize:44];
    lab.textColor = [UIColor orangeColor];
    [self addSubview:lab];
    
    la = [[UILabel alloc] initWithFrame:CGRectMake(MTScreenW/2 - 50,  0, 100, 20)];
    la.textAlignment = NSTextAlignmentCenter;
    la.font = [UIFont systemFontOfSize:19];
    la.textColor = [UIColor colorWithRGB:@"#666666"];
    la.text = @"中危";
    [self addSubview:la];
    
    la1 = [[UILabel alloc] initWithFrame:CGRectMake(MTScreenW/2 - 50, 20, 100, 50)];
    la1.textAlignment = NSTextAlignmentCenter;
    la1.font = [UIFont systemFontOfSize:12];
    la1.textColor = [UIColor colorWithRGB:@"#4d4d4d"];
    la1.text = @"10年内患病概率";
    [self addSubview:la1];
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
    
    lab.center = CGPointMake(width / 2 + 6.5, height / 2);
    
    CGPathRef circlePath1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width / 2, height / 2) radius:r - 20 startAngle:0 endAngle:M_PI *2  clockwise:NO].CGPath;
    
    
    CGPathRef circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width / 2, height / 2) radius:r startAngle:M_PI_4 endAngle:M_PI_4 * 3  clockwise:NO].CGPath;
    
    //设置path和lineWidth;
    self.upperLayer.path = circlePath;
    self.upperLayer.lineWidth = lineWidth + 2;
    
    self.lowerLayer.lineWidth = lineWidth;
    self.lowerLayer.path = circlePath;
    
    self.middleLayer.lineWidth = 1;
    self.middleLayer.path = circlePath1;
    
    la1.center = CGPointMake(width / 2, height / 2 + 40);
    
    la.center = CGPointMake(width / 2, height / 2 - 40);
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

-(void)setMidStr:(NSString *)midStr
{
    _midStr = midStr;
}

-(void)setPercentValue:(CGFloat)percentValue
{
    _percentValue = percentValue;
    
    CGFloat lastStrokeEnd = self.upperLayer.strokeEnd;
    
    CGFloat value = percentValue / 100.0;
    self.upperLayer.strokeEnd = value;
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(setupLabel:) userInfo:nil repeats:YES];
    
    [self.layer removeAllAnimations];
    
    //获取所有的颜色
    id color0 = (id)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    id color1 = (id)[UIColor colorWithRed:52/255.0 green:171/255.0 blue:222/255.0 alpha:1.0].CGColor;
    id color2 = (id)[UIColor colorWithRed:141/255.0 green:196/255.0 blue:72/255.0 alpha:1.0].CGColor;
    id color3 = (id)[UIColor colorWithRed:246/255.0 green:146/255.0 blue:50/255.0 alpha:1.0].CGColor;
    id color4 = (id)[UIColor colorWithRed:238/255.0 green:91/255.0 blue:49/255.0 alpha:1.0].CGColor;
    id color5 = (id)[UIColor colorWithRed:217/255.0 green:26/255.0 blue:44/255.0 alpha:1.0].CGColor;
    NSArray *allColors = @[color0,color1,color2,color3,color4,color5];
    
    //起始颜色及结束颜色的索引
    int colorStartIdx = [self getIdxOfColorByValue:lastStrokeEnd * 100];
    int colorEndIdx = [self getIdxOfColorByValue:percentValue];
    
    //最后所需的颜色数组
    NSMutableArray *needsColors = [[NSMutableArray alloc] init];
    
    //如果要显示的值越来越大,颜色要往前渐变,否则要往后渐变
    if (value > lastStrokeEnd) {
        //往前
        for (int i = colorStartIdx; i <= colorEndIdx; i++) {
            [needsColors addObject:allColors[i]];
        }
    }else{
        //后退
        for (int i = colorStartIdx; i >= colorEndIdx; i--) {
            [needsColors addObject:allColors[i]];
        }
    }
    
    //动画时间
    CGFloat duration = 5.0f;
    
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    anima.duration = fabs(value - lastStrokeEnd) * duration;
    anima.fromValue = @(lastStrokeEnd);
    anima.toValue = @(value);
    anima.removedOnCompletion = NO;
    [self.upperLayer addAnimation:anima forKey:nil];

    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeColor"];
    keyAnimation.duration = fabs(value - lastStrokeEnd) * duration;
    keyAnimation.fillMode = kCAFillModeForwards;
    keyAnimation.timingFunctions =@[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    keyAnimation.values = needsColors;
    keyAnimation.removedOnCompletion = NO;
    [self.upperLayer addAnimation:keyAnimation forKey:nil];
    
    [self.middleLayer addAnimation:keyAnimation forKey:nil];
}

/**
 *  allColors颜色数组中的颜色下标 (allColors在-(void)setPercentValue:(CGFloat)percentValue方法内部)
 */
-(int)getIdxOfColorByValue:(CGFloat)value
{
    int idx;
    
    if (value == 0) {
        idx = 0;
    }else if (value >=1 && value <= 20) {
        idx = 1;
    }else if (value >=21 && value <= 40){
        idx = 2;
    }else if (value >=41 && value <= 60){
        idx = 3;
    }else if (value >=61 && value <= 80){
        idx = 4;
    }else{
        idx = 5;
    }
    
    return idx;
}


- (void)animationDidStart:(CAAnimation *)anim
{
    NSLog(@"start");
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"stop");
}

//设置跳数
- (void)setupLabel:(NSTimer *)timer
{
    currentValue ++;
    static int flag = 1;

    if ((currentValue >= self.percentValue))
    {
        NSString *string                            = [NSString stringWithFormat:@"%@%%",self.midStr];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        
        [attributedString addAttribute:NSFontAttributeName
                                 value:[UIFont systemFontOfSize:13.f]
                                 range:NSMakeRange(self.midStr.length, 1)];
        
        lab.attributedText = attributedString;

        flag = 1;
        [timer invalidate];
        timer = nil;
        return;
    }
    else
    {
        
        NSString *string                            = [NSString stringWithFormat:@"%@%%",self.midStr];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        
        [attributedString addAttribute:NSFontAttributeName
                                 value:[UIFont systemFontOfSize:13.f]
                                 range:NSMakeRange(self.midStr.length, 1)];
        
            lab.attributedText = attributedString;
    }
    
    flag++;
    
}

@end
