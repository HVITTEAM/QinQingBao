//
//  BusinessDataCenter.h
//  QinQingBao
//
//  Created by Dual on 16/1/5.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusinessDataCenter : NSObject

@property (nonatomic, strong) NSMutableDictionary *businessDataDic;



//创建单例的类方法
+ (id)sharedBusinessDataCenter;



@end
