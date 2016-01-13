//
//  DefaultAddressCell.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/9.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MallAddressModel.h"

@interface DefaultAddressCell : UITableViewCell
+(DefaultAddressCell *)defaultAddressCell;

- (void)setItem:(MallAddressModel*)item;

/**
 *  定位地址图标
 */
@property (strong, nonatomic) UIImageView *locationImg;

/**
 *  收货人
 */
@property (strong, nonatomic) UILabel *nameLab;

/**
 *  地址
 */
@property (strong, nonatomic) UILabel *addressLab;

/**
 *  联系电话
 */
@property (strong, nonatomic) UILabel *telLab;
@end
