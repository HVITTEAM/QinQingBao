//
//  CardCell.h
//  QinQingBao
//
//  Created by shi on 16/9/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardCell : UITableViewCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView;

/**
 *  设置假数据
 */
- (void)setData;

@end
