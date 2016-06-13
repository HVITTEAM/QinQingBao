//
//  EventMsgModel.h
//  QinQingBao
//
//  Created by 董徐维 on 16/5/31.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

//"author": "", //文章作者
//"title": "血糖仪", //文章标题
//"subtitle": "", //副标题
//"logo_url": "images/home/bannerGALRxty.jpg", //logo缩略图
//"abstract": "", //文章摘要
//"m_create_time": "2016-05-11 16:28:59", //文章创建时间
//"systemmsg_id": "1", //消息ID
//"msg_type": "1", //消息分类
//"msg_title": "标题", //消息标题
//"msg_artid": "8", //文章ID
//"s_create_time": "2016-05-31 11:10:51",//消息创建时间
//"s_push_time": "2016-06-01 11:10:54" //消息推送时间
@interface EventMsgModel : NSObject

@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *logo_url;
@property (nonatomic, copy) NSString *detail_url;
@property (nonatomic, copy) NSString *abstract;
@property (nonatomic, copy) NSString *m_create_time;
@property (nonatomic, copy) NSString *systemmsg_id;
@property (nonatomic, copy) NSString *msg_type;
@property (nonatomic, copy) NSString *msg_title;
@property (nonatomic, copy) NSString *msg_artid;
@property (nonatomic, copy) NSString *s_create_time;
@property (nonatomic, copy) NSString *s_push_time;

@end
