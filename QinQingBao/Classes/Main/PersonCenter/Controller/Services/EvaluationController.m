//
//  EvaluationController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/10.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "EvaluationController.h"

@interface EvaluationController ()
{
    float maxStar;
}

@end

@implementation EvaluationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"评价";
    self.evaContentText.layer.borderColor = [HMGlobalBg CGColor];
    self.evaContentText.layer.borderWidth = 1;
    self.evaContentText.layer.cornerRadius = 3;
}

- (IBAction)starClickeHandler:(id)sender
{
    
    UIButton *btn = sender;
    btn.selected =  !btn.selected;
    if (btn.selected)
    {
        for (int i = 100; i < btn.tag+1; i++)
        {
            UIButton *otherBtn = (UIButton*)[self.view viewWithTag:i];
            otherBtn.selected =  YES;
        }
        maxStar = btn.tag - 99;
    }
    else
    {
        for (int i =  btn.tag+1; i < 105; i++)
        {
            UIButton *otherBtn = (UIButton*)[self.view viewWithTag:i];
            otherBtn.selected =  NO;
        }
        maxStar = btn.tag - 100;
    }
    if (maxStar == 0)
        self.starLabel.text = @"";
    if (maxStar == 1)
        self.starLabel.text = @"很差";
    else  if (maxStar == 2)
        self.starLabel.text = @"一般";
    else  if (maxStar == 3)
        self.starLabel.text = @"好";
    else  if (maxStar == 4)
        self.starLabel.text = @"很好";
    else  if (maxStar == 5)
        self.starLabel.text = @"非常好";
}

- (IBAction)subBtnClickHandler:(id)sender
{
    [CommonRemoteHelper RemoteWithUrl:URL_Save_dis_cont parameters:  @{@"wid" : self.orderItem.wid,
                                                                       @"cont" : @"ios",
                                                                       @"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                       @"oldid" : [SharedAppUtil defaultCommonUtil].userVO.old_id,
                                                                       @"client" : @"ios",
                                                                       @"grade" : [NSString stringWithFormat:@"%.0f",maxStar]
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
