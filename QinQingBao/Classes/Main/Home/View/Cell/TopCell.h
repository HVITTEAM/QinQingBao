//
//  TopCell.h
//  QinQingBao
//
//  Created by 董徐维 on 2016/11/3.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopCell : UITableViewCell
+ (TopCell*)topCell;
@property (strong, nonatomic) IBOutlet UIImageView *headicon;
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UILabel *timelab;
@property (strong, nonatomic) IBOutlet UILabel *zdlab;

@end
