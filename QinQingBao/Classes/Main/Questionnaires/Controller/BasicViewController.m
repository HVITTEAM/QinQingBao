//
//  BasicViewController.m
//  Healthy
//
//  Created by shi on 16/7/11.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "BasicViewController.h"
#import "QuestionBtnViewController.h"
#import "CommonRulerViewController.h"
#import "WaistHipRatioViewController.h"

@interface BasicViewController ()<UITextFieldDelegate>
{
    QuestionModel *questionItem;
    
    QuestionModel_1 *item1;
    QuestionModel_1 *item2;
    QuestionModel_1 *item3;
    
    CGFloat selectedAge;
    CGFloat selectedHeight;
    CGFloat selectedWeight;
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
    
    questionItem = self.dataProvider[1];
    self.titleLab.text = questionItem.eq_title;
    item1 = questionItem.questions[0];
    item2 = questionItem.questions[1];
    item3 = questionItem.questions[2];
    
    self.lab1.text = item1.q_title;
    self.lab1.tag = [item1.q_id integerValue];
    
    self.lab2.text = item2.q_title;
    self.lab2.tag = [item2.q_id integerValue];
    
    self.lab3.text = item3.q_title;
    self.lab3.tag = [item3.q_id integerValue];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CommonRulerViewController *vc = [[CommonRulerViewController alloc] init];
    if (textField == self.ageField)
    {
        [vc initWithTitle:@"年龄" startValue:1900 currentValue:2016 count:150 unit:@"年"];
        vc.selectedResult = ^(CGFloat value){
            NSLog(@"%.0f",value);
            self.ageField.text = [NSString stringWithFormat:@"%.0f年",value];
            selectedAge = value;
        };
    }
    else if (textField == self.heightField)
    {
        [vc initWithTitle:@"身高" startValue:100 currentValue:165 count:120 unit:@"cm"];
        vc.selectedResult = ^(CGFloat value){
            NSLog(@"%.0fcm",value);
            self.heightField.text = [NSString stringWithFormat:@"%.0fcm",value];
            selectedHeight = value;
        };
    }
    else if (textField == self.weightField)
    {
        [vc initWithTitle:@"体重" startValue:40 currentValue:65 count:150 unit:@"kg"];
        vc.selectedResult = ^(CGFloat value){
            NSLog(@"%.0fkg",value);
            self.weightField.text = [NSString stringWithFormat:@"%.0fkg",value];
            selectedWeight = value;
        };
    }
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}

- (IBAction)nextBtnClicke:(id)sender
{
    //先找茬数据源，如果数据源中存在了对应的key，就说明之前已经保存过，只需要更改值就可以
    if (self.answerProvider.count > 1)
    {
        NSMutableDictionary *dict = self.answerProvider[1];
        [dict setObject:[NSString stringWithFormat:@"%.0f",selectedAge] forKey:@"qa_detail"];
    }
    else
    {
        NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
        [dict1 setObject:[NSString stringWithFormat:@"%ld",(long)self.lab1.tag] forKey:@"q_id"];
        [dict1 setObject:selectedAge > 0 ? [NSString stringWithFormat:@"%.0f",selectedAge] : @"1980" forKey:@"qa_detail"];
        [self.answerProvider addObject:dict1];
    }
    
    if (self.answerProvider.count > 2)
    {
        NSMutableDictionary *dict1 = self.answerProvider[2];
        
        [dict1 setObject:[NSString stringWithFormat:@"%.0f",selectedHeight] forKey:@"qa_detail"];
    }
    else
    {
        NSMutableDictionary * dict2 = [[NSMutableDictionary alloc] init];
        [dict2 setObject:[NSString stringWithFormat:@"%ld",(long)self.lab2.tag] forKey:@"q_id"];
        [dict2 setObject:selectedHeight > 0 ? [NSString stringWithFormat:@"%.0f",selectedHeight] : @"170" forKey:@"qa_detail"];
        [self.answerProvider addObject:dict2];
    }
    
    if (self.answerProvider.count > 3)
    {
        NSMutableDictionary *dict2 = self.answerProvider[3];
        [dict2 setObject:[NSString stringWithFormat:@"%.0f",selectedWeight] forKey:@"qa_detail"];
    }
    else
    {
        NSMutableDictionary *dict3 = [[NSMutableDictionary alloc] init];
        [dict3 setObject:[NSString stringWithFormat:@"%ld",(long)self.lab3.tag] forKey:@"q_id"];
        [dict3 setObject:selectedWeight > 0 ? [NSString stringWithFormat:@"%.0f",selectedWeight] : @"60" forKey:@"qa_detail"];
        [self.answerProvider addObject:dict3];
    }
    
    WaistHipRatioViewController *vc = [[WaistHipRatioViewController alloc] init];
    vc.dataProvider = self.dataProvider;
    vc.answerProvider = self.answerProvider;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
