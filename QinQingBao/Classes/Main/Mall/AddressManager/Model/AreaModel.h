//
//  AreaModel.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/12.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaModel : NSObject
@property(nonatomic,copy)NSString *area_id;
@property(nonatomic,copy)NSString *area_name;

-(AreaModel *)initWithName:(NSString *)name areaid:(NSString *)areaid;
@end
