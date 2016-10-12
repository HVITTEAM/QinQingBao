//
//  DetailPostsModel.h
//  QinQingBao
//
//  Created by 董徐维 on 16/9/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DetailPostsModel : NSObject
 //作者id
@property(copy,nonatomic)NSString *authorid;
//作者名称
@property(copy,nonatomic)NSString *author;
 //作者头像
@property(copy,nonatomic)NSString *avatar;
//是否为关注对象 1为关注 0为未关注
@property(copy,nonatomic)NSString *is_home_friend;
//帖子id
@property(copy,nonatomic)NSString *tid;
//帖子标题
@property(copy,nonatomic)NSString *subject;
 //帖子内容
@property(copy,nonatomic)NSString *message;
//帖子总点赞数
@property(copy,nonatomic)NSString *count_recommend;
//是否已点赞   0为未点赞  1为已点赞
@property(copy,nonatomic)NSString *is_recommend;

@property(copy,nonatomic)NSString *is_hot;

@property(copy,nonatomic)NSString *is_digest;

@property(copy,nonatomic)NSString *forum_name;

@property(copy,nonatomic)NSString *grouptitle;

@property(copy,nonatomic)NSString *dateline;

@property(copy,nonatomic)NSString *views;

@property(copy,nonatomic)NSMutableArray *img;
@property(copy,nonatomic)NSString *fid;

@property(copy,nonatomic)NSString *share_url;

@property(copy,nonatomic)NSString *jiequmessage
;

@end
