//
//  RemarkDetailCell.h
//  QinQingBao
//
//  Created by 董徐维 on 15/11/17.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceItemModel.h"

@interface RemarkDetailCell : UITableViewCell

@property (nonatomic, retain) ServiceItemModel *itemInfo;
@property (strong, nonatomic) IBOutlet UIView *topLine;
@property (strong, nonatomic) IBOutlet UILabel *titleLab;

+ (RemarkDetailCell*) remarkDetailCell;
@end
