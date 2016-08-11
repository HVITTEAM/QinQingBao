//
//  ExamCell.h
//  QinQingBao
//
//  Created by shi on 16/8/11.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ExamModel;

@interface ExamCell : UITableViewCell

+(instancetype)createCellWithTableView:(UITableView *)tableView;

-(void)setModelWith:(ExamModel *)model;

@end
