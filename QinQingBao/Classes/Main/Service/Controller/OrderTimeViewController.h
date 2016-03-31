//
//  OrderTimeViewController.h
//  QinQingBao
//
//  Created by shi on 16/3/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTimeViewController : UIViewController

@property(copy)void(^finishTimeCallBack)( NSString *,NSString *);

@end
