//
//  OrderTimeCell.h
//  QinQingBao
//
//  Created by shi on 16/3/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTimeCell : UITableViewCell

@property (copy,nonatomic)void(^selectTimeCallBack)(NSMutableDictionary *,NSIndexPath *);

@property (strong,nonatomic)NSIndexPath *indexPath;

@property (strong,nonatomic)NSDictionary *cellData;

@end
