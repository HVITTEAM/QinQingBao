//
//  GeneDetectionCell.h
//  QinQingBao
//
//  Created by 董徐维 on 2017/1/8.
//  Copyright © 2017年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenesModel.h"

@interface GeneDetectionCell : UITableViewCell

+ (GeneDetectionCell*) geneDetectionCell;

@property (nonatomic, retain) GenesModel *dataItem;

@property (nonatomic, copy) NSString *paragraphValue;

@end
