//
//  ServiceHeadView.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/8.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "MarketHeadView.h"
#import "MassageModel.h"

@implementation MarketHeadView

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
//    [[self layer] addSublayer:shapeLayer];
}

-(void)setItem:(MassageModel *)item
{
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Img,item.item_url_big]];
    [self.icon sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderDetail"]];
    
    NSLog(@"%@",self.item.promotion_price);
    if (item.promotion_price)
    {
        self.markImg.hidden = NO;
        self.markImg.image = [UIImage imageNamed:@"sell.png"];
    }
    else if ([item.sell_month floatValue] > 100)
    {
        self.markImg.hidden = NO;
        self.markImg.image = [UIImage imageNamed:@"hot.png"];
    }
    else
    {
        self.markImg.hidden = YES;
    }
    
    self.sellLab.layer.masksToBounds = YES;
    self.sellLab.layer.cornerRadius = 10;
    self.sellLab.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.sellLab.text = [NSString stringWithFormat:@"  月售%@单  ",item.sell];
}

@end
