//
//  ScrollMenuView.h
//  Scroll
//
//  Created by shi on 16/9/10.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const KScrollMenuTitle;
extern NSString *const KScrollMenuImg;

@interface ScrollMenuView : UIView

@property (assign, nonatomic) NSInteger row;    //每页多少行

@property (assign, nonatomic) NSInteger col;    //每页多少列

@property (assign, nonatomic)UIEdgeInsets margin;  //四周边距,这个边距不包括滚动指示器在内

@property (assign, nonatomic)CGFloat rowSpace;     //cell内部的行间距

@property (assign, nonatomic)CGFloat colSpace;     //cell内部的列间距

@property (assign, nonatomic)BOOL shouldShowIndicator;   //是否显示滚动指示器

@property (strong, nonatomic)NSArray<NSDictionary<NSString *,NSString*> *> *datas;   //数据源

@property (copy)void(^tapScrollMenuItemCallBack)(NSInteger idx);

@end
