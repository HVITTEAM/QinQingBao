//
//  DiscountCountDownCell.m
//  QinQingBao
//
//  Created by shi on 16/1/28.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "DiscountCountDownCell.h"

@interface DiscountCountDownCell ()

@property (weak, nonatomic) IBOutlet UIView *hoursView;

@property (weak, nonatomic) IBOutlet UIView *minutesView;

@property (weak, nonatomic) IBOutlet UIView *secondView;

@property (weak, nonatomic) IBOutlet UILabel *hoursLb;

@property (weak, nonatomic) IBOutlet UILabel *minutesLb;

@property (weak, nonatomic) IBOutlet UILabel *secondLb;

@end

@implementation DiscountCountDownCell

- (void)awakeFromNib {
    // Initialization code
    
    self.hoursView.layer.cornerRadius = 5.0f;
    self.hoursView.layer.masksToBounds = YES;
    self.hoursView.layer.borderColor = HMColor(97, 97, 97).CGColor;
    self.hoursView.layer.borderWidth = 0.5;
    
    self.minutesView.layer.cornerRadius = 5.0f;
    self.minutesView.layer.masksToBounds = YES;
    self.minutesView.layer.borderColor = HMColor(97, 97, 97).CGColor;
    self.minutesView.layer.borderWidth = 0.5;
    
    self.secondView.layer.cornerRadius = 5.0f;
    self.secondView.layer.masksToBounds = YES;
    self.secondView.layer.borderColor = HMColor(97, 97, 97).CGColor;
    self.secondView.layer.borderWidth = 0.5;

}

-(void)setHours:(NSString *)hours
{
    self.hoursLb.text = hours;
}

-(void)setMinutes:(NSString *)minutes
{
    self.minutesLb.text = minutes;
}

-(void)setSeconds:(NSString *)seconds
{
    self.secondLb.text = seconds;
}

@end
