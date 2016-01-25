//
//  FoodCell.h
//  QinQingBao
//
//  Created by shi on 16/1/22.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodCell : UITableViewCell

@property(strong,nonatomic)NSString *titleStr;             //标题(宜吃食物或忌吃食物)

@property(strong,nonatomic)NSString *contentStr;           //宜吃食物或忌吃食物具体内容

/**
 *  创建一个 FoodCell(宜吃食物或忌吃食物cell)
 */
-(FoodCell *)initFoodCellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)idx;

/**
 *  根据titleStr和contentStr设置 cell 内容。给 cell赋完值之后需手动调用一次
 */
-(void)setupCell;

/**
 *  获取行高
 */
-(CGFloat)getCellHeightWithTableView:(UITableView *)tableView;

@end
