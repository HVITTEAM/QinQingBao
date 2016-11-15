//
//  ArchivesCell.h
//  QinQingBao
//
//  Created by shi on 2016/11/7.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArchivesCell : UITableViewCell

///档案人员数据
@property (strong, nonatomic) NSMutableArray *relativesArr;

///是否显示图片的描边,用来显示选中状态
@property (assign, nonatomic) BOOL showBorderLine;

///新增一个档案
@property (copy)void(^addNewArchivesBlock)(void);

///扫码
@property (copy)void(^scanBlock)(void);

///点击一个已经存在的档案
@property (copy)void(^tapArchiveBlock)(NSUInteger selectedIdx);

+ (instancetype)createCellWithTableView:(UITableView *)tableView;

///获得cell高
+ (NSInteger) cellHeight;

@end
