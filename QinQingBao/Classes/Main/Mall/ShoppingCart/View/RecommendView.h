//
//  RecommendView.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/9.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommendModel.h"

@interface RecommendView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, retain) UICollectionView *colectView;

@property (nonatomic, retain) NSMutableArray *dataProvider;

@property (nonatomic, copy) void (^clickClick)(CommendModel *item);

@end
