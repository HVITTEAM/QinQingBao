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

/**个人中心回调block，需要实时更新数据*/
@property (nonatomic, copy) void (^refleshDta)();

/**下单block，需要传回infoVO*/
@property (nonatomic, copy) void (^editHandlerBlock)(UserInforModel *inforVO);

@end
