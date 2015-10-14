
//  YSCheckSMSCodeViewController.m
//  EzvizRealPlayDemo
//
//  Created by Journey on 12/8/14.
//  Copyright (c) 2014 hikvision. All rights reserved.
//

#import "YSCheckSMSCodeViewController.h"
#import "YSHTTPClient.h"
#import "EzvizJSON.h"
#import "MBProgressHUD.h"

@interface YSCheckSMSCodeViewController () <UIAlertViewDelegate>


@property (weak, nonatomic) IBOutlet UITextField *txtSign;
@property (nonatomic, weak) IBOutlet UIButton *btnValidateCode;
@property (nonatomic, weak) IBOutlet UIButton *btnCompletion;
@property (weak, nonatomic) IBOutlet UITextField *txtSmsCode;

@end

@implementation YSCheckSMSCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:@[@"开通服务",@"安全验证"]];
    [control addTarget:self action:@selector(selectIndex:) forControlEvents:UIControlEventValueChanged];
    control.selectedSegmentIndex = 0;
    self.navigationItem.titleView = control;
    
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

- (IBAction)validateCode:(id)sender{
    if(self.type == ScheduleCheck){
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params setObject:@"msg/smsCode/secure" forKey:@"method"];
        [params setObject:@{@"accessToken":[EzvizDemoGlobalKit sharedKit].token?:@""} forKey:@"params"];
        NSString *transferString = [params ezvizJSONString];
        [[YSHTTPClient sharedInstance] requestTransferWithReqStr:transferString
                                                      completion:^(id responseObject, NSError *error) {
                                                          NSLog(@"responseObject msg= %@",responseObject[@"result"][@"msg"]);
                                                          [self setHUD:[NSString stringWithFormat:@"%@%@", responseObject[@"result"][@"code"],responseObject[@"result"][@"msg"]]];
                                                          
                                                      }];
    }else{
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params setObject:@"msg/smsCode/openYSService" forKey:@"method"];
        [params setObject:@{@"phone":self.txtSign.text?:@""} forKey:@"params"];
        NSString *transferString = [params ezvizJSONString];
        [[YSHTTPClient sharedInstance] requestTransferWithReqStr:transferString
                                                      completion:^(id responseObject, NSError *error) {
                                                          NSLog(@"responseObject msg= %@",responseObject[@"result"][@"msg"]);
                                                          [self setHUD:[NSString stringWithFormat:@"%@%@", responseObject[@"result"][@"code"],responseObject[@"result"][@"msg"]]];
                                                      }];
    }
}

- (IBAction)sendResult:(id)sender{
    if(self.type == ScheduleCheck){
        
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params setObject:@"msg/sdk/secureValidate" forKey:@"method"];
        [params setObject:@{@"accessToken":[EzvizDemoGlobalKit sharedKit].token?:@"",
                            @"smsCode":self.txtSmsCode.text?:@""}
                   forKey:@"params"];
        [[YSHTTPClient sharedInstance] requestTransferWithReqStr:[params ezvizJSONString]
                                                      completion:^(id responseObject, NSError *error) {
                                                          NSLog(@"responseObject msg= %@",responseObject[@"result"][@"msg"]);
                                                          [self setHUD:[NSString stringWithFormat:@"%@%@", responseObject[@"result"][@"code"],responseObject[@"result"][@"msg"]]];
                                                      }];
    }
    else{
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params setObject:@"user/sdk/openYSService" forKey:@"method"];
        [params setObject:@{@"phone":self.txtSign.text?:@"",
                            @"smsCode":self.txtSmsCode.text?:@""}
                   forKey:@"params"];
        NSString *transferString = [params ezvizJSONString];
        [[YSHTTPClient sharedInstance] requestTransferWithReqStr:transferString
                                                      completion:^(id responseObject, NSError *error) {
                                                          NSLog(@"responseObject msg= %@",responseObject[@"result"][@"msg"]);
                                                          [self setHUD:[NSString stringWithFormat:@"%@%@", responseObject[@"result"][@"code"],responseObject[@"result"][@"msg"]]];
                                                      }];
    }
}

- (void)selectIndex:(id)sender{
    self.txtSign.hidden = NO;
    if([sender selectedSegmentIndex] == 0){
        self.type = RegisterCheck;
    }else{
        self.type = ScheduleCheck;
        if(self.type == ScheduleCheck){
            self.txtSign.hidden = YES;
        }
    }
}

- (void)setHUD:(NSString *)text{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    [hud hide:YES afterDelay:1.0f];
}

@end
