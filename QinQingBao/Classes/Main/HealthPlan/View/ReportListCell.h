//
//  ReportListCell.h
//  QinQingBao
//
//  Created by shi on 2016/10/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InterveneModel.h"
@interface ReportListCell : UITableViewCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView;

@property (nonatomic, retain) InterveneModel *item;
@end
