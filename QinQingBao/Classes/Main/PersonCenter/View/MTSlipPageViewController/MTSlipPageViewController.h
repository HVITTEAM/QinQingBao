//
//  MTSlipPageViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 15/8/26.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTSlipPageViewController : UIView<UIScrollViewDelegate>


@property (nonatomic, strong)  UIScrollView *rootScrollView;
@property (nonatomic, strong)  UIView *headScrollView;
@property (nonatomic, strong)  UIImageView *shadowImageView;

@property (nonatomic, strong) NSMutableArray *buttonArr;
@property (nonatomic, strong) NSMutableArray *viewArr;


@property (nonatomic, assign) NSInteger selectedIndex;

/**是否是点击了headBtn**/
@property (nonatomic, assign) BOOL isUseButtonClick;

@end
