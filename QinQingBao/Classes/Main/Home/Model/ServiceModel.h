//
//  ServiceModel.h
//  QinQingBao
//
//  Created by 董徐维 on 15/10/16.
//  Copyright © 2015年 董徐维. All rights reserved.
//

//"iid": "1",
//"orgid": "1",
//"tid": "6",
//"price": "25",
//"icontent": "送餐",
//"servicetime": "几时都OK",
//"dvcode": "330102001051",
//"reservation": "0",
//"status": "1",
//"item_url": "images\/icons\/ic_arber_pedicure.png",
//"orgname": "测试服务商",
//"orglon": "113.335213",
//"orglat": "22.157059",
//"sumsell": "2"

#import <Foundation/Foundation.h>

@interface ServiceModel : NSObject

@property (nonatomic, copy) NSString *iid;
@property (nonatomic, copy) NSString *orgid;
@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *icontent;
@property (nonatomic, copy) NSString *servicetime;
@property (nonatomic, copy) NSString *dvcode;
@property (nonatomic, copy) NSString *reservation;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *item_url;
@property (nonatomic, copy) NSString *orgname;
@property (nonatomic, copy) NSString *orglon;
@property (nonatomic, copy) NSString *orglat;
@property (nonatomic, copy) NSString *sumsell;
@end
