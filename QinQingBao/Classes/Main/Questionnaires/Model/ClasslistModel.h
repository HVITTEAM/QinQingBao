//
//  ClasslistModel.h
//  QinQingBao
//
//  Created by shi on 16/8/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClasslistExamInfoModel.h"

@interface ClasslistModel : NSObject

@property (nonatomic, copy) NSString *c_id;

@property (nonatomic, copy) NSString *c_title;

@property (nonatomic, copy) NSString *c_subtitle;

@property (nonatomic, copy) NSString *c_itemurl;

@property (nonatomic, copy) NSString *c_createtime;

@property (nonatomic, copy) NSString *count;

@property (nonatomic, copy) NSArray *exam_info;

@end
