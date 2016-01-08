//
//  UpdateAddressController.h
//  QinQingBao
//
//  Created by 董徐维 on 15/11/20.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "HMCommonViewController.h"

@interface UpdateAddressController : HMCommonViewController

/**选择的某一行数据*/
@property (nonatomic, retain) NSDictionary *dict;

/**用户资料数据*/
@property (nonatomic, retain) UserInforModel *inforVO;

/**个人中心回调block*/
@property (nonatomic, copy) void (^refleshDta)();

/**下单修改地址回调block*/
@property (nonatomic, copy) void (^changeDataBlock)(NSDictionary *addressDict, NSString *addressStr);
@end
