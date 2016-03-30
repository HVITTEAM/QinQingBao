//
//  AreaModel.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/12.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "AreaModel.h"

@implementation AreaModel

-(AreaModel *)initWithName:(NSString *)name areaid:(NSString *)areaid dvcode:(NSString *)dvcode
{
    AreaModel *model = [[AreaModel alloc] init];
    model.area_id = areaid;
    model.area_name = name;
    model.dvcode = dvcode;

    return model;
}
@end
