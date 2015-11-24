//
//  Star.m
//  NewZhiyou
//
//  Created by user on 11-8-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Star.h"
@implementation Star

@synthesize font_size, max_star, show_star;
@synthesize empty_color, full_color, isSelect;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        max_star = 100;
        show_star = 0;
        isSelect = NO;
        
        self.backgroundColor = [UIColor clearColor];
        font_size = 13.0f;
        self.empty_color = [UIColor colorWithRed:167.0f / 255.0f green:167.0f / 255.0f blue:167.0f / 255.0f alpha:1.0f];
        self.full_color = [UIColor colorWithRed:255.0f / 255.0f green:121.0f / 255.0f blue:22.0f / 255.0f alpha:1.0f];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSString* stars=@"★★★★★";
    
    rect= self.bounds;
    UIFont *font = [UIFont boldSystemFontOfSize: font_size];
    CGSize starSize = [stars sizeWithFont: font];
    rect.size=starSize;
    [empty_color set];
    [stars drawInRect:rect withFont:font];
//    [@"☆☆☆☆☆" drawInRect:rect withFont:font];
    
    CGRect clip=rect;
    clip.size.width = clip.size.width * show_star / max_star;
    CGContextClipToRect(context,clip);
    [full_color set];
    [stars drawInRect:rect withFont:font];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    if (isSelect) {
        CGPoint pt = [[touches anyObject] locationInView:self];
        UIFont *font = [UIFont boldSystemFontOfSize: font_size];
        CGSize starSize = [@"★★★★★" sizeWithFont: font];
        if (pt.x > starSize.width + 5) {
            return;
        }
        show_star = (NSInteger)(100.0f * pt.x / starSize.width);
        [self setNeedsDisplay];

    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
    if (isSelect) {
        CGPoint pt = [[touches anyObject] locationInView:self];
        UIFont *font = [UIFont boldSystemFontOfSize: font_size];
        CGSize starSize = [@"★★★★★" sizeWithFont: font];
        if (pt.x > starSize.width + 5) {
            return;
        }
        show_star = (NSInteger)(100.0f * pt.x / starSize.width);
        [self setNeedsDisplay];
        
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{

}

@end
