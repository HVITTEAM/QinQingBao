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
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholderImage.png"]];
    img.tag = 101;
    img.x = (self.width - 60)/2;
    img.y = self.height/2 - 180;
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
    la.x = (self.width - la.width)/2;
    la.y = self.height/2 - 106;
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
