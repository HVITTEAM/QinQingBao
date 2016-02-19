//
//  RelationModel.h
//  QinQingBao
//
//  Created by 董徐维 on 16/2/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RelationModel : NSObject
//编辑紧急联系人的时候需要用到
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *rela_id;
@property (nonatomic, copy) NSString *rela_mem_id;
@property (nonatomic, copy) NSString *oid;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *rname;
@property (nonatomic, copy) NSString *rtelnum;
@property (nonatomic, copy) NSString *raddress;
@property (nonatomic, copy) NSString *relation;
@property (nonatomic, copy) NSString *rtime;

@end
