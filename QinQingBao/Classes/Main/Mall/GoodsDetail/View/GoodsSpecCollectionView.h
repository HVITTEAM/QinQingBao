//
//  GoodsSpecCollectionView.h
//  QinQingBao
//
//  Created by 董徐维 on 16/2/26.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsTypeModel.h"

@interface GoodsSpecCollectionView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, retain) UICollectionView *colectView;

@property (nonatomic, retain) NSMutableArray *dataProvider;

@property (nonatomic, copy) void (^loadViewRepleteBlock)(void);

@property (nonatomic, copy) void (^selectedBlock)(NSMutableArray *dataProvider);


@end
