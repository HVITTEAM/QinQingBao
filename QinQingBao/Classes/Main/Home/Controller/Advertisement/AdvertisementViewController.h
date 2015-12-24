//
//  AdvertisementViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 15/12/8.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvertisementViewController : UIViewController

/**
 *  广告类型 1 看护宝 2 腕表 3 心脏健康管家 4血压仪 5 推拿
 */
@property (nonatomic, assign) NSInteger type;

/**
 *  数据源
 */
@property (nonatomic, retain) NSMutableArray *dataProvider;
@end
