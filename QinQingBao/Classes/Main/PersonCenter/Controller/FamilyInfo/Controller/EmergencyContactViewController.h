//
//  EmergencyContactViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 16/2/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "HMCommonViewController.h"

@interface EmergencyContactViewController : HMCommonViewController
@property (nonatomic, copy) NSString *member_id;
//是否来自于新增联系人，是的话退出的时候需要弹出提示
@property (nonatomic, assign) BOOL isFromStart;
@end
