//
//  ServiceHeadView.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/8.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "ShopHeadView.h"

@implementation ShopHeadView


- (void)drawRect:(CGRect)rect
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.bounds];
    [shapeLayer setPosition:self.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:[[UIColor grayColor] CGColor]];
    [shapeLayer setLineWidth:.5f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:5],
      [NSNumber numberWithInt:2],nil]];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 10, 79);
    CGPathAddLineToPoint(path, NULL, MTScreenW,79);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    [[self layer] addSublayer:shapeLayer];
}

-(void)setHeadUrl:(NSString *)url title:(NSString *)title sellNum:(NSString*)sellNum time:(NSString*)time
{
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Img,url]];
    [self.icon sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
    
    self.title.text = title;
    self.timeLab.text = [NSString stringWithFormat:@"%@分钟",time];
    
    if ([sellNum floatValue] == 0)
        self.sum.text = @"已售0单";
    else
        self.sum.text = [NSString stringWithFormat:@"已售%@单",sellNum];
}
@end
