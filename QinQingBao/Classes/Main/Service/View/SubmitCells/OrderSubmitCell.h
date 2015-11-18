//
//  OrderSubmitCell.h
//  QinQingBao
//
//  Created by 董徐维 on 15/9/8.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderSubmitCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *submitBtn;

@property (nonatomic, copy) void (^payClick)(UIButton *btn);

- (IBAction)submitClickHandler:(id)sender;

+(OrderSubmitCell *) orderSubmitCell;
@end
