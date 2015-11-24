//
//  CommonCouponsCell.h
//  QinQingBao
//
//  Created by 董徐维 on 15/11/20.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponsModel.h"

@interface CommonCouponsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *bgview;
@property (strong, nonatomic) IBOutlet UIView *bottomview;
+ (CommonCouponsCell*) commonCouponsCell;

@property (nonatomic, retain) CouponsModel *couponsItem;
@end
