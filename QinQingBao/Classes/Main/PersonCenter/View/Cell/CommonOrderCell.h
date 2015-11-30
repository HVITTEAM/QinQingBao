//
//  CommonOrderCell.h
//  QinQinBao
//
//  Created by 董徐维 on 15/6/24.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface CommonOrderCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *topSapce;
@property (strong, nonatomic) IBOutlet UIView *bottomSpace;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
@property (strong, nonatomic) IBOutlet UILabel *namaLab;

@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UILabel *statusLab;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;
@property (strong, nonatomic) IBOutlet UILabel *addressLab;


- (IBAction)deleteBtnClickHandler:(id)sender;
@property (nonatomic, copy) void (^deleteClick)(UIButton *btn);

+(CommonOrderCell *) commonOrderCell;

@property (nonatomic, retain) OrderModel *item;

@end
