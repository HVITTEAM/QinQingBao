//
//  FristMsgModel.h
//  QinQingBao
//
//  Created by 董徐维 on 16/6/3.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FristMsgModel : NSObject

@property (nonatomic, copy) NSString *systemmsg_id;
@property (nonatomic, copy) NSString *sysumsg_id;
@property (nonatomic, copy) NSString *msg_type;
@property (nonatomic, copy) NSString *msg_title;
@property (nonatomic, copy) NSString *msg_artid;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *pushed;
@property (nonatomic, copy) NSString *push_time;

@end
