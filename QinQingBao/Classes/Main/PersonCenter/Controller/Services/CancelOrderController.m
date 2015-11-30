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


- (IBAction)cancelBtnClickHandler:(id)sender
{
    [CommonRemoteHelper RemoteWithUrl:URL_Del_workinfo_by_wid parameters:  @{@"wid" : self.orderItem.wid,
                                                                             @"cont" : self.cancelReasonText.text,
                                                                             @"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                             @"client" : @"ios",
                                                                             }
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         [NoticeHelper AlertShow:@"操作成功!" view:self.view];
                                         [self.navigationController popToRootViewControllerAnimated:YES];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [NoticeHelper AlertShow:@"获取失败!" view:self.view];
                                 }];
    
}
@end
