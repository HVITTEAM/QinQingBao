//
//  ScrollMenuTableCell.h
//  Scroll
//
//  Created by shi on 16/9/10.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollMenuView.h"

@interface ScrollMenuTableCell : UITableViewCell

@property (assign, nonatomic) NSInteger row;    //每页多少行

@property (assign, nonatomic) NSInteger col;    //每页多少列

@property (assign, nonatomic)UIEdgeInsets margin;  //四周边距

@property (assign, nonatomic)CGFloat rowSpace;     //cell内部的行间距

@property (assign, nonatomic)CGFloat colSpace;     //cell内部的列间距

@property (assign,nonatomic)BOOL shouldShowIndicator;   //是否显示滚动指示器

@property (strong, nonatomic)NSArray <NSDictionary<NSString *,NSString*> *> *datas;   //数据源

@property (copy)void(^selectMenuItemCallBack)(NSInteger idx);

+ (ScrollMenuTableCell *)createCellWithTableView:(UITableView *)tableView;

@end
