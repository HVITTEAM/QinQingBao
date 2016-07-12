//
//  QuestionViewController.m
//  Healthy
//
//  Created by shi on 16/7/12.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "QuestionTwoBtnController.h"

@interface QuestionTwoBtnController ()

@property (weak, nonatomic) IBOutlet UIButton *btn1;

@property (weak, nonatomic) IBOutlet UIButton *btn2;

@property (weak, nonatomic) IBOutlet UIButton *btn3;

@property (weak, nonatomic) IBOutlet UIButton *btn4;

@property (weak, nonatomic) IBOutlet UIButton *btn5;

@property (weak, nonatomic) IBOutlet UIButton *btn6;

@property (weak, nonatomic) IBOutlet UIButton *btn7;

@property (weak, nonatomic) IBOutlet UIButton *btn8;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation QuestionTwoBtnController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

-(void)setupUI
{
    [self setupView:self.btn1];
    [self setupView:self.btn2];
    [self setupView:self.btn3];
    [self setupView:self.btn4];
    [self setupView:self.btn5];
    [self setupView:self.btn6];
    [self setupView:self.btn7];
    [self setupView:self.btn8];
    
    [self setupView:self.containerView];
    
    self.nextBtn.layer.cornerRadius = 7.0f;
    
    self.navigationItem.title = @"病";
    
}

- (IBAction)nextBtnClicke:(id)sender
{

}

-(void)setupView:(UIView *)v
{
    v.layer.borderWidth = 1.0f;
    v.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
    v.layer.cornerRadius = 7.0f;
}

@end
