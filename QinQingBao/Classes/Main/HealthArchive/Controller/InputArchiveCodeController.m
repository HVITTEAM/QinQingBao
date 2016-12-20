//
//  InputArchiveCodeController.m
//  QinQingBao
//
//  Created by shi on 2016/11/29.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "InputArchiveCodeController.h"


@interface InputArchiveCodeController ()
{
    float timesec;
    
    NSString *btnTitle;
    
    NSTimer *timer;
}
@property (strong, nonatomic) IBOutlet UITextField *telTextfield;
@property (strong, nonatomic) IBOutlet UITextField *codeTextfield;
@property (strong, nonatomic) IBOutlet UIButton *confirmBtn;
@property (strong, nonatomic) IBOutlet UIButton *codeBtn;

- (IBAction)getCodeHandler:(id)sender;
- (IBAction)okHandler:(id)sender;

@end

@implementation InputArchiveCodeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.confirmBtn.layer.cornerRadius = 7;
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.navigationItem.title = @"绑定";
}


/**
 *  获取验证码
 */
- (IBAction)getCodeHandler:(id)sender {
    if (self.telTextfield.text.length != 11)
        return [NoticeHelper AlertShow:@"请输入正确的手机号！" view:self.view];
    [self.view endEditing:YES];
    [[MTSMSHelper sharedInstance] getCheckcode:self.telTextfield.text];
    [MTSMSHelper sharedInstance].sureSendSMS = ^{
        [NoticeHelper AlertShow:@"验证码发送成功,请查收！" view:self.view];
        [self countdownHandler];
    };

}

- (IBAction)okHandler:(id)sender {
    NSString *code = self.codeTextfield.text;
    
    if (code.length <= 0) {
        return [NoticeHelper AlertShow:@"请输入验证码" view:nil];
    }
    
    [self addArchiveWhitCode:code];
}


#pragma mark 倒计时模块

/**
 *  倒计时
 */
-(void)countdownHandler
{
    timesec = 60.0f;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
}

-(void)timerFireMethod:(NSTimer *)theTimer
{
    if (timesec == 1) {
        [theTimer invalidate];
        timesec = 60;
        [self.codeBtn setTitle:@"获取验证码" forState: UIControlStateNormal];
        [self.codeBtn setTitleColor:HMColor(69, 134, 229) forState:UIControlStateNormal];
        [self.codeBtn setEnabled:YES];
    }else
    {
        timesec--;
        NSString *title = [NSString stringWithFormat:@"%.f秒后重发",timesec];
        [self.codeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [self.codeBtn setEnabled:NO];
        [self.codeBtn setTitle:title forState:UIControlStateNormal];
    }
}


/**
 * 通过输入手机号码添加档案
 */
-(void)addArchiveWhitCode:(NSString *)code
{
    NSDictionary *params = @{ @"client":@"ios",
                              @"key":[SharedAppUtil defaultCommonUtil].userVO.key,
                              @"code":code,
                              @"mobile":self.telTextfield.text};
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Bingding_fm parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        [hud removeFromSuperview];
        
        if ([dict[@"code"] integerValue] != 0) {
            return [NoticeHelper AlertShow:dict[@"errorMsg"] view:self.view];
        }
        [MTNotificationCenter postNotificationName:MTRefleshData object:nil];
        
        NSArray *vcs = self.navigationController.viewControllers;
        UIViewController *vc = vcs[vcs.count - 3];
        
        [self.navigationController popToViewController:vc animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud removeFromSuperview];
        [NoticeHelper AlertShow:MTServiceError view:nil];
    }];
}

@end
