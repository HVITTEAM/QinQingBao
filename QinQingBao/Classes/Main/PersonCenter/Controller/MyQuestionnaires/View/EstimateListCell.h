//
//  EstimateListCell.h
//  QinQingBao
//
//  Created by shi on 16/7/27.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ReportListModel;

@interface EstimateListCell : UITableViewCell

@property(strong,nonatomic)ReportListModel *item;

@property(strong,nonatomic)NSDateFormatter *formatter;

+(instancetype)createCellWithTableView:(UITableView *)tableView;

@end
