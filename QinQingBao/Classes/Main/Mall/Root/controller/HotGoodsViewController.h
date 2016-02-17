//
//  HotGoodsViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 16/2/1.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendGoodsModel.h"

@interface HotGoodsViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, retain) UICollectionView *colectView;

@property (nonatomic, retain) NSMutableArray *dataProvider;

@property (nonatomic, copy) NSString *special_id;
@end
