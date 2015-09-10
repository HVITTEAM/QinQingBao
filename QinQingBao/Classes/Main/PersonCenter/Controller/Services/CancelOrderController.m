//
//  CancelOrderController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/10.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "CancelOrderController.h"

@interface CancelOrderController ()

@end

@implementation CancelOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"取消订单";
    self.cancelReasonText.layer.borderColor = [HMGlobalBg CGColor];
    self.cancelReasonText.layer.borderWidth = 1;
    self.cancelReasonText.layer.cornerRadius = 3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelBtnClickHandler:(id)sender {
}
@end
