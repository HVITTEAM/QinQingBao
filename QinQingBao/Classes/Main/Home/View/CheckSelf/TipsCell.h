//
//  TipsCell.h
//  QinQingBao
//
//  Created by shi on 16/1/23.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipsCell : UITableViewCell

@property(strong,nonatomic)NSString *contentStr;          // TipsCell (提示 cell)的内容

/**
 *  创建一个 TipsCell (提示 cell)
 */
-(TipsCell *)initTipsCellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)idx;

/**
 *  获取行高   /contentStr为 cell 的内容
 */
-(CGFloat)getCellHeightWithContent:(NSString *)contentStr tableView:(UITableView *)tableView;

@end
