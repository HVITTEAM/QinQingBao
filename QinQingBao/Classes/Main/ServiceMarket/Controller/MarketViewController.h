//
//  MarketViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 16/6/21.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TypeinfoModel;

@interface MarketViewController : UITableViewController

@property(strong,nonatomic)TypeinfoModel *typeinfoModel;

@property (copy, nonatomic) NSString *navTitle;

@property (copy, nonatomic) NSString *tid;

@end
