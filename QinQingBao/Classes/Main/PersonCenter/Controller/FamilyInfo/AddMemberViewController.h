//
//  AddMemberViewController.h
//  QinQinBao
//
//  Created by 董徐维 on 15/6/12.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "HMCommonViewController.h"
#import "HMCommonGroup.h"
#import "HMCommonCell.h"
#import "HMCommonTextfieldItem.h"
#import "HMCommonButtonItem.h"

#import <UIKit/UIKit.h>


@interface AddMemberViewController : HMCommonViewController


@property (nonatomic,retain) HMCommonButtonItem *numfield;
@property (nonatomic,retain) HMCommonTextfieldItem *telfield;
@property (nonatomic,retain) HMCommonButtonItem *codefield;


@end
