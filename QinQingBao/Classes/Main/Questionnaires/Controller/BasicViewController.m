//
//  BasicViewController.m
//  Healthy
//
//  Created by shi on 16/7/11.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "BasicViewController.h"
#import "QuestionBtnViewController.h"
#import "QuestionModel_1.h"
#import "CommonRulerViewController.h"
#import "WaistHipRatioViewController.h"

@interface BasicViewController ()<UITextFieldDelegate>
{
    NSArray *dataProvider;
    
    QuestionModel_1 *item1;
    QuestionModel_1 *item2;
    QuestionModel_1 *item3;
}
@property (strong, nonatomic) IBOutlet UIImageView *headImg;

@property (strong, nonatomic) IBOutlet UILabel *titleLab;

@property (strong, nonatomic) IBOutlet UILabel *subtitleLab;

@property (strong, nonatomic) IBOutlet UILabel *lab1;

@property (strong, nonatomic) IBOutlet UILabel *lab2;

@property (strong, nonatomic) IBOutlet UILabel *lab3;

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
    
    [self setupUI];
}

-(void)setupUI
{
    self.containerView.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
    self.containerView.layer.borderWidth = 1.0f;
    self.containerView.layer.cornerRadius = 7.0f;
    
    self.nextBtn.layer.cornerRadius = 7.0f;
    
    self.navigationItem.title = @"基本信息";
    
    self.titleLab.text = self.questionItem.eq_title;
    item1 = self.questionItem.questions[0];
    item2 = self.questionItem.questions[1];
    item3 = self.questionItem.questions[2];
    
    self.lab1.text = item1.q_title;
    self.lab2.text = item2.q_title;
    self.lab3.text = item3.q_title;
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CommonRulerViewController *vc = [[CommonRulerViewController alloc] init];
    if (textField == self.ageField)
    {
        [vc initWithTitle:@"年龄" startValue:1900 currentValue:2016 count:150 unit:@"年"];

    }
    else if (textField == self.heightField)
    {
        [vc initWithTitle:@"身高" startValue:100 currentValue:165 count:120 unit:@"cm"];

    }
    else if (textField == self.weightField)
    {
        [vc initWithTitle:@"体重" startValue:40 currentValue:65 count:150 unit:@"kg"];

    }

    vc.selectedResult = ^(CGFloat value){
        NSLog(@"%f",value);
    };
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}

- (IBAction)nextBtnClicke:(id)sender
{
    WaistHipRatioViewController *vc = [[WaistHipRatioViewController alloc] init];
//    vc.isMultipleSelection = YES;
//    vc.isTwo = NO;
//    vc.btnHeight = 45;
//    vc.datas = @[@"a0",@"a1",@"a2",@"a3",@"a0",@"a1",@"a2",@"a3"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
