//
//  DiseaseModel.h
//  QinQingBao
//
//  Created by shi on 16/1/22.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiseaseModel : NSObject

@property(assign,nonatomic)NSInteger disease_id;                  //疾病 ID

@property(assign,nonatomic)NSInteger symptom_id;                  //症状 ID

@property(strong,nonatomic)NSString *typical_symptom;             //典型症状

@property(strong,nonatomic)NSString *handle;                      //就诊科室

@property(strong,nonatomic)NSString *disease_detail;              //疾病详情

@property(strong,nonatomic)NSString *disease;                     //疾病名称

@end
