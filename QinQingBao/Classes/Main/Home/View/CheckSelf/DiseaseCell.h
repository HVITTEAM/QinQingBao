//
//  DiseaseCell.h
//  QinQingBao
//
//  Created by shi on 16/1/22.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DiseaseModel;

@interface DiseaseCell : UITableViewCell

@property(strong,nonatomic)DiseaseModel *diseasemodel;       //DiseaseCell 的内容

/**
 *  创建一个 DiseaseCell(可能疾病 cell)
 */
-(DiseaseCell *)initDiseaseCellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)idx;

/**
 *  获取行高   /model为 Cell 的内容
 */
-(CGFloat)getCellHeightWithModel:(DiseaseModel *)model tableView:(UITableView *)tableView;

@end
