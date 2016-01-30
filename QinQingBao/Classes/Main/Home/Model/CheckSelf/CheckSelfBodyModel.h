//
//  CheckSelfBodyModel.h
//  QinQingBao
//
//  Created by shi on 16/1/22.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckSelfBodyModel : NSObject

@property(assign,nonatomic)NSInteger body_id;           //身体部位 ID

@property(strong,nonatomic)NSString *name;              //身体部位名字

@property(assign,nonatomic)NSInteger sort;            

@end
