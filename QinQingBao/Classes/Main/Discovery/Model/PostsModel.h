//
//  PostsModel.h
//  QinQingBao
//
//  Created by 董徐维 on 16/9/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostsModel : NSObject
 //帖子id
@property(copy,nonatomic)NSString *tid;
//帖子标题
@property(copy,nonatomic)NSString *subject;
//帖子内含有的图片地址
@property(copy,nonatomic)NSArray *picture;
//帖子内容
@property(copy,nonatomic)NSString *messages;
//帖子浏览数
@property(copy,nonatomic)NSString *views;
//帖子评论数
@property(copy,nonatomic)NSString *replies;
//帖子点赞数
@property(copy,nonatomic)NSString *recommend_add;
//帖子发表时间
@property(copy,nonatomic)NSString *dateline;
//帖子发表人id
@property(copy,nonatomic)NSString *authorid;
//帖子作者id
@property(copy,nonatomic)NSString *author;
//帖子发表人头像地址
@property(copy,nonatomic)NSString *avatar;

@end
