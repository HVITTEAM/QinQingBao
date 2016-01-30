//
//  HistoryViewCell.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/27.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewCell : UICollectionViewCell
@property (nonatomic, copy) NSString *keyword;
- (CGSize)sizeForCell;
@end
