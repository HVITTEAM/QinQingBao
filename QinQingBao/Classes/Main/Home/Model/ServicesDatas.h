//
//  ServicesDatas.h
//  QinQingBao
//
//  Created by 董徐维 on 15/10/16.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceItemModel.h"
//#import "ServiceModel.h"

@interface ServicesDatas : NSObject

/**
 *  一共多少条
 */
@property (assign, nonatomic) int code;
/**
 *  指令调度模型数据数组
 */
@property (strong, nonatomic) NSMutableArray *datas;
@end
