//
//  SubmitOrderCell.h
//  QinQingBao
//
//  Created by Dual on 16/1/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubmitOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (nonatomic ,copy) void (^clickSubmit)(UIButton *btn);


+(SubmitOrderCell *)submitOrder;
@end
