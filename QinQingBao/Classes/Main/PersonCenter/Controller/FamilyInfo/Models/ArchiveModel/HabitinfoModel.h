//
//  HabitinfoModel.h
//  QinQingBao
//
//  Created by 董徐维 on 15/10/28.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HabitinfoModel : NSObject
/**生活习惯信息编号**/
@property (nonatomic, assign) NSString *habitid;
/**老年人编号**/
@property (nonatomic, assign) NSString *oid;
/**血型**/
@property (nonatomic, copy) NSString *blood;
/** 吸烟年限 0不吸 1 一年 2 两年 3 三年 4 三年以上 **/
@property (nonatomic, copy) NSString *smokeyears;
/**吸烟频次 0不吸 1经常 2偶尔 3少许**/
@property (nonatomic, copy) NSString *smokefrequency;
/**饮酒频次 0不饮 1 经常 2偶然 3少许**/
@property (nonatomic, copy) NSString *drinkfrequency;
/**饮酒类型 0不饮 1 红酒 2白酒 3 黄酒**/
@property (nonatomic, copy) NSString *drinktype;
/**运动时长 0不运动 1经常 2偶尔 3少许 **/
@property (nonatomic, copy) NSString *sportduration;
/**运动频次 0不运动 1经常 2偶尔 3少许**/
@property (nonatomic, copy) NSString *sportfrequency;
/**睡眠质量 0不好 1好 2一般 **/
@property (nonatomic, copy) NSString *sleepquality;
/**睡眠时长 **/
@property (nonatomic, copy) NSString *sleepduration;
@end
