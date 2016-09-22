//
//  SectionlistModel.h
//  QinQingBao
//
//  Created by shi on 16/9/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CircleModel : NSObject

@property (copy, nonatomic) NSString *sectionid;   //下一级版本id

@property (copy, nonatomic) NSString *name;        //下级版块名称

@property (copy, nonatomic) NSString *avatar;      //版块头像

@property (copy, nonatomic) NSString *moderators;      //版主名称

@property (copy, nonatomic) NSString *num_author;      //参与人数

@property (copy, nonatomic) NSString *num_article;      //帖子数

@end
