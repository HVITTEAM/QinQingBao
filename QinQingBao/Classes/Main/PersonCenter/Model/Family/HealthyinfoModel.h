//
//  HealthyinfoModel.h
//  QinQingBao
//
//  Created by 董徐维 on 15/10/28.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface HealthyinfoModel : NSObject
/**健康信息编号**/
@property (nonatomic, assign) NSString *hid;
/**老年人编号**/
@property (nonatomic, assign) NSString *oid;
/**健康报告**/
@property (nonatomic, copy) NSString *healthyreport;
/**检查时间 **/
@property (nonatomic, copy) NSString *htime;
/**餐后血糖**/
@property (nonatomic, copy) NSString *chxt;
/**空腹血糖**/
@property (nonatomic, copy) NSString *kfxt;
/**总胆固醇**/
@property (nonatomic, copy) NSString *zdgc;
/**高密度胆固醇**/
@property (nonatomic, copy) NSString *gmddgc;
/**低密度胆固醇**/
@property (nonatomic, copy) NSString *dmddgc;
/**血清肌酐**/
@property (nonatomic, copy) NSString *xqjq;
/**微量尿白蛋白**/
@property (nonatomic, copy) NSString *wlnbdb;
@end
