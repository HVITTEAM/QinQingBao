//
//  YSUtility.h
//  EzvizRealPlay
//
//  Created by Journey on 5/19/15.
//  Copyright (c) 2015 yudan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSUtility : NSObject

+ (NSData *)aes128EncryptData:(NSData *)data withKey:(NSString *)key iv:(NSString *)iv;

+ (NSData *)aes128DecryptData:(NSData *)data withKey:(NSString *)key iv:(NSString *)iv;

@end
