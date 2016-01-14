//
//  MallEvaCell.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MallEvaCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *button;

@property (nonatomic, copy) void (^checkClick)(UIButton *btn);

+(MallEvaCell *)mallEvaCell;
@end
