//
//  SexViewController.m
//  Healthy
//
//  Created by shi on 16/7/11.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "SexViewController.h"
#import "BasicViewController.h"

@interface SexViewController ()

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation SexViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.nextBtn.layer.cornerRadius = 7.0f;
    self.navigationItem.title = @"性别";
}

- (IBAction)nextBtnClicke:(id)sender
{
    BasicViewController *vc = [[BasicViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
