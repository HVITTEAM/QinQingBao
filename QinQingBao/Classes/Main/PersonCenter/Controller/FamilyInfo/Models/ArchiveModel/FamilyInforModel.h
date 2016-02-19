//
//  FamilyInforModel.h
//  QinQingBao
//
//  Created by 董徐维 on 15/10/28.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HypertensioninfoModel.h"
#import "HeredityinfoModel.h"
#import "HabitinfoModel.h"
#import "HealthyinfoModel.h"
#import "DiseaseinfoModel.h"

@interface FamilyInforModel : NSObject

@property (nonatomic, retain) HeredityinfoModel *heredityinfo;
@property (nonatomic, retain) NSMutableArray *diseaseinfo;
@property (nonatomic, retain) HypertensioninfoModel *hypertensioninfo;
@property (nonatomic, retain) HabitinfoModel *habitinfo;
@property (nonatomic, retain) NSMutableArray *healthyinfo;
@end
