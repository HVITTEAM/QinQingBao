//
//  CardCell.h
//  QinQingBao
//
//  Created by shi on 16/9/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostsModel.h"
@interface CardCell : UITableViewCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView;

/**
 *  设置帖子数据
 */
@property (nonatomic, retain) PostsModel *postsModel;

@property (nonatomic, copy) void (^portraitClick)(PostsModel *postsModel);
@property (strong, nonatomic) NSIndexPath *indexpath;

@property (copy) void(^attentionBlock)(NSIndexPath *idxPath);

@end
