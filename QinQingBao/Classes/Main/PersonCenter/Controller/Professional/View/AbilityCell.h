//
//  AbilityCell.h
//  QinQingBao
//
//  Created by shi on 16/10/10.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbilityCell : UITableViewCell

@property (strong, nonatomic) NSMutableDictionary *dict;

@property (copy)void(^textDidChangeCallBack)(NSString *contentStr);

+ (instancetype)createCellWithTableView:(UITableView *)tableView;



@end
