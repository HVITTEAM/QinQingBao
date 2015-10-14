
//  YSCheckSMSCodeViewController.m
//  EzvizRealPlayDemo
//
//  Created by Journey on 12/8/14.
//  Copyright (c) 2014 hikvision. All rights reserved.
//

#import "YSCheckSMSCodeViewController.h"

#import "YSHTTPClient.h"

#import "YSDemoDataModel.h"
//#import "CMyCameraListViewController.h"
#import "CAttention.h"

@interface YSCheckSMSCodeViewController () <UIAlertViewDelegate>

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@property (retain, nonatomic) IBOutlet UITextField *txtSign;

@property (retain, nonatomic) IBOutlet UITextField *txtSmsCode;

@property (retain, nonatomic) IBOutlet UITextField *txtUserId;

@property (retain, nonatomic) IBOutlet UITextField *txtPhone;
@property (retain, nonatomic) IBOutlet UITextField *txtToken;

@end

@implementation YSCheckSMSCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width,
                                           self.view.frame.size.height * 1.5)];
    
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


- (IBAction)clickOnGetSmsCode:(id)sender {
    
    MBProgressHUD *hud = [CAttention loadingViewWithText:@"请稍候..." toView:self.view];
    
//    _txtSign.text = @"{"
//    "\"id\": \"123456\","
//    "\"system\": {"
//    "\"sign\": \"a0a27b576f461308bf534d1c5b882521\","
//    "\"time\": 1418644209,"
//    "\"ver\": \"1.0\","
//    "\"key\": \"c279ded87d3f4fdca7658f95fb5f1d9e\""
//    "},"
//    "\"method\": \"msg/get\","
//    "\"params\": {"
//    "\"type\": 1,"
//    "\"userId\": \"999999\","
//    "\"phone\": \"15658086255\""
//    "}"
//    "}";

    [[YSHTTPClient sharedInstance] requestGetSMSVerificationCodeWithSign:_txtSign.text
                                                            complication:^(id responseObject, NSError *error) {
                                                                [CAttention hiddenWaitView:hud];
                                                                if (responseObject)
                                                                {
                                                                    NSDictionary *dict = (NSDictionary *)responseObject;
                                                                    if (dict)
                                                                    {
                                                                        NSDictionary *result = [dict objectForKey:@"result"];
                                                                        int code = [[result objectForKey:@"code"] intValue];
                                                                        if (HTTP_REQUEST_OK_CODE == code)
                                                                        {
                                                                            [CAttention showAutoHiddenAttention:@"短信发送成功"
                                                                                                         toView:self.view];
                                                                            return;
                                                                        }
                                                                    }
                                                                    
                                                                    NSLog(@"get sms response: %@", responseObject);
                                                                }
                                                                
                                                                [CAttention showAutoHiddenAttention:@"短信发送失败"
                                                                                             toView:self.view];
                                                                
                                                            }];
}

- (IBAction)clickOnCheckSmsCode:(id)sender {
    MBProgressHUD *hud = [CAttention loadingViewWithText:@"请稍候..." toView:self.view];
    
    int typeValue;
    if (RegisteCheck == _type) {
        typeValue = 1; // 注册请求
    } else {
        typeValue = 2; // 验证请求
    }
    
    [[YSHTTPClient sharedInstance] requestCheckSMSVerificationCodeWithType:typeValue
                                                                   userId:_txtUserId.text
                                                              phoneNumber:_txtPhone.text
                                                         verificationCode:_txtSmsCode.text
                                                             complication:^(id responseObject, NSError *error) {
                                                                 NSLog(@"check sms code response: %@", responseObject);
                                                                 [CAttention hiddenWaitView:hud];

                                                                 if (responseObject)
                                                                 {
                                                                     NSDictionary *dict = (NSDictionary *)responseObject;
                                                                     if (dict)
                                                                     {
                                                                         NSDictionary *result = [dict objectForKey:@"result"];
                                                                         int code = [[result objectForKey:@"code"] intValue];
                                                                         if (HTTP_REQUEST_OK_CODE == code)
                                                                         {
                                                                             if (_type == RegisteCheck)
                                                                             {
                                                                                 [CAttention showAutoHiddenAttention:@"注册成功"
                                                                                                              toView:self.view];
                                                                                 
                                                                                 // 注册成功后, 开发者可以后台获取token, 然后进行接口调用
                                                                                 
                                                                                 return;
                                                                             }
                                                                             else if (_type == ScheduleCheck)
                                                                             {
                                                                                // 继续验证前的任务
                                                                                 [self.navigationController popViewControllerAnimated:YES];
                                                                                 return;
                                                                             }
                                                                         }
                                                                     }
                                                                 }
                                                                 
                                                                 [CAttention showAutoHiddenAttention:@"短信验证失败"
                                                                                              toView:self.view];

                                                             }];
}

- (void)pushCameraListController
{
//    CMyCameraListViewController *controller = [[CMyCameraListViewController alloc] initWithNibName:@"CMyCameraListViewController"
//                                                                                            bundle:nil];
//    [self.navigationController pushViewController:controller animated:YES];
}




@end
