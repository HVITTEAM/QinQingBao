//
//  TextCell.h
//  QinQingBao
//
//  Created by shi on 16/8/16.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextCell : UITableViewCell

@property(strong,nonatomic)UITextField *field;

@property(strong)NSIndexPath *idx;

@property(copy)void(^contentChangeCallBack)(NSIndexPath *idx,NSString *contentStr);

+(instancetype)createCellWithTableView:(UITableView *)tableView;

@end
