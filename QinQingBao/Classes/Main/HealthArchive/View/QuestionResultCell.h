//
//  QuestionResultCell.h
//  QinQingBao
//
//  Created by shi on 2016/11/7.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionResultCell : UITableViewCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView;

- (void)setItem;

@end
