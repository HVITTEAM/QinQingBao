//
//  GoodsTypeCell.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/26.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsTypeCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>

+ (GoodsTypeCell*) goodsTypeCell;
@property (nonatomic, retain) UINavigationController *nav;

@property (strong, nonatomic) IBOutlet UICollectionView *collectView;

@end
