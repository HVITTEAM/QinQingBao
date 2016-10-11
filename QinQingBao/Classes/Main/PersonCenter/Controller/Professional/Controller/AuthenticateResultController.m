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
    
    self.reApplyBtn.layer.cornerRadius = 7.0f;
    self.reasonContainerView.layer.cornerRadius = 3.0f;
    self.reasonContainerView.layer.borderWidth = 1.0f;
    self.reasonContainerView.layer.borderColor = HMColor(245, 240, 235).CGColor;
    self.reasonContainerView.layer.masksToBounds = YES;
    
    
    if (self.isSuccess) {
        self.reasonContainerView.hidden = YES;
        self.reApplyBtn.hidden = YES;
        self.resultLb.text = @"申请成功";
    }else{
        self.reasonContainerView.hidden = NO;
        self.reApplyBtn.hidden = NO;
        self.resultLb.text = @"申请失败";
        self.reasonLb.text = self.reason;
    }

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.iconView.layer.cornerRadius = self.iconView.width / 2;
    self.iconView.layer.masksToBounds = YES;
}

- (IBAction)ReApplyAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
