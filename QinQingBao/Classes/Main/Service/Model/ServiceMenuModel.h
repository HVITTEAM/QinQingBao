//
//  NearMenuModel.h
//  GPSNavDemo
//
//  Created by 董徐维 on 15/3/27.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceMenuModel : NSObject

@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *label;
@property (nonatomic, retain) NSString *img;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)personWithDict:(NSDictionary*)dict;
@end
