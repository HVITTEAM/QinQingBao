//
//  GoodsTitleCell.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsTitleCell : UITableViewCell

- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(int)rows;

+(GoodsTitleCell *)goodsTitleCell;

- (void)setItem;
@end
