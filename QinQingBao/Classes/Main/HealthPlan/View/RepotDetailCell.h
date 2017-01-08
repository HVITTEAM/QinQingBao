//
//  RepotDetailCell.h
//  QinQingBao
//
//  Created by 董徐维 on 2017/1/5.
//  Copyright © 2017年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenesModel.h"

typedef NS_ENUM(NSUInteger, MTCellBorderType) {
    MTCellBorderTypeTOP,
    MTCellBorderTypeBottom,
    MTCellBorderTypeTOPAll,
    MTCellBorderTypeTOPNone
};

@interface RepotDetailCell : UITableViewCell

+ (RepotDetailCell*) repotDetailCell;

@property (nonatomic, assign) MTCellBorderType borderType;

@property (strong, nonatomic) IBOutlet UITextView *txtView;

@property (nonatomic, copy) NSString *paragraphValue;

@property (nonatomic, retain) GenesModel *dataItem;

@end
