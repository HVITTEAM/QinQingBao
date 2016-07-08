//
//  MarketCustominfoController.h
//  QinQingBao
//
//  Created by shi on 16/6/21.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMCommonViewController.h"

@interface MarketCustominfoController : HMCommonViewController

@property (strong,nonatomic)UserInforModel* infoVO;

@property (copy)void(^inforClick)(void);

@end
