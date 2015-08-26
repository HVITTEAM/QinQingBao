//
//  ServiceCell.h
//  QinQinBao
//
//  Created by 董徐维 on 15/6/15.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceMenuModel.h"

@protocol ServiceDelegate <NSObject>
- (void)servicecellClickHandler:(ServiceMenuModel *)cellData;
@end

@interface ServiceCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, retain) UICollectionView *collectView;

@property(nonatomic, retain) NSMutableArray *array;//创建一个数组属性 作为top菜单的数据源

@property (nonatomic, assign) id<ServiceDelegate> delegate;

@end
