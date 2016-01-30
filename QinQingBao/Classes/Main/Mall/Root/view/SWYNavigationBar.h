//
//  SWYNavigationBar.h
//  EQ_DisasterReport
//
//  Created by shi on 15/11/5.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NavigationBarDelegate;

@interface SWYNavigationBar : UIView
@property(nonatomic,strong)NSString *titleStr;                  //设置标题
@property(nonatomic,strong) UIView *titleView;                  //设置标题view，设置了标题view后标题会被覆盖
@property(nonatomic,weak)id<NavigationBarDelegate>delegate;

-(instancetype)initCustomNavigatinBar;

@end


@protocol NavigationBarDelegate <NSObject>
/**
 *  左侧按钮点击时回调
 */
-(void)navigationBar:(SWYNavigationBar *)naviBar didClickLeftBtn:(UIButton *)leftBtn;

/**
 *  右侧按钮点击时回调
 */
-(void)navigationBar:(SWYNavigationBar *)naviBar didClickRightBtn:(UIButton *)rightBtn;

@end