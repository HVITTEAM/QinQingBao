//
//  VariousGenesCell.h
//  QinQingBao
//
//  Created by 董徐维 on 2017/1/10.
//  Copyright © 2017年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenesModel.h"

@interface VariousGenesCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIView *content;
@property (weak, nonatomic) IBOutlet UIView *targetView;
@property (weak, nonatomic) IBOutlet UITextView *descTxtview;

@property (nonatomic, retain) GenesModel *dataItem;

+ (VariousGenesCell*) variousGenesCell;
@end
