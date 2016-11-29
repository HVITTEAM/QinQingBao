//
//  InputArchiveCodeController.m
//  QinQingBao
//
//  Created by shi on 2016/11/29.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "InputArchiveCodeController.h"

@interface InputArchiveCodeController ()

@end

@implementation InputArchiveCodeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cancelBtn.layer.cornerRadius = 7;
    self.confirmBtn.layer.cornerRadius = 7;
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.navigationItem.title = @"绑定";
}

- (IBAction)cancelAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confirmAction:(id)sender
{
    NSString *code = self.inputField.text;
    
    if (code.length <= 0) {
       return [NoticeHelper AlertShow:@"请输入亲友档案号" view:nil];
    }
    
    [self addArchiveWhitCode:code];
}


/**
 * 通过输入档案编号添加档案
 */
-(void)addArchiveWhitCode:(NSString *)code
{
    NSDictionary *params = @{ @"client":@"ios",
                              @"key":[SharedAppUtil defaultCommonUtil].userVO.key,
                              @"fmno":code};
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Bingding_fm parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        [hud removeFromSuperview];
        
        if ([dict[@"code"] integerValue] != 0) {
            return [NoticeHelper AlertShow:dict[@"errorMsg"] view:self.view];
        }
        
        NSArray *vcs = self.navigationController.viewControllers;
        UIViewController *vc = vcs[vcs.count - 3];
        
        [self.navigationController popToViewController:vc animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud removeFromSuperview];
        [NoticeHelper AlertShow:@"请求出错了" view:nil];
    }];
}

@end
