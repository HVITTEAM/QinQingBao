//
//  HypertensioninfoModel.h
//  QinQingBao
//
//  Created by 董徐维 on 15/10/28.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HypertensioninfoModel : NSObject
/**高血压专项信息编号**/
@property (nonatomic, assign) NSString *hyid;
/**老年人编号**/
@property (nonatomic, assign) NSString *oid;
/** 患高血压日期**/
@property (nonatomic, copy) NSString *hydate;
/**是否用药**/
@property (nonatomic, copy) NSString *have_medicate;
/**疗效及副作用**/
@property (nonatomic, copy) NSString *side_effect;
/**最高收缩压**/
@property (nonatomic, copy) NSString *systolic_blood_pressure;
/**最高舒张压**/
@property (nonatomic, copy) NSString *diastolic;
/**高血压等级**/
@property (nonatomic, copy) NSString *hypertension_rating;
/**风险等级**/
@property (nonatomic, copy) NSString *risk_Level;
/**（服药情况） 是一个数组**/
@property (nonatomic, retain) NSString *medicineinfo;

@end
