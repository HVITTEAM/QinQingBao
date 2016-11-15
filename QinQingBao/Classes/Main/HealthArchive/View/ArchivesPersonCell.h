//
//  ArchivesPersonCell.h
//  QinQingBao
//
//  Created by shi on 2016/11/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArchivesPersonCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLb;

@property (weak, nonatomic) IBOutlet UIImageView *badgeIcon;

@property (weak, nonatomic) IBOutlet UIView *contentV;

+ (instancetype)createCellWithTableView:(UITableView *)tableView;

@end
