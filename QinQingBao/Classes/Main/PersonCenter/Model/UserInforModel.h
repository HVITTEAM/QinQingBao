//
//  UserInforModel.h
//  QinQingBao
//
//  Created by 董徐维 on 15/9/23.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 "member_id": "1",
 "member_name": "seller",
 "member_truename": "",
 "member_avatar": null,
 "member_sex": "0",
 "member_birthday": null,
 "member_email": "seller@qq.com",
 "member_email_bind": "0",
 "member_mobile": "18022196345",
 "member_mobile_bind": "1",
 "member_qq": "",
 "member_ww": "",
 "member_login_num": "2",
 "member_time": "1434389719",
 "member_login_time": "1434390914",
 "member_old_login_time": "1434389719",
 "member_login_ip": "127.0.0.1",
 "member_old_login_ip": null,
 "member_points": "0",
 "available_predeposit": "0.00",
 "freeze_predeposit": "0.00",
 "available_rc_balance": "0.00",
 "freeze_rc_balance": "0.00",
 "inform_allow": "1",
 "is_buy": "1",
 "is_allowtalk": "1",
 "member_state": "1",
 "member_snsvisitnum": "0",
 "member_areaid": "2475",
 "member_cityid": "219",
 "member_provinceid": "14",
 "member_areainfo": "江西省	吉安市	永丰县",
 "member_privacy": "a:7:{s:5:"email";s:1:"0";s:8:"truename";s:1:"0";s:3:"sex";s:1:"0";s:8:"birthday";s:1:"0";s:4:"area";s:1:"0";s:2:"qq";s:1:"0";s:2:"ww";s:1:"0";}",
 "member_quicklink": null,
 "member_exppoints": "0",
 "inviter_id": null
 **/
@interface UserInforModel : NSObject

@property (nonatomic, assign) NSString *member_id;
@property (nonatomic, assign) NSString *member_name;
@property (nonatomic, assign) NSString *member_truename;
@property (nonatomic, assign) NSString *member_avatar;
@property (nonatomic, assign) NSString *member_sex;
@property (nonatomic, assign) NSString *member_birthday;
@property (nonatomic, assign) NSString *member_email;
@property (nonatomic, assign) NSString *member_email_bind;
@property (nonatomic, assign) NSString *member_mobile;
@property (nonatomic, assign) NSString *member_mobile_bind;
@property (nonatomic, assign) NSString *member_qq;
@property (nonatomic, assign) NSString *member_ww;
@property (nonatomic, assign) NSString *member_login_num;
@property (nonatomic, assign) NSString *member_time;
@property (nonatomic, assign) NSString *member_login_time;
@property (nonatomic, assign) NSString *member_old_login_time;
@property (nonatomic, assign) NSString *member_login_ip;
@property (nonatomic, assign) NSString *member_old_login_ip;
@property (nonatomic, assign) NSString *member_points;
@property (nonatomic, assign) NSString *available_predeposit;
@property (nonatomic, assign) NSString *freeze_predeposit;
@property (nonatomic, assign) NSString *available_rc_balance;
@property (nonatomic, assign) NSString *freeze_rc_balance;
@property (nonatomic, assign) NSString *inform_allow;
@property (nonatomic, assign) NSString *is_buy;
@property (nonatomic, assign) NSString *is_allowtalk;
@property (nonatomic, assign) NSString *member_state;
@property (nonatomic, assign) NSString *member_snsvisitnum;
@property (nonatomic, assign) NSString *member_areaid;
@property (nonatomic, assign) NSString *member_cityid;
@property (nonatomic, assign) NSString *member_provinceid;
@property (nonatomic, assign) NSString *member_areainfo;
@property (nonatomic, assign) NSString *member_privacy;
@property (nonatomic, assign) NSString *member_quicklink;
@property (nonatomic, assign) NSString *member_exppoints;
@property (nonatomic, assign) NSString *inviter_id;

@end
