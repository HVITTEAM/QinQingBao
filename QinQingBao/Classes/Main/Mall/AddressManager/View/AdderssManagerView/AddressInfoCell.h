//
//  AddressInfoCell.h
//  QinQingBao
//
//  Created by Dual on 16/1/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MallAddressModel.h"

@interface AddressInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *chooseLable;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;


+ (AddressInfoCell *)addressInfoCell;

-(void)setItem:(MallAddressModel *)item;
@end
