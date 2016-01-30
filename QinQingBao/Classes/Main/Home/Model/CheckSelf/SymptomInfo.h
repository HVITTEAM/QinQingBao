//
//  SymptomInfo.h
//  QinQingBao
//
//  Created by shi on 16/1/22.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SymptomInfo : NSObject

@property(assign,nonatomic)NSInteger body_id;                   //身体部位 id

@property(assign,nonatomic)NSInteger symptom_id;                //症状 id

@property(strong,nonatomic)NSString *identification;            //鉴别诊断

@property(strong,nonatomic)NSString *pathogeny;                 //病因

@property(strong,nonatomic)NSString *prevention;                //预防

@property(strong,nonatomic)NSString *suitable_food;             //宜吃食物

@property(strong,nonatomic)NSString *unSuitable_food;           //不宜食物

@property(strong,nonatomic)NSString *tips;                      //温馨提示

@property(strong,nonatomic)NSString *info;                      //症状信息

@property(strong,nonatomic)NSString *name;                      //症状名字

@property(strong,nonatomic)NSMutableArray *disease;             //可能疾病数组

@end

