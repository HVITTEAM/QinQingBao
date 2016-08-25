//
//  BasicViewController.m
//  Healthy
//
//  Created by shi on 16/7/11.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "BasicViewController.h"
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
    
    self.title = questionItem.eq_subtitle;
    item1 = questionItem.questions[0];
    item2 = questionItem.questions[1];
    item3 = questionItem.questions[2];
    self.titleLab.text = questionItem.eq_title;
    self.subtitleLab.text = questionItem.eq_subtitle;
    
    self.lab1.text = item1.q_title;
    
    self.lab2.text = item2.q_title;
    
    self.lab3.text = item3.q_title;
    
    self.headImg.image = self.headImgData;
    
    [self initdata];
}

/**
 *  初始化数据
 */
-(void)initdata
{
    for (NSMutableDictionary *dictItem in [self.answerProvider copy])
    {
        if ([[dictItem objectForKey:@"q_id"] isEqualToString:item1.q_id])
        {
            self.ageField.text = [dictItem objectForKey:@"qa_detail"];
        }
        else if ([[dictItem objectForKey:@"q_id"] isEqualToString:item2.q_id])
        {
            self.heightField.text = [dictItem objectForKey:@"qa_detail"];
        }
        else if ([[dictItem objectForKey:@"q_id"] isEqualToString:item3.q_id])
        {
           self.weightField.text = [dictItem objectForKey:@"qa_detail"];
        }
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CommonRulerViewController *vc = [[CommonRulerViewController alloc] init];
    vc.headImgData = self.headImgData;
    if (textField == self.ageField)
    {
        [vc initWithTitle:@"年龄" startValue:1 currentValue:self.ageField.text && self.ageField.text.length > 0 ? [self.ageField.text integerValue] : 25 count:110 unit:@"岁"];
        vc.selectedResult = ^(CGFloat value){
            NSLog(@"%.0f",value);
            self.ageField.text = [NSString stringWithFormat:@"%.0f岁",value];
            selectedAge = value;
        };
    }
    else if (textField == self.heightField)
    {
        [vc initWithTitle:@"身高" startValue:100 currentValue:self.heightField.text && self.heightField.text.length > 0? [self.heightField.text integerValue] : 165 count:120 unit:@"cm"];
        vc.selectedResult = ^(CGFloat value){
            NSLog(@"%.0fcm",value);
            self.heightField.text = [NSString stringWithFormat:@"%.0fcm",value];
            selectedHeight = value;
        };
    }
    else if (textField == self.weightField)
    {
        [vc initWithTitle:@"体重" startValue:40 currentValue:self.weightField.text && self.weightField.text.length > 0? [self.weightField.text integerValue] :65 count:150 unit:@"kg"];
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
    if ( self.ageField.text.length == 0)
    {
        return [NoticeHelper AlertShow:@"请填写年龄" view:nil];
    }
    if ( self.heightField.text.length == 0)
    {
        return [NoticeHelper AlertShow:@"请填写身高" view:nil];
    }
    if ( self.weightField.text.length == 0)
    {
        return [NoticeHelper AlertShow:@"请填写体重" view:nil];
    }
    
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
            [dictItem setObject:[NSString stringWithFormat:@"%.0f",selectedHeight] forKey:@"qa_detail"];
            break;
        }
    }
    if (!find1)
    {
        NSMutableDictionary * dict2 = [[NSMutableDictionary alloc] init];
        [dict2 setObject:item2.q_id forKey:@"q_id"];
        [dict2 setValue:item2.q_type forKey:@"q_type"];
        [dict2 setObject:selectedHeight > 0 ? [NSString stringWithFormat:@"%.0f",selectedHeight] : @"170" forKey:@"qa_detail"];
        [self.answerProvider addObject:dict2];
    }
    
    //查找第三个
    //是否已经添加到数据源中
    BOOL find2 = false;
    for (NSMutableDictionary *dictItem in array)
    {
        if ([[dictItem objectForKey:@"q_id"] isEqualToString:item3.q_id])
        {
            find2 = YES;
            [dictItem setObject:[NSString stringWithFormat:@"%.0f",selectedWeight] forKey:@"qa_detail"];
            break;
        }
    }
    if (!find2)
    {
        NSMutableDictionary *dict3 = [[NSMutableDictionary alloc] init];
        [dict3 setObject:item3.q_id forKey:@"q_id"];
        [dict3 setValue:item3.q_type forKey:@"q_type"];
        [dict3 setObject:selectedWeight > 0 ? [NSString stringWithFormat:@"%.0f",selectedWeight] : @"60" forKey:@"qa_detail"];
        [self.answerProvider addObject:dict3];
    }
    
    WaistHipRatioViewController *vc = [[WaistHipRatioViewController alloc] init];
    vc.dataProvider = self.dataProvider;
    vc.answerProvider = self.answerProvider;
    vc.exam_id = self.exam_id;
    vc.e_title = self.e_title;
    vc.calculatype = self.calculatype;
    
    [self.navigationController pushViewController:vc animated:YES];
}
@end
