//
//  PushMsgModel.h
//  QinQingBao
//
//  Created by shi on 16/6/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushMsgModel : NSObject

@property (nonatomic, copy) NSString *sysumsg_id;

@property (nonatomic, copy) NSString *msg_type;

@property (nonatomic, copy) NSString *msg_title;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, copy) NSString *push_time;

@property (nonatomic, copy) NSString *pushed;

@property (nonatomic, copy) NSString *sys_relevant_id;

@property (nonatomic, copy) NSString *sys_type;

@property (nonatomic, copy) NSString *sys_mem_id;

@end