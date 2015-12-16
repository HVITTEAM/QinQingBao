//
//  AddMemberViewController1.h
//  QinQingBao
//
//  Created by 董徐维 on 15/12/14.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "HMCommonViewController.h"
#import "HMCommonGroup.h"
#import "HMCommonCell.h"
#import "HMCommonTextfieldItem.h"
#import "HMCommonButtonItem.h"

@interface AddMemberViewController1 : HMCommonViewController

@property (nonatomic,retain) HMCommonTextfieldItem *numfield;
@property (nonatomic,retain) HMCommonTextfieldItem *telfield;

@property (nonatomic, copy) void (^backHandlerClick)(void);
@end
