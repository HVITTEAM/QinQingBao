//
//  UIImage+Extension.m
//
//  Created by apple on 14-7-3.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "UIImage+Extension.h"

// 是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
@implementation UIImage (Extension)
+ (UIImage *)imageWithName:(NSString *)name
{
    UIImage *image = nil;
    if (iOS7) { // 处理iOS7的情况
        NSString *newName = [name stringByAppendingString:@"_os7"];
        image = [UIImage imageNamed:newName];
    }
    
    if (image == nil) {
        image = [UIImage imageNamed:name];
    }
    return image;
}

+ (UIImage *)resizedImage:(NSString *)name
{
    UIImage *image = [UIImage imageWithName:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(UIImage *)scaleImageToSize:(CGSize)size
{
    CGFloat scaleW = size.width/self.size.width;
    CGFloat scaleH = size.height/self.size.height;
    
    CGFloat finalScale;
    if (scaleW > scaleH) {
        finalScale = scaleW;
    }else{
        finalScale = scaleH;
    }
    
    CGFloat finalW = self.size.width *finalScale;
    CGFloat finalH = self.size.height *finalScale;
    CGRect finalRect;
    if (finalW > finalH) {
        finalRect = CGRectMake((size.width - finalW)/2, 0, finalW, finalH);
    }else{
        finalRect = CGRectMake(0, (size.height - finalH)/2, finalW, finalH);
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0f);
    [self drawInRect:finalRect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}


@end
