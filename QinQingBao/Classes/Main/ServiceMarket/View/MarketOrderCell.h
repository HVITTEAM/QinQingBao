//
//  MarketOrderCell.h
//  QinQingBao
//
//  Created by shi on 16/6/21.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MassageModel.h"

@interface MarketOrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLb;

+(instancetype)createCellWithTableView:(UITableView *)tableView;

@property (nonatomic, copy) void (^chatClick)(UIButton *btn);


-(void)setItem:(MassageModel *)dataItem;

@end
