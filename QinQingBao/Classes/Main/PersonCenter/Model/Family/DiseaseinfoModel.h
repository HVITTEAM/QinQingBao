//
//  DiseaseinfoModel.h
//  QinQingBao
//
//  Created by 董徐维 on 15/10/28.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiseaseinfoModel : NSObject
/**疾病史信息编号**/
@property (nonatomic, assign) NSString *diseaseid;
/**老年人编号**/
@property (nonatomic, assign) NSString *oid;
/**疾病名称**/
@property (nonatomic, copy) NSString *diseasename;
/**发送时间 **/
@property (nonatomic, copy) NSString *begintime;
/**结束时间**/
@property (nonatomic, copy) NSString *endtime;
/**住院情况**/
@property (nonatomic, copy) NSString *hospitalization;
/**转归情况**/
@property (nonatomic, copy) NSString *outcome;
@end
