//
//  GoodsTypeCell.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/26.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectTypeCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>

+ (CollectTypeCell*) collectTypeCell;

@property (strong, nonatomic) IBOutlet UICollectionView *collectView;

@property (nonatomic, copy) void (^cellClick)(NSInteger cellTag);

@end
