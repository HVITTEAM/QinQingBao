//
//  UIViewController+Placeholder.m
//  QinQingBao
//
//  Created by 董徐维 on 15/12/1.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "UIViewController+Placeholder.h"

@implementation UIViewController (Placeholder)
- (void)initWithPlaceString:(NSString *)placeStr
{
    [self removePlace];
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholderImage.png"]];
    img.tag = 101;
    img.x = (MTScreenW - 60)/2;
    img.y = MTScreenH/2 - 180;
    img.width = img.height = 60;
    [self.view addSubview:img];
    
    UILabel *la = [[UILabel alloc] init];
    la.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
    la.textColor = [UIColor grayColor];
    la.tag = 100;
    CGSize size = [placeStr sizeWithFont:la.font];
    la.size = size;
    la.text = placeStr;
    la.x = (MTScreenW - la.width)/2;
    la.y = MTScreenH/2 - 106;
    [self.view addSubview:la];
}

-(void)removePlace
{
    UILabel *lable = [self.view viewWithTag:100];
    UIImageView *img = [self.view viewWithTag:101];
    [img removeFromSuperview];
    [lable removeFromSuperview];
}

@end