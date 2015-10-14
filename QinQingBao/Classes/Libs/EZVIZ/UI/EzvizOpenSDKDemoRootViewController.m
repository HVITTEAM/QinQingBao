//
//  YSLoginViewController.m
//  EzvizRealPlayDemo
//
//  Created by Journey on 12/8/14.
//  Copyright (c) 2014 hikvision. All rights reserved.
//

#import "EzvizOpenSDKDemoRootViewController.h"

#import "YSHTTPClient.h"
#import "YSMobilePages.h"
#import "YSPlayerController.h"
#import "YSConstStrings.h"

#import "YSDemoDataModel.h"
#import "YSCheckSMSCodeViewController.h"
#import "CMyCameraListViewController.h"
#import "YSVideoSquareColumnViewController.h"

#import "EzvizJSON.h"

@interface EzvizOpenSDKDemoRootViewController () <UIAlertViewDelegate>{
    NSString *currentToken;
}

@property (weak, nonatomic) IBOutlet UIButton *btnSDKLogin;
@property (nonatomic, weak) IBOutlet UILabel *lblToken;
@property (weak, nonatomic) IBOutlet UIButton *btnVideoSquare;
@property (strong, nonatomic) YSMobilePages *page;

@end

@implementation EzvizOpenSDKDemoRootViewController


#pragma mark - LifeCycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"萤石开发平台SDK";
    
    self.page = [[YSMobilePages alloc] init];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.lblToken.text = [NSString stringWithFormat:@"已授权Token:%@",currentToken?:@""];
}

#pragma mark - UIAlertViewDelegate Methods



- (IBAction)clickOnLogin:(id)sender {
    [self login];
}

- (IBAction)clickOnCameraList:(id)sender {
    if([EzvizDemoGlobalKit sharedKit].token){
        [[YSDemoDataModel sharedInstance] saveUserAccessToken:[EzvizDemoGlobalKit sharedKit].token];
        [[YSHTTPClient sharedInstance] setClientAccessToken:[EzvizDemoGlobalKit sharedKit].token];
        
        [self pushCameraListController];
    }else{
//        [_page login:self.navigationController withAppKey:AppKey complition:^(NSString *accessToken) {
//            if (accessToken)
//            {
//                NSLog(@"Client access token is: %@", accessToken);
//                [EzvizGlobalKit sharedKit].token = accessToken;
//                [[YSDemoDataModel sharedInstance] saveUserAccessToken:accessToken];
//                [[YSHTTPClient sharedInstance] setClientAccessToken:accessToken];
//            }
//            
//            [self.navigationController popViewControllerAnimated:NO];
//            
//            [self pushCameraListController];
//        }];
        [_page login:self completion:^(NSString *accessToken) {
            if (accessToken)
            {
                NSLog(@"Client access token is: %@", accessToken);
                [EzvizDemoGlobalKit sharedKit].token = accessToken;
                [[YSDemoDataModel sharedInstance] saveUserAccessToken:accessToken];
                [[YSHTTPClient sharedInstance] setClientAccessToken:accessToken];
                [self pushCameraListController];
            }
        }];
    }
}

- (IBAction)clickVideoSquare:(id)sender {
    [UIViewController go2SquareListViewController:self];
}


- (void)login
{
//    NSString *pbApiKey = @"99bec62406534c6787323575c87d5ef4";
//    NSString *testApiKey = @"e503c597aba04b5487a3d06572a4bbe4";
//    NSString *openApiKey = @"8698d52f6ac34929b5286698fe7a10e8";
//    NSString *test_1_apiKey = @"c279ded87d3f4fdca7658f95fb5f1d9e";
    
//    [_page login:self.navigationController withAppKey:AppKey complition:^(NSString *accessToken) {
//        if (accessToken)
//        {
//            NSLog(@"Client access token is: %@", accessToken);
//            [EzvizGlobalKit sharedKit].token = accessToken;
//            [[YSDemoDataModel sharedInstance] saveUserAccessToken:accessToken];
//            [[YSHTTPClient sharedInstance] setClientAccessToken:accessToken];
//        }
//        
//        [self.navigationController popViewControllerAnimated:NO];
//        
//        [self pushCameraListController];
//    }];
    
    [_page login:self completion:^(NSString *accessToken) {
        if (accessToken)
        {
            NSLog(@"Client access token is: %@", accessToken);
            [EzvizDemoGlobalKit sharedKit].token = accessToken;
            [[YSDemoDataModel sharedInstance] saveUserAccessToken:accessToken];
            [[YSHTTPClient sharedInstance] setClientAccessToken:accessToken];
            [self pushCameraListController];
        }
    }];
}

- (void)pushCameraListController
{
    CMyCameraListViewController *controller = [[CMyCameraListViewController alloc] initWithNibName:@"CMyCameraListViewController"
                                                                                            bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *accessToken = [alertView textFieldAtIndex:0].text;
    
    if (0 == [accessToken length]) {
        return;
    }
    
    [[YSDemoDataModel sharedInstance] saveUserAccessToken:accessToken];
    [[YSHTTPClient sharedInstance] setClientAccessToken:accessToken];
    
    [self pushCameraListController];
}

- (IBAction)transfer:(id)sender{
    
    [UIViewController go2TransferDemoViewController:self];
//    EzvizMessageInfo *info = [EzvizMessageInfo instanceWithIP:@"112.16.94.27" port:32723 fileId:@"6187615f-4305-4179-ad10-5e1f5f56c2c2" sessionId:@"190a9c156491455381e82dadadb6a950"];
//    for (int i = 0; i < 10; i++) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
//            [[EzvizMessageKit sharedKit] getMessageData:info
//                                                message:^(NSData *data, int resultCode) {
//                                                    NSLog(@"data = %@, resultCode = %d",data, resultCode);
//                                                }];
//        });
//    }
}

- (IBAction)go2FindDevice:(id)sender{
    [UIViewController go2WifiInfoViewController:self];
}

@end
