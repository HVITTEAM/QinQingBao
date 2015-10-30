//
//  Heredityinfo.h
//  QinQingBao
//
//  Created by 董徐维 on 15/10/28.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeredityinfoModel : NSObject
/**家族遗产史编号**/
@property (nonatomic, assign) NSString *heredityid;
/**老年人编号**/
@property (nonatomic, assign) NSString *oid;
/**高血压**/
@property (nonatomic, copy) NSString *hypertension;
/**高血脂 **/
@property (nonatomic, copy) NSString *hyperlipemiars;
/**糖尿病**/
@property (nonatomic, copy) NSString *diabetes;
/**冠心病**/
@property (nonatomic, copy) NSString *coronary;
/**脑血管意外**/
@property (nonatomic, copy) NSString *cerebrovascular;
/**精神分裂症 **/
@property (nonatomic, copy) NSString *schizophrenia;
@end
