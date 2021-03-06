//
//  TextFieldViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 15/9/21.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "HMCommonViewController.h"

@interface TextFieldViewController : HMCommonViewController

/**选择的某一行数据*/
@property (nonatomic, retain) NSDictionary *dict;

/**用户资料数据*/
@property (nonatomic, retain) UserInforModel *inforVO;

@property (nonatomic, copy) void (^refleshDta)();


@end
