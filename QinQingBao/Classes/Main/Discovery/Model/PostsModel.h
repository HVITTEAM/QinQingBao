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
/**作者id*/
@property (copy, nonatomic) NSString *authorid;
/**作者头像*/
@property (copy, nonatomic) NSString *avatar;
/**作者名称*/
@property (copy, nonatomic) NSString *author;
/**时间*/
@property (copy, nonatomic) NSString *dateline;
/**是否是好友*/
@property (copy, nonatomic) NSString *is_home_friend;
/**是否是热门 */
@property (copy, nonatomic) NSString *is_hot;
/**是否是精华*/
@property (copy, nonatomic) NSString *is_digest;
/**文章标题*/
@property (copy, nonatomic) NSString *subject;
/**文章内容*/
@property (copy, nonatomic) NSString *message;
/**浏览数*/
@property (copy, nonatomic) NSString *views;
/**回复数*/
@property (copy, nonatomic) NSString *replies;
/**点赞数*/
@property (copy, nonatomic) NSString *recommend_add;
/**返回图片*/
@property (copy, nonatomic) NSArray *attachmentpicture;
/**返回图片*/
@property (copy, nonatomic) NSArray *picture;
/**标签名称*/
@property (copy, nonatomic) NSString *forum_name;
/**楼主信息*/
@property (copy, nonatomic) NSString *grouptitle;
/**返回大图图片*/
@property (copy, nonatomic) NSArray *attachmentpicture_bigthumb;
/**返回小图图片*/
@property (copy, nonatomic) NSArray *attachmentpicture_smallthumb;

/**帖子是自己的*/
@property (copy, nonatomic) NSString *is_myposts;
@end
