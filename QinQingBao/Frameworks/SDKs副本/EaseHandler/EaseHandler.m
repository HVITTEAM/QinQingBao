//
//  EaseHandler.m
//  QinQingBao
//
//  Created by Dual on 15/12/28.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "EaseHandler.h"



@interface EaseHandler ()

@property (nonatomic, assign) BOOL isSuccessLogin;

@end
@implementation EaseHandler
#pragma mark --- 注册并登陆
-(void)registerAndLoginEase:(NSString *)userName {
    NSLog(@"【环信】注册UserName：%@",userName);
    if (![[EaseMob sharedInstance].chatManager isAutoLoginEnabled]) {
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:userName password:userName completion:^(NSDictionary *loginInfo, EMError *error) {
            [self didLoginWithInfo:loginInfo error:error];
            if (!error && loginInfo) {
                // 设置自动登录
                [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
            }else if (error.errorCode == EMErrorNotFound) {
                [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:userName password:userName withCompletion:^(NSString *username, NSString *password, EMError *error) {
                    [self didRegisterNewAccount:username password:password error:error];
                } onQueue:nil];
            }
        } onQueue:nil];
    }
}



#pragma mark --- 注册
-(void)registerEaseMobWithUserName:(NSString *)userName {
    NSLog(@"【环信】注册UserName：%@",userName);
       [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:userName password:userName withCompletion:^(NSString *username, NSString *password, EMError *error) {
    [self didRegisterNewAccount:username password:password error:error];
    } onQueue:nil];
}
/*!
 @method
 @brief 注册新用户后的回调
 @discussion
 @result
 */
- (void)didRegisterNewAccount:(NSString *)username password:(NSString *)password error:(EMError *)error {
    if (!error) {
        NSLog(@"【环信SDK】注册环信成功。注册用户名：%@, 密码：%@",username, password);
        [self loginEaseMobWithUserName:username];
    }else {
        NSLog(@"【环信SDK】注册到环信失败。注册用户名：%@, 密码：%@",password, password);
        [self toStringWithEaseMobError:error];
    }
}


#pragma mark --- 登陆
-(void)loginEaseMobWithUserName:(NSString *)userName  {
    if (![[EaseMob sharedInstance].chatManager isAutoLoginEnabled]) {
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:userName password:userName completion:^(NSDictionary *loginInfo, EMError *error) {
        [self didLoginWithInfo:loginInfo error:error];
        if (!error) {
            // 设置自动登录
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
        }
    } onQueue:nil];
  }
}
/*!
 @method
 @brief 用户登录后的回调
 @discussion
 @param loginInfo 登录的用户信息
 @param error     错误信息
 @result
 */
- (void)didLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error {
    if (!error && loginInfo) {
        _isSuccessLogin = YES;
        NSLog(@"【环信SDK】登陆环信成功。登陆用户信息：%@",loginInfo);
    }else {
        _isSuccessLogin = NO;
        if (error) {
            [self toStringWithEaseMobError:error];
        }else {
            NSLog(@"【环信SDK】没有用户信息");
        }
        
        }
}


#pragma mark --- 自动登陆回调
/*!
 @method
 @brief 用户将要进行自动登录操作的回调
 @discussion
 @param loginInfo 登录的用户信息
 @param error     错误信息
 @result
 */
- (void)willAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error {
    if (!error && loginInfo) {
        _isSuccessLogin = YES;
        NSLog(@"【环信SDK】将要自动登陆环信成功。登陆信息：%@", loginInfo);
    }else {
        _isSuccessLogin = NO;
        NSLog(@"【环信SDK】将要自动登陆环信失败");
        [self toStringWithEaseMobError:error];
    }
}

/*!
 @method
 @brief 用户自动登录完成后的回调
 @discussion
 @param loginInfo 登录的用户信息
 @param error     错误信息
 @result
 */
- (void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error {
    if (!error && loginInfo) {
        _isSuccessLogin = YES;
        NSLog(@"【环信SDK】已经自动登陆环信成功。登陆信息：%@", loginInfo);
    }else {
        _isSuccessLogin = NO;
        NSLog(@"【环信SDK】已经自动登陆环信失败");
        [self toStringWithEaseMobError:error];
    }
}

#pragma mark --- 掉线重连
/*!
 @method
 @brief 将要发起自动重连操作时发送该回调
 @discussion
 @result
 */
- (void)willAutoReconnect {
    _isSuccessLogin = NO;
    NSLog(@"将要开始重新连接【环信】");
}

/*!
 @method
 @brief 自动重连操作完成后的回调（成功的话，error为nil，失败的话，查看error的错误信息）
 @discussion
 @result
 */
- (void)didAutoReconnectFinishedWithError:(EMError *)error {
    if (!error) {
        _isSuccessLogin = YES;
        NSLog(@"【环信】重连成功");
    }else {
        _isSuccessLogin = NO;
        NSLog(@"【环信】重连失败");
        [self toStringWithEaseMobError:error];
    }
}

#pragma maek --- 退出
-(void)logoutEaseMobCallBack {
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        [self didLogoffWithError:error];
        if (!error && info) {
            _isSuccessLogin = NO;
            
        }
    } onQueue:nil];
}
/*!
 @method
 @brief 用户注销后的回调
 @discussion
 @param error        错误信息
 @result
 */
- (void)didLogoffWithError:(EMError *)error {
    if (!error) {
        _isSuccessLogin = NO;
        NSLog(@"退出成功");
    }else {
        _isSuccessLogin = YES;
        NSLog(@"退出失败");
        [self toStringWithEaseMobError:error];
    }
}

#pragma mark --- 被其他设备顶退
/*!
 @method
 @brief 当前登录账号在其它设备登录时的通知回调
 @discussion
 @result
 */
- (void)didLoginFromOtherDevice {
    self.isSuccessLogin = NO;
    NSLog(@"【环信SDK】当前账号在其他设备上登录，已被顶下线。");
}


#pragma mark --- 错误信息处理
-(void)toStringWithEaseMobError:(EMError *)error {
    if (error != nil) {
        switch (error.errorCode) {
            case EMErrorNotFound: return NSLog(@"用户不存在");
            case EMErrorConfigInvalidAppKey: return NSLog(@"无效的AppKey");
            case EMErrorServerNotLogin: return NSLog(@"尚未登录");
            case EMErrorServerNotReachable: return NSLog(@"连接服务器失败");
            case EMErrorServerTimeout: return NSLog(@"连接服务器超时");
            case EMErrorServerAuthenticationFailure: return NSLog(@"获取token失败");
            case EMErrorServerAPNSRegistrationFailure: return NSLog(@"注册到APNS失败");
            case EMErrorServerDuplicatedAccount: return NSLog(@"用户已存在");
            case EMErrorServerInsufficientPrivilege: return NSLog(@"无权操作");
            case EMErrorServerTooManyOperations: return NSLog(@"操作太频繁");
            case EMErrorMessageInvalid_NULL: return NSLog(@"内容为空");
            case EMErrorInvalidUsername: return NSLog(@"无效的用户名");
            case EMErrorInvalidUsername_NULL: return NSLog(@"用户名不能为空");
            case EMErrorInvalidUsername_Chinese: return NSLog(@"用户名不能带有中文");
            case EMErrorCallRemoteOffline: return NSLog(@"对方不在线");
            case EMErrorCallInvalidId: return NSLog(@"无效ID");
            case EMErrorRequestRefused: return NSLog(@"请求失败");
            default:
                return NSLog(@"未定义");
            }
        } else {
            return NSLog(@"没有错误");
        }
}


@end
