//
//  QuestionModel_1.h
//  QinQingBao
//
//  Created by 董徐维 on 16/7/22.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionModel_1 : NSObject
@property (nonatomic, copy) NSString *q_id;
@property (nonatomic, copy) NSString *q_type;
@property (nonatomic, copy) NSString *q_anumber;
@property (nonatomic, copy) NSString *q_title;
@property (nonatomic, copy) NSString *q_createtime;
@property (nonatomic, copy) NSString *q_edittime;
@property (nonatomic, copy) NSString *q_logo_url;
@property (nonatomic, copy) NSString *q_detail_url;
@property (nonatomic, copy) NSString *q_subtitle;
@property (nonatomic, copy) NSString *q_rule;
@property (nonatomic, copy) NSString *q_unit;
@property (nonatomic, copy) NSString *q_keyword;
@property (nonatomic, strong) NSMutableArray *options;

@end
