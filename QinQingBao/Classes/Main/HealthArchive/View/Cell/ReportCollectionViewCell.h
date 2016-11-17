//
//  ReportCollectionViewCell.h
//  QinQingBao
//
//  Created by 董徐维 on 2016/11/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) NSIndexPath *idxPath;

@property (copy)void(^deleteImageBlock)(NSIndexPath *idx);

@end
