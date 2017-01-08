//
//  None_Gene_DetectionModel.h
//  QinQingBao
//
//  Created by 董徐维 on 2017/1/8.
//  Copyright © 2017年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface None_Gene_DetectionModel : NSObject
//非基因检查  正常
@property(nonatomic,copy)NSArray *normal;
//非基因检查 不正常
@property(nonatomic,copy)NSArray *non_normal;

@end
