//
//  BusinessInfoCell.h
//  QinQingBao
//
//  Created by 董徐维 on 15/9/6.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceItemModel.h"

@interface BusinessInfoCell : UITableViewCell<UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *addressLab;
@property (strong, nonatomic) IBOutlet UILabel *distanceLab;
@property (nonatomic, retain) ServiceItemModel *itemInfo;
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *addressLabHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bgviewHeight;
- (IBAction)chatButtonHandler:(id)sender;
- (IBAction)mapButtonHandler:(id)sender;

+(BusinessInfoCell *) businessCell;

@property (nonatomic, retain) UIViewController *parentViewcontroller;
@end
