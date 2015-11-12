//
//  FamilyInfoViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 15/9/15.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "HMCommonViewController.h"
#import "DetailInfoViewController.h"
#import "FamilyModel.h"
#import "FamilyInforTotal.h"

@interface FamilyInfoViewController : HMCommonViewController<UIActionSheetDelegate>

@property (nonatomic, retain) FamilyModel *selecteItem;

@property (nonatomic, copy) void (^backHandlerClick)(void);

@end
