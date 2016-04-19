//
//  ShopTableViewCell.h
//  QinQingBao
//
//  Created by 董徐维 on 16/4/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceItemModel.h"

@interface ShopTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iconImg;
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *addressLab;
@property (strong, nonatomic) IBOutlet UILabel *distanceLab;

@property (strong, nonatomic) IBOutlet UIButton *chatBtn;
@property (strong, nonatomic) IBOutlet UIButton *mapBtn;
- (IBAction)chatClickHandler:(id)sender;
- (IBAction)mapClickHandler:(id)sender;
+ (ShopTableViewCell *)shopTableViewCell;

@property (nonatomic, retain) ServiceItemModel *item;
@end
