//
//  AccountViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 15/8/26.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTSlipPageViewController.h"


#import "CouponsViewController.h"
#import "BankCardViewController.h"

@interface AccountViewController : UIViewController



@property (nonatomic, strong) CouponsViewController *vc1;
@property (nonatomic, strong) BankCardViewController *vc2;
@end
