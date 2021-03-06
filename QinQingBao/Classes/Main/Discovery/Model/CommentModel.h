//
//  CommentModel.h
//  QinQingBao
//
//  Created by shi on 16/9/23.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentContentModel.h"

@interface CommentModel : NSObject

@property(copy,nonatomic)NSString *pid;

@property(copy,nonatomic)NSString *fid;

@property(copy,nonatomic)NSString *authorid;

@property(copy,nonatomic)NSString *author;

@property(copy,nonatomic)NSString *avatar;

@property(copy,nonatomic)NSString *dateline;

@property(copy,nonatomic)NSString *support;

@property(copy,nonatomic)NSString *is_support;

@property(copy,nonatomic)NSString *positition;  //第几楼

@property(copy,nonatomic)NSString *is_host;

@property(copy,nonatomic)NSString *grouptitle;

@property(strong,nonatomic)CommentContentModel *commen;

@end
