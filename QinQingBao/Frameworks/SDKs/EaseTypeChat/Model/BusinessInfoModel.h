//
//  BusinessInfoModel.h
//  QinQingBao
//
//  Created by Dual on 16/1/4.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusinessInfoModel : NSObject
@property (nonatomic, ) NSInteger code;
@property (nonatomic, strong) NSString *datas;
@property (nonatomic, strong) NSString *member_id;
@property (nonatomic, strong) NSString *member_truename;
@property (nonatomic, strong) NSString *member_name;
@property (nonatomic, strong) NSString *member_avatar; // 图片地址
@property (nonatomic, strong) NSString *orgname;
@property (nonatomic, strong) NSString *role;

+(id)businessInfo:(NSDictionary *)dic;
@end
