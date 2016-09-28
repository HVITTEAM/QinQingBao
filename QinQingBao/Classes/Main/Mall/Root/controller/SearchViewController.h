//
//  SearchViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/11.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryViewCell.h"

#ifndef kSearchType
#define kSearchType

typedef NS_ENUM(NSInteger, SearchType) {
    SearchTypeMall = 0,    //商城
    SearchTypePosts        //帖子
};

#endif

@interface SearchViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, retain) UICollectionView *collectView;

@property (nonatomic, strong) HistoryViewCell *cell;

@property (assign, nonatomic) SearchType type;

@end
