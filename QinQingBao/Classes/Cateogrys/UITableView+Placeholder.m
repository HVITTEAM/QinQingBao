//
//  UITableView+Placeholder.m
//  QinQingBao
//
//  Created by 董徐维 on 15/10/26.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "UITableView+Placeholder.h"

@implementation UITableView (Placeholder)

- (void)initWithPlaceString:(NSString *)placeStr
{
    [self removePlace];
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_logo.png"]];
    img.tag = 101;
    img.x = (MTScreenW - 60)/2;
    img.y = MTScreenH/2 - 180;
    img.width = img.height = 60;
    [self addSubview:img];
    
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage)];
    [img addGestureRecognizer:singleTap];
    
    UILabel *la = [[UILabel alloc] init];
    la.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
    la.textColor = [UIColor grayColor];
    la.tag = 100;
    CGSize size = [placeStr sizeWithAttributes:@{NSFontAttributeName:la.font}];
    la.size = size;
    la.text = placeStr;
    la.x = (MTScreenW - la.width)/2;
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

-(void)onClickImage
{
    self.refleshHandler();
}
@end
