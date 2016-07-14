//
//  CXPickerViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/6/29.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CXPickerViewController.h"

#import <STPopup/STPopup.h>

@interface CXPickerViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
}
- (IBAction)okHandler:(id)sender;
- (IBAction)cancelHandler:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *okBtn;
@property (strong, nonatomic) IBOutlet UIPickerView *pickview;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@end

@implementation CXPickerViewController
{
    
}

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"腰围";
        self.contentSizeInPopup = CGSizeMake(250, 190);
        self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = nil;
    
    _pickview.dataSource = self;
    _pickview.delegate = self;
    [_pickview selectRow:3 inComponent:0 animated:YES];
    self.okBtn.titleLabel.textColor = HMColor(121, 187, 48);
    self.cancelBtn.titleLabel.textColor = [UIColor lightGrayColor];

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}


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
    return 40;
}

-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    // NSLog(@"%ld",pickerView.subviews.count);
    // [[pickerView.subviews objectAtIndex:1] setHidden:TRUE];
    // [[pickerView.subviews objectAtIndex:2] setHidden:TRUE];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.width, 35)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"173cm";
    lab.font = [UIFont systemFontOfSize:18];
    lab.textColor = HMColor(121, 187, 48);
    return lab;
}


- (IBAction)okHandler:(id)sender {
}

- (IBAction)cancelHandler:(id)sender {
    [self.popupController dismiss];

}
@end
