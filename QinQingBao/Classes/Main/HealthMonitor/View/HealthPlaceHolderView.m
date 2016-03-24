//
//  HealthPlaceHolderView.m
//  QinQingBao
//
//  Created by 董徐维 on 16/3/23.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "HealthPlaceHolderView.h"

@implementation HealthPlaceHolderView

- (void)drawRect:(CGRect)rect
{
    self.bangBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.bangBtn.layer.borderWidth = 0.5;
    self.bangBtn.layer.cornerRadius = 4;
    self.bangBtn.layer.masksToBounds = YES;
}


- (IBAction)clickHandler:(id)sender {
    if (self.buttonClick)
        self.buttonClick(sender);
}
@end
