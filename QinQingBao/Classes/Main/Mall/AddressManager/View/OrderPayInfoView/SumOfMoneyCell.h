//
//  SumOfMoneyCell.h
//  QinQingBao
//
//  Created by Dual on 16/1/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SumOfMoneyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sumOfMoney;  //金额
@property (weak, nonatomic) IBOutlet UILabel *freight; //运费

+ (SumOfMoneyCell *)sumOfMoneyCell;
@end
