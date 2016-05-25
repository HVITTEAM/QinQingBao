//
//  ChattingViewController.h
//  QinQingBao
//
//  Created by Dual on 15/12/30.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "EaseMessageViewController.h"
#import "UserInforModel.h"
#import "BusinessInfoModel.h"
#import "ServiceItemModel.h"

#define KNOTIFICATIONNAME_DELETEALLMESSAGE @"RemoveAllMessages"

@interface ChattingViewController : EaseMessageViewController

@property (nonatomic, strong) UserInforModel *userinforModel;
@property (nonatomic, strong) ServiceItemModel *servicrItemMdodel;
@property (nonatomic, strong) BusinessInfoModel *businessInfoModel;

@end
