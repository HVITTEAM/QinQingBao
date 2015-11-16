//
//  BusinessInfoCell.h
//  QinQingBao
//
//  Created by 董徐维 on 15/9/6.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceItemModel.h"

@interface BusinessInfoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *callBtn;
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *addressLab;
@property (strong, nonatomic) IBOutlet UILabel *telLab;
- (IBAction)callClickHandler:(id)sender;
@property (nonatomic, retain) ServiceItemModel *itemInfo;

+(BusinessInfoCell *) businessCell;
@end
