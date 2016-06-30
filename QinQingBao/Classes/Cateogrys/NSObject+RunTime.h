//
//  NSObject+RunTime.h
//  QinQingBao
//
//  Created by 董徐维 on 16/6/28.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (RunTime)

/**
 *  根据key值设置value
 *
 *  @param key   key
 *  @param value value
 */
-(void)runtimeSetObjkey:(NSString *)key value:(id)value;

- (NSArray *)getAllProperty:(id)object;

- (NSArray *)getAllIvar:(id)object;

@end
