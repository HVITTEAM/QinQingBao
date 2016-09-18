//
//  ScrollMenuLayout.h
//  Scroll
//
//  Created by shi on 16/9/10.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollMenuLayout : UICollectionViewLayout

@property (assign, nonatomic) NSInteger row;    //每页多少行

@property (assign, nonatomic) NSInteger col;    //每页多少列

@property (assign, nonatomic)UIEdgeInsets margin;

@property (assign, nonatomic)CGFloat rowSpace;

@property (assign, nonatomic)CGFloat colSpace;

@end
