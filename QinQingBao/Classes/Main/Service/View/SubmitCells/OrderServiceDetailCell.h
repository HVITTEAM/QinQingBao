//
//  ServiceDetailCell.h
//  QinQingBao
//
//  Created by 董徐维 on 15/11/6.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceItemModel.h"

@interface OrderServiceDetailCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *serviceIcon;
@property (strong, nonatomic) IBOutlet UILabel *serviceTitle;
@property (strong, nonatomic) IBOutlet UILabel *serviceDesc;
@property (strong, nonatomic) IBOutlet UILabel *servicePrice;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *detailLabWidth;

-(void)setdataWithItem:(ServiceItemModel *)item;

+(OrderServiceDetailCell *) orderServiceDetailCell;
@end
