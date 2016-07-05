//
//  CustomInfoCell.h
//  QinQingBao
//
//  Created by shi on 16/7/4.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLb;

@property (weak, nonatomic) IBOutlet UILabel *phoneNumLb;

@property (weak, nonatomic) IBOutlet UILabel *emailLb;

@property (weak, nonatomic) IBOutlet UILabel *addressLb;

+(instancetype)createCellWithTableView:(UITableView *)tableView;

@end
