//
//  TextTwoCell.h
//  QinQingBao
//
//  Created by shi on 16/8/16.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextTwoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@property (weak, nonatomic) IBOutlet UILabel *placeHolderLb;

@property(strong)NSIndexPath *idx;

@property(copy)void(^contentChangeCallBack)(NSIndexPath *idx,NSString *contentStr);

+(instancetype)createCellWithTableView:(UITableView *)tableView;

@end
