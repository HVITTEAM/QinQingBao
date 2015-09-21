//
//  UpdatePwdViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 15/9/21.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "HMCommonViewController.h"
#import "HMCommonGroup.h"
#import "HMCommonCell.h"
#import "HMCommonTextfieldItem.h"
#import "HMCommonButtonItem.h"

@interface UpdatePwdViewController : HMCommonViewController

@property (nonatomic,retain) HMCommonTextfieldItem *oldPwd;
@property (nonatomic,retain) HMCommonTextfieldItem *nowPwd;
@property (nonatomic,retain) HMCommonTextfieldItem *confirmPwd;


@end
