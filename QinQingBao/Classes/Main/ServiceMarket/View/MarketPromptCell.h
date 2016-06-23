//
//  PromptCell.h
//  QinQingBao
//
//  Created by shi on 16/6/21.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarketPromptCell : UITableViewCell

@property (copy,nonatomic)NSString *contentStr;

+(instancetype)createCellWithTableView:(UITableView *)tableView;

@end
