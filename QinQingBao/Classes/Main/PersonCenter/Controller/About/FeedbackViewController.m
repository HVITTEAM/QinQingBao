//
//  FeedbackViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/12/22.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = HMGlobalBg;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submitHandler)];
    
    self.contentText.layer.borderColor = [[UIColor colorWithRGB:@"979797"] CGColor];
    self.contentText.layer.borderWidth = 0.5f;
    
}

-(void)submitHandler
{
    if (self.contentText.text.length == 0)
        return [NoticeHelper AlertShow:@"请认真填写您的意见和建议" view:self.view];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Feedback parameters:  @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                  @"client" : @"ios",
                                                                  @"content" : self.contentText.text}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     [HUD removeFromSuperview];
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         [self.navigationController popViewControllerAnimated:YES];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                 }];
    
}


@end
