//
//  SiglePicCardCell.h
//  QinQingBao
//
//  Created by shi on 16/9/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostsModel.h"

@interface SiglePicCardCell : UITableViewCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView;

/**
 *  设置数据
 */
@property (nonatomic, retain) PostsModel *itemdata;

@property (nonatomic, copy) void (^portraitClick)(PostsModel *postsModel);

@end
