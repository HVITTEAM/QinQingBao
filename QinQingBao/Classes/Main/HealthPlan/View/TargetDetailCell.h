//
//  TargetDetailCell.h
//  QinQingBao
//
//  Created by 董徐维 on 2017/1/6.
//  Copyright © 2017年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenesModel.h"

@interface TargetDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *content;
@property (weak, nonatomic) IBOutlet UIView *targetView;
@property (weak, nonatomic) IBOutlet UITextView *descTxtview;


+ (TargetDetailCell*) targetDetailCell;

@property (nonatomic, retain) GenesModel *dataItem;

@property (nonatomic, copy) NSString *paragraphValue;

@end
