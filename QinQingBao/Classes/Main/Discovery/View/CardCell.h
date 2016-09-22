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
 *  设置版块内部的帖子数据
 */
@property (nonatomic, retain) PostsModel *postsModel;

@end
