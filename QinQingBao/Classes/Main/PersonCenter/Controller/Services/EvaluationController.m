//
//  EvaluationController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/10.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "EvaluationController.h"

@interface EvaluationController ()

@end

@implementation EvaluationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"评价";
    self.evaContentText.layer.borderColor = [HMGlobalBg CGColor];
    self.evaContentText.layer.borderWidth = 1;
    self.evaContentText.layer.cornerRadius = 3;
}

- (IBAction)starClickeHandler:(id)sender
{
    float maxStar;
    UIButton *btn = sender;
    btn.selected =  !btn.selected;
    if (btn.selected)
    {
        for (int i = 100; i < btn.tag+1; i++)
        {
            UIButton *otherBtn = (UIButton*)[self.view viewWithTag:i];
            otherBtn.selected =  YES;
        }
        maxStar = btn.tag - 99;
    }
    else
    {
        for (int i =  btn.tag+1; i < 105; i++)
        {
            UIButton *otherBtn = (UIButton*)[self.view viewWithTag:i];
            otherBtn.selected =  NO;
        }
        maxStar = btn.tag - 100;
    }
    if (maxStar == 0)
        self.starLabel.text = @"";
    if (maxStar == 1)
        self.starLabel.text = @"很差";
    else  if (maxStar == 2)
        self.starLabel.text = @"一般";
    else  if (maxStar == 3)
        self.starLabel.text = @"好";
    else  if (maxStar == 4)
        self.starLabel.text = @"很好";
    else  if (maxStar == 5)
        self.starLabel.text = @"非常好";
}
@end
