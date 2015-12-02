//
//  HotCitiesCell.h
//  QinQingBao
//
//  Created by 董徐维 on 15/11/30.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotCitiesCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UICollectionView *collectView;

@property (nonatomic, retain) NSMutableArray *dataProvider;

+ (HotCitiesCell*) hotCitiesCell;

@property (nonatomic, copy) void (^selectedHandler)(UIButton *btn);

@end
