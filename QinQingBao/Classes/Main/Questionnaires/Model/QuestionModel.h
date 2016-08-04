//
//  QuestionModel.h
//  QinQingBao
//
//  Created by 董徐维 on 16/7/22.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionModel : NSObject
@property (nonatomic, copy) NSString *eq_id;
@property (nonatomic, copy) NSString *eq_eid;
@property (nonatomic, copy) NSString *eq_title;
@property (nonatomic, copy) NSString *eq_subtitle;
@property (nonatomic, copy) NSString *eq_qids;
@property (nonatomic, copy) NSString *eq_sort;



@property (nonatomic, strong) NSMutableArray *questions;


@end
