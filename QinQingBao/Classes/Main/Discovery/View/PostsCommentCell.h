//
//  PostsCommentCell.h
//  QinQingBao
//
//  Created by shi on 16/9/20.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface PostsCommentCell : UITableViewCell

@property (strong, nonatomic) CommentModel *commentModel;

@property (strong, nonatomic) NSIndexPath *indexpath;

@property (copy) void(^dianZanBlock)(NSIndexPath *idxPath);

+ (instancetype)createCellWithTableView:(UITableView *)tableView;

@end
