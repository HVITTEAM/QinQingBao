//
//  EvaFootView.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/23.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "EvaFootView.h"

@implementation EvaFootView

+(EvaFootView *) evaFootView
{
    EvaFootView * cell = [[[NSBundle mainBundle] loadNibNamed:@"EvaFootView" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (IBAction)star1ClickeHandler:(id)sender
{
    UIButton *btn = sender;
    btn.selected =  !btn.selected;
    if (btn.selected)
    {
        for (int i = 100; i < btn.tag+1; i++)
        {
            UIButton *otherBtn = (UIButton*)[self.view1 viewWithTag:i];
            otherBtn.selected =  YES;
        }
        maxStar1 = btn.tag - 99;
    }
    else
    {
        for (int i =  btn.tag+1; i < 105; i++)
        {
            UIButton *otherBtn = (UIButton*)[self.view1 viewWithTag:i];
            otherBtn.selected =  NO;
        }
        maxStar1 = btn.tag - 100;
    }
}


- (IBAction)star2ClickeHandler:(id)sender
{
    UIButton *btn = sender;
    btn.selected =  !btn.selected;
    if (btn.selected)
    {
        for (int i = 100; i < btn.tag+1; i++)
        {
            UIButton *otherBtn = (UIButton*)[self.view2 viewWithTag:i];
            otherBtn.selected =  YES;
        }
        maxStar2 = btn.tag - 99;
    }
    else
    {
        for (int i =  btn.tag+1; i < 105; i++)
        {
            UIButton *otherBtn = (UIButton*)[self.view2 viewWithTag:i];
            otherBtn.selected =  NO;
        }
        maxStar2 = btn.tag - 100;
    }
}


- (IBAction)star3ClickeHandler:(id)sender
{
    UIButton *btn = sender;
    btn.selected =  !btn.selected;
    if (btn.selected)
    {
        for (int i = 100; i < btn.tag+1; i++)
        {
            UIButton *otherBtn = (UIButton*)[self.view3 viewWithTag:i];
            otherBtn.selected =  YES;
        }
        maxStar3 = btn.tag - 99;
    }
    else
    {
        for (int i =  btn.tag+1; i < 105; i++)
        {
            UIButton *otherBtn = (UIButton*)[self.view3 viewWithTag:i];
            otherBtn.selected =  NO;
        }
        maxStar3 = btn.tag - 100;
    }
}

-(NSString *)getEva
{
    return  [NSString stringWithFormat:@"%.00f-%.00f-%.00f",maxStar1,maxStar2,maxStar3];
}

@end
