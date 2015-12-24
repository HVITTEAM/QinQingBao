//
//  OrderResultViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 15/12/23.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderItem.h"

@interface OrderResultViewController : UIViewController
- (IBAction)backHandler:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UILabel *orderNum;
@property (strong, nonatomic) IBOutlet UILabel *orderPrice;

@property (nonatomic, retain) OrderItem *orderItem;
@end
