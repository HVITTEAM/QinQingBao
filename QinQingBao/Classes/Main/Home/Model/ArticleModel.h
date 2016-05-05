//
//  ArticleModel.h
//  QinQingBao
//
//  Created by 董徐维 on 16/5/5.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *keywords;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *logo_url;
@property (nonatomic, copy) NSString *abstract;

@end
