//
//  ReportInterventionModel.h
//  QinQingBao
//
//  Created by 董徐维 on 2016/11/15.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportInterventionModel : NSObject

@property (nonatomic, copy) NSString *fmno;
@property (nonatomic, retain) NSArray *wp_read;
@property (nonatomic, copy) NSString *wi_read;
@property (nonatomic, copy) NSString *wp_read_time;
@property (nonatomic, copy) NSString *wi_read_time;
@property (nonatomic, copy) NSString *fm_bid;
@property (nonatomic, copy) NSString *basics;
@end
