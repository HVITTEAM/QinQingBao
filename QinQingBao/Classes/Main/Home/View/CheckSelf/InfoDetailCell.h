//
//  DiseaseDetailCell.h
//  QinQingBao
//
//  Created by shi on 16/1/23.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoDetailCell : UITableViewCell

@property(strong,nonatomic)NSString *contentStr;        //InfoDetailCell 的内容

/**
 *  创建一个 InfoDetailCell（疾病详情/症状详情等 cell）
 */
-(InfoDetailCell *)initInfoDetailWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)idx;

/**
 *  获取行高   /contentStr为 Cell 的内容
 */
-(CGFloat)getCellHeightWithContent:(NSString *)contentStr tableView:(UITableView *)tableView;

@end
