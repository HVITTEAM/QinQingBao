//
//  PostsDetailDZCell.h
//  QinQingBao
//
//  Created by shi on 16/9/20.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DetailPostsModel;
@interface PostsDetailDZCell : UITableViewCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView;

@property (strong, nonatomic) DetailPostsModel *postsDetailData;

@property (copy) void(^dianZanBlock)();

@end
