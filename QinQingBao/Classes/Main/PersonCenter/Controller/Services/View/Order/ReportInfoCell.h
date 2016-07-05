//
//  ReportInfoCell.h
//  QinQingBao
//
//  Created by shi on 16/7/4.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WorkReportModel;

@interface ReportInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@property (weak, nonatomic) IBOutlet UILabel *contentLb;

+(instancetype)createCellWithTableView:(UITableView *)tableView;

-(void)computeCellHeight;

@end
