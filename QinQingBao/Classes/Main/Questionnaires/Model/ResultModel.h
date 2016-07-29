//
//  ResultModel.h
//  QinQingBao
//
//  Created by 董徐维 on 16/7/29.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultModel : NSObject
@property (nonatomic, copy) NSString *r_id;
@property (nonatomic, copy) NSString *r_eid;
@property (nonatomic, copy) NSString *r_etitle;
@property (nonatomic, copy) NSString *r_totalscore;
@property (nonatomic, strong) NSDictionary *r_result;
@property (nonatomic, copy) NSString *r_createtime;
@property (nonatomic, copy) NSString *r_dangercoefficient;

@end
