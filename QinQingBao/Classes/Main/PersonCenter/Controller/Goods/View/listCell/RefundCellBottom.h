//
//  RefundCellBottom.h
//  QinQingBao
//
//  Created by shi on 16/2/29.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefundCellBottom : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *refundAmountLb;      //退款金额

@property (weak, nonatomic) IBOutlet UILabel *descLb;       //顶部的描述Label

@property (weak, nonatomic) IBOutlet UIButton *detailInfoBtn;        //详情按钮

+(RefundCellBottom *)refundCellBottomWithTableView:(UITableView *)tableView;

@end
