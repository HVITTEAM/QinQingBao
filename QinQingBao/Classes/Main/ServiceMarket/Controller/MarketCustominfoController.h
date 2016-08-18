//
//  MarketCustominfoController.h
//  QinQingBao
//
//  Created by shi on 16/6/21.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarketCustomInfo.h"

@interface MarketCustominfoController : UITableViewController

@property(strong,nonatomic)MarketCustomInfo *customInfo;

@property (copy)void(^customInfoCallBack)(MarketCustomInfo * customInfo);

@end
