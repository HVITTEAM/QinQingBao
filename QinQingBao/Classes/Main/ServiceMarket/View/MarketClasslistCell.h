//
//  MarketClasslistCell.h
//  QinQingBao
//
//  Created by shi on 16/8/15.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarketClasslistCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

+(instancetype)createCellWithTableView:(UITableView *)tableView;

@end
