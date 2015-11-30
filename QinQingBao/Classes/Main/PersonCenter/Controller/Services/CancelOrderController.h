//
//  CancelOrderController.h
//  QinQingBao
//
//  Created by 董徐维 on 15/9/10.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderItem.h"

@interface CancelOrderController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UITextView *cancelReasonText;
- (IBAction)cancelBtnClickHandler:(id)sender;
@property (nonatomic, retain) OrderItem *orderItem;

@end
