//
//  QuestionThreeController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/7/12.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "QuestionThreeController.h"

#import "QuestionResultController.h"


@interface QuestionThreeController ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    
}

@property (strong, nonatomic) IBOutlet UIPickerView *rightPicker;

@property (strong, nonatomic) IBOutlet UIPickerView *leftPicker;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@end

@implementation QuestionThreeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
    
    self.leftPicker.delegate = self;
    self.rightPicker.delegate = self;
    self.rightPicker.dataSource = self;
    self.leftPicker.dataSource = self;
    
    [self.leftPicker selectRow:3 inComponent:0 animated:YES];
    [self.rightPicker selectRow:3 inComponent:0 animated:YES];
}

-(void)setupUI
{
    [self setupView:self.containerView];
    
    self.nextBtn.layer.cornerRadius = 7.0f;
    
    self.navigationItem.title = @"病";
}

- (IBAction)nextBtnClicke:(id)sender
{
    QuestionResultController *vc = [[QuestionResultController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setupView:(UIView *)v
{
    v.layer.borderWidth = 1.0f;
    v.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
    v.layer.cornerRadius = 7.0f;
}

#pragma mark UIPickerViewDelegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 10;
}

//-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 23;
}

-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    // NSLog(@"%ld",pickerView.subviews.count);
    // [[pickerView.subviews objectAtIndex:1] setHidden:TRUE];
    // [[pickerView.subviews objectAtIndex:2] setHidden:TRUE];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.width, 35)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"173cm";
    lab.font = [UIFont systemFontOfSize:14];
    lab.textColor = [UIColor orangeColor];
    return lab;
}

@end
