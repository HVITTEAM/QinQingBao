//
//  CompleteInfoController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/9/26.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CompleteInfoController.h"

@interface CompleteInfoController ()
@property (strong, nonatomic) IBOutlet UIImageView *headImg;
@property (strong, nonatomic) IBOutlet UITextField *nameTextfield;
@property (strong, nonatomic) IBOutlet UIButton *btn;
- (IBAction)btnHandler:(id)sender;

@end

@implementation CompleteInfoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"完善资料";
    
    self.headImg.userInteractionEnabled=YES;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage)];
    [self.headImg addGestureRecognizer:singleTap];

}

// 完善资料
-(void)complete
{
    [CommonRemoteHelper RemoteWithUrl:URL_Get_loginToOtherSys parameters: @{@"key" :[SharedAppUtil defaultCommonUtil].userVO.key,
                                                                            @"client" : @"ios",
                                                                            @"targetsys" : @"4",
                                                                            @"discuz_uname" : @"我是你爸爸"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     NSLog(@"%@",dict);
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         NSDictionary *datas = [dict objectForKey:@"datas"];
                                         
                                         BBSUserModel *bbsmodel = [[BBSUserModel alloc] init];
                                         bbsmodel.BBS_Key = [datas objectForKey:@"key"];
                                         bbsmodel.BBS_Member_id = [datas objectForKey:@"member_id"];
                                         bbsmodel.BBS_Member_mobile = [datas objectForKey:@"member_mobile"];
                                         bbsmodel.BBS_Sys = [datas objectForKey:@"sys"];
                                         
                                         [SharedAppUtil defaultCommonUtil].bbsVO = bbsmodel;
                                         [ArchiverCacheHelper saveObjectToLoacl:bbsmodel key:BBSUser_Archiver_Key filePath:BBSUser_Archiver_Path];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                 }];
}

// 个人头像点击事件
-(void)onClickImage
{
    
}

- (IBAction)btnHandler:(id)sender {
}
@end
