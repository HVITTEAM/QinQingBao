//
//  BasicViewController.m
//  Healthy
//
//  Created by shi on 16/7/11.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "BasicViewController.h"
#import "QuestionOneBtnController.h"

@interface BasicViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *ageField;

@property (weak, nonatomic) IBOutlet UITextField *heightField;

@property (weak, nonatomic) IBOutlet UITextField *weightField;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation BasicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

-(void)setupUI
{
    self.containerView.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
    self.containerView.layer.borderWidth = 1.0f;
    self.containerView.layer.cornerRadius = 7.0f;
    
    self.nextBtn.layer.cornerRadius = 7.0f;
    
    self.navigationItem.title = @"基本信息";
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [[[UIAlertView alloc] initWithTitle:@"你好" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil] show];
    return NO;
}

- (IBAction)nextBtnClicke:(id)sender
{
    QuestionOneBtnController *vc = [[QuestionOneBtnController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
