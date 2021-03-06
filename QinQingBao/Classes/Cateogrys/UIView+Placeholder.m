//
//  UIView+Placeholder.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/7.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "UIView+Placeholder.h"

@implementation UIView (Placeholder)

/**
*  提示用户
*
*/
- (void)showNonedataTooltip
{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"没有新的数据了";
    label.backgroundColor = [UIColor orangeColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    
    label.width = MTScreenW;
    label.height = 35;
    label.font = [UIFont systemFontOfSize:13];
    label.x = 0;
    label.y = MTScreenH;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:label];
    CGFloat duration = 0.75;
    [UIView animateWithDuration:duration animations:^{
        label.transform = CGAffineTransformMakeTranslation(0, -label.height);
    } completion:^(BOOL finished) {
        CGFloat delay = 1.0;
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}

- (void)initWithPlaceString:(NSString *)placeStr imgPath:(NSString *)imgPath
{
    [self removePlace];
    if (!imgPath)
        imgPath = @"placeholderImage.png";
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgPath]];
    img.tag = 101;
    img.width = 70;
    img.height = 70;
    img.x = (self.width - img.width)/2;
    img.y = MTScreenH/2 - 180;
    [self addSubview:img];
    
    UILabel *la = [[UILabel alloc] init];
    la.textColor = [UIColor grayColor];
    la.tag = 100;
    la.numberOfLines = 0;
    la.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
    la.text = placeStr;
    la.textAlignment = NSTextAlignmentCenter;
    la.width = MTScreenW;
    la.height = 50;
    la.x = (self.width - la.width)/2;
    la.y = MTScreenH/2 - 106;
    [self addSubview:la];
}

-(void)removePlace
{
    UILabel *lable = [self viewWithTag:100];
    UIImageView *img = [self viewWithTag:101];
    [img removeFromSuperview];
    [lable removeFromSuperview];
}

@end
