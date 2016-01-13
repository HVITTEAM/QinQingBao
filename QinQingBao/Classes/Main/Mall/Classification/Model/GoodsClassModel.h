//
//  GoodsClassModel.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/9.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsClassModel : NSObject

@property(nonatomic, copy) NSString * gc_id;
@property(nonatomic, copy) NSString * gc_name;
@property(nonatomic, copy) NSString * type_id;
@property(nonatomic, copy) NSString * type_name;
@property(nonatomic, copy) NSString * gc_parent_id;
@property(nonatomic, copy) NSString * commis_rate;
@property(nonatomic, copy) NSString * gc_sort;
@property(nonatomic, copy) NSString * gc_virtual;
@property(nonatomic, copy) NSString * gc_title;
@property(nonatomic, copy) NSString * gc_keywords;
@property(nonatomic, copy) NSString * gc_description;
@property(nonatomic, copy) NSString * image;
@property(nonatomic, copy) NSString * text;
@end
