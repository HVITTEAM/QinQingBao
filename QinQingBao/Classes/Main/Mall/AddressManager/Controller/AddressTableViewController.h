//
//  AddressTableViewController.h
//  QinQingBao
//
//  Created by Dual on 16/1/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MallAddressModel.h"

@interface AddressTableViewController : UITableViewController

@property (nonatomic, copy) void (^selectedAddressModelBlock)(MallAddressModel *item);

@end
