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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fieldHeightCon;

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
    
    CGFloat heightCon = 45;
    if (MTScreenW <= 320) {
        heightCon *= 1;
    }else if (MTScreenW == 375){
        heightCon *= 1.17;
    }else if (MTScreenW == 414){
        heightCon *= 1.29;
    }
    
    self.fieldHeightCon.constant = heightCon;
    
    questionItem = self.dataProvider[1];
    
    self.title = questionItem.eq_title;
    self.titleLab.text = questionItem.eq_title;
    item1 = questionItem.questions[0];
    //BMI "BMI=体重（公斤）\/身高（米）的平方，即kg\/m²"
    item2 = questionItem.questions[1];
    item3 = questionItem.questions[1];
    self.subtitleLab.text = item2.q_subtitle;

    self.lab1.text = item1.q_title;
    
    self.lab2.text = @"您的身高";
    
    self.lab3.text = @"您的体重";
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CommonRulerViewController *vc = [[CommonRulerViewController alloc] init];
    if (textField == self.ageField)
    {
        [vc initWithTitle:@"年龄" startValue:1900 currentValue:1990 count:110 unit:@"年"];
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
    NSArray * array = [NSArray arrayWithArray:[self.answerProvider copy]];
    
    //是否已经添加到数据源中
    BOOL find = false;
    //查找第一个
    for (NSMutableDictionary *dictItem in array)
    {
        if ([[dictItem objectForKey:@"q_id"] isEqualToString:item1.q_id])
        {
            find = YES;
            [dictItem setObject:[NSString stringWithFormat:@"%.0f",selectedAge] forKey:@"qa_detail"];
            break;
        }
    }
    if (!find)
    {
        NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
        [dict1 setObject:item1.q_id forKey:@"q_id"];
        [dict1 setValue:item1.q_type forKey:@"q_type"];
        [dict1 setObject:selectedAge > 0 ? [NSString stringWithFormat:@"%.0f",selectedAge] : @"1980" forKey:@"qa_detail"];
        [self.answerProvider addObject:dict1];
    }
    
    //查找第二个
    
    //是否已经添加到数据源中
    BOOL find1 = false;
    for (NSMutableDictionary *dictItem in array)
    {
    
        if ([[dictItem objectForKey:@"q_id"] isEqualToString:item2.q_id])
        {
            find1 = YES;
            CGFloat BMI = selectedWeight/(selectedHeight/100 *selectedHeight/100);
            [dictItem setObject:[NSString stringWithFormat:@"%.01f",BMI] forKey:@"qa_detail"];
            break;
        }
    }
    if (!find1)
    {
        NSMutableDictionary * dict2 = [[NSMutableDictionary alloc] init];
        [dict2 setObject:item2.q_id forKey:@"q_id"];
        [dict2 setValue:item2.q_type forKey:@"q_type"];
        
        if (selectedWeight <= 0 )selectedWeight = 65;
        if (selectedHeight <= 0 )selectedHeight = 170;

        CGFloat BMI = selectedWeight/(selectedHeight/100 *selectedHeight/100);
        [dict2 setObject:[NSString stringWithFormat:@"%.01f",BMI] forKey:@"qa_detail"];
        [self.answerProvider addObject:dict2];
    }
    
    //查找第三个
    //是否已经添加到数据源中
//    BOOL find2 = false;
//    for (NSMutableDictionary *dictItem in array)
//    {
//        if ([[dictItem objectForKey:@"q_id"] isEqualToString:item3.q_id])
//        {
//            find2 = YES;
//            [dictItem setObject:[NSString stringWithFormat:@"%.0f",selectedWeight] forKey:@"qa_detail"];
//            break;
//        }
//    }
//    if (!find2)
//    {
//        NSMutableDictionary *dict3 = [[NSMutableDictionary alloc] init];
//        [dict3 setObject:item3.q_id forKey:@"q_id"];
//        [dict3 setObject:selectedWeight > 0 ? [NSString stringWithFormat:@"%.0f",selectedWeight] : @"60" forKey:@"qa_detail"];
//        [self.answerProvider addObject:dict3];
//    }
    
    WaistHipRatioViewController *vc = [[WaistHipRatioViewController alloc] init];
    vc.dataProvider = self.dataProvider;
    vc.answerProvider = self.answerProvider;
    vc.exam_id = self.exam_id;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
