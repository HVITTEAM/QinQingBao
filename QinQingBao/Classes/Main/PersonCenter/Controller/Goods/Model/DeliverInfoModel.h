//
//  DeliverInfoModel.h
//  QinQingBao
//
//  Created by shi on 16/6/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeliverInfoModel : NSObject

@property(nonatomic,strong)NSArray *deliver_info;

@property(nonatomic,copy)NSString *express_name;

@property(nonatomic,copy)NSString *shipping_code;

//0：在途，即货物处于运输过程中；
//1：揽件，货物已由快递公司揽收并且产生了第一条跟踪信息；
//2：疑难，货物寄送过程出了问题；
//3：签收，收件人已签收；
//4：退签，即货物由于用户拒签、超区等原因退回，而且发件人已经签收；
//5：派件，即快递正在进行同城派件；
//6：退回，货物正处于退回发件人的途中；
@property(nonatomic,copy)NSString *state;

@end
