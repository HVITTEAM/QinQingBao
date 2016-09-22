//
//  PostsCommentCell.h
//  QinQingBao
//
//  Created by shi on 16/9/20.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostsCommentCell : UITableViewCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView;

- (void)layoutCell;

@end
