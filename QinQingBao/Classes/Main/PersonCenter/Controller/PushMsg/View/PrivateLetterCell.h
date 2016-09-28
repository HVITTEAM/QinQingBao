//
//  PrivateLetterCell.h
//  QinQingBao
//
//  Created by shi on 16/9/28.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllpriletterModel.h"

@interface PrivateLetterCell : UITableViewCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView;

@property (strong, nonatomic) AllpriletterModel *item;

@end
