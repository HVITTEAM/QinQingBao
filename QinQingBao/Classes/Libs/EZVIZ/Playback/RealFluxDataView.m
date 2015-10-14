//
//  RealFluxData.m
//  VideoGo
//
//  Created by yudan on 14-6-19.
//
//

#import "RealFluxDataView.h"

#define CTRL_POINT_NUM         12  


@interface RealFluxDataView()
{
    NSMutableArray          *_arrRealData;
    NSMutableArray          *_arrMaxData;
    UIImage                 *_bgImg;
}

@end

@implementation RealFluxDataView  

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _arrRealData = [[NSMutableArray alloc] initWithCapacity:CTRL_POINT_NUM];
        for (int i=0; i<CTRL_POINT_NUM; i++)
        {
            [_arrRealData addObject:[NSNumber numberWithFloat:0.0f]];
        }
        
        int nX = 0;
        int r = frame.size.width/2 - 2;
        _arrMaxData = [[NSMutableArray alloc] initWithCapacity:CTRL_POINT_NUM];
        for (int i=0; i<CTRL_POINT_NUM; i++)
        {
            // 计算当前x轴下圆边高度  h^2 = r^2 - x^2
            int x = r > nX?(r-nX):(nX-r);
            int h = sqrt(r*r - x*x);
            h = h > 0? h-1:h;
            nX += (frame.size.width - 2) / CTRL_POINT_NUM;
            
            [_arrMaxData addObject:[NSNumber numberWithInt:h]];
        }
        
        _bgImg = [UIImage imageNamed:@"full_multiple_bg.png"];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect
{
    [_bgImg drawInRect:rect];
    
    CGRect rcView = self.frame;
    int nWSpace = (self.frame.size.width - 2) / CTRL_POINT_NUM;
    int nHBase = (self.frame.size.height - 2) / 2;
    int nX = 1;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.23, 0.64, 0.87, 1.0f);
    CGContextSetRGBFillColor(context, 0.23, 0.64, 0.87, 0.6f);
    CGContextBeginPath(context);
    
    // 先画个圆弧
    int r = rcView.size.width / 2 - 2;
    CGContextMoveToPoint(context, rcView.size.width - 2, rcView.size.height/2);
    CGContextAddArc(context, rcView.size.width/2, rcView.size.height/2, r, 0, M_PI, 0);
    
    nX += nWSpace;
    for (int i = 1; i < [_arrRealData count]; i++)
    {
        int h = [[_arrMaxData objectAtIndex:i] intValue];
        int nH = MAX(MIN(r+h, rcView.size.height - nHBase * [[_arrRealData objectAtIndex:i] floatValue]), r-h);
        CGContextAddLineToPoint(context, nX, nH);
        nX += nWSpace;
    }

    CGContextClosePath(context);
    
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, 1);
    
    CGContextDrawPath(context, kCGPathFill);
}

/**
 *  实时数据视图刷新
 *
 *  @param fData 实时数据
 */
- (void)updateData:(float)fData
{
    fData = fData>2?2:fData;
    if ([_arrRealData count] >= CTRL_POINT_NUM)
    {
        [_arrRealData removeObjectAtIndex:0];
    }
    
    [_arrRealData addObject:[NSNumber numberWithFloat:fData]];
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [self setNeedsDisplay];
                   });  
}

@end
