//
//  AuthenticateResultController.m
//  QinQingBao
//
//  Created by shi on 16/10/10.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "AuthenticateResultController.h"

@interface AuthenticateResultController ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *resultLb;

@property (weak, nonatomic) IBOutlet UILabel *reasonLb;

@property (weak, nonatomic) IBOutlet UIButton *reApplyBtn;

@property (weak, nonatomic) IBOutlet UIView *reasonContainerView;

@end

@implementation AuthenticateResultController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.navigationItem.title = @"申请专家认证";
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_black"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.reApplyBtn.layer.cornerRadius = 7.0f;
    self.reApplyBtn.layer.borderColor = HMColor(230, 230, 230).CGColor;
    self.reApplyBtn.layer.borderWidth = 1.0f;
    
    self.reasonContainerView.layer.cornerRadius = 3.0f;
    self.reasonContainerView.layer.borderWidth = 1.0f;
    self.reasonContainerView.layer.borderColor = HMColor(245, 240, 235).CGColor;
    self.reasonContainerView.layer.masksToBounds = YES;
    
    if (self.isSuccess) {
        self.reasonContainerView.hidden = YES;
        self.reApplyBtn.hidden = YES;
        self.resultLb.text = self.msg;
        self.iconView.image = [UIImage imageNamed:@"pass"];
    }else{
        self.reasonContainerView.hidden = NO;
        self.reApplyBtn.hidden = NO;
        self.resultLb.text = self.msg;
        self.reasonLb.text = self.reason;
        self.iconView.image = [UIImage imageNamed:@"noPass"];
    }

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.iconView.layer.cornerRadius = self.iconView.width / 2;
    self.iconView.layer.masksToBounds = YES;
}

- (void)back
{
    if (self.isSuccess) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)ReApplyAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
