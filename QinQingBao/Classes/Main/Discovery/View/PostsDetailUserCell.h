//
//  PostsDetailUserCell.h
//  QinQingBao
//
//  Created by shi on 16/9/19.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailPostsModel;

@interface PostsDetailUserCell : UITableViewCell

@property (strong, nonatomic) DetailPostsModel *postsDetailData;

@property (copy) void(^attentionBlock)();

@property (copy) void (^portraitClickBlock)(NSString *authorId);

+ (instancetype)createCellWithTableView:(UITableView *)tableView;

@end
