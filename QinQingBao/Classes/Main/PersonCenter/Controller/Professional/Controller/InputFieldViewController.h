//
//  InputFieldViewController.h
//  QinQingBao
//
//  Created by shi on 16/10/10.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "HMCommonViewController.h"

@interface InputFieldViewController : HMCommonViewController

//@{@"title" : @"修改姓名",@"placeholder" : @"请输入姓名",@"text" : @"姓名", @"value" : @"真实姓名"}
/**选择的某一行数据,title:导航栏标题,placeholder:提示文本,text:标题,value:具体内容*/
@property (strong, nonatomic) NSMutableDictionary *dict;

//属于哪个cell
@property (strong, nonatomic) NSIndexPath *idx;

@property (copy) void(^completeCallBack)(NSMutableDictionary *dict,NSIndexPath *idx);

@end
