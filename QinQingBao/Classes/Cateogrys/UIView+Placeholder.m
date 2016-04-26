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
    
    //[self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
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

- (void)initWithPlaceString:(NSString *)placeStr
{
    [self removePlace];
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholderImage.png"]];
    img.tag = 101;
    img.x = (self.width - 60)/2;
    img.y = MTScreenH/2 - 180;
    img.width = img.height = 60;
    [self addSubview:img];
    
    UILabel *la = [[UILabel alloc] init];
    la.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
    la.textColor = [UIColor grayColor];
    la.tag = 100;
    CGSize size = [placeStr sizeWithFont:la.font];
    la.size = size;
    la.text = placeStr;
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
