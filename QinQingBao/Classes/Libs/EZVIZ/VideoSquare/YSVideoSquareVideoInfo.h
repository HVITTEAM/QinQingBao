//
//  YSVideoSquareVideoInfo.h
//  EzvizRealPlayDemo
//
//  Created by Journey on 1/19/15.
//  Copyright (c) 2015 hikvision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSVideoSquareVideoInfo : NSObject

// 视频标题
@property (retain, nonatomic) NSString *title;

// 地址
@property (retain, nonatomic) NSString *address;

// 观看次数
@property (assign, nonatomic) NSInteger viewedCount;

// 点赞数
@property (assign, nonatomic) NSInteger likeCount;

// 评论数
@property (assign, nonatomic) NSInteger commentCount;

// 视频封面
@property (retain, nonatomic) NSString *coverUrl;

// 视频播放地址
@property (retain, nonatomic) NSString *playUrl;


@end
