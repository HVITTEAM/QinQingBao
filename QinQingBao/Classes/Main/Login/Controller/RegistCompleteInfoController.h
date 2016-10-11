//
//  RegistCompleteInfoController.h
//  QinQingBao
//
//  Created by 董徐维 on 16/9/26.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistCompleteInfoController : UIViewController

@property (nonatomic, copy) NSString *openid;
@property (nonatomic, copy) NSString *login_type;
@property (nonatomic, copy) NSString *open_token;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *icon;


-(void)registWithOpenid:(NSString *)openid login_type:(NSString *)login_type open_token:(NSString *)open_token nickname:(NSString *)nickname icon:(NSString *)icon;
@end
