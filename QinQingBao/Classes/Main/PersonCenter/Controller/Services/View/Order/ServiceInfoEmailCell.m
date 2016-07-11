//
//  ServiceInfoEmailCell.m
//  QinQingBao
//
//  Created by shi on 16/7/11.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ServiceInfoEmailCell.h"
#import "OrderModel.h"

@interface ServiceInfoEmailCell ()

@property (weak, nonatomic) IBOutlet UILabel *SerialNumberLb;         //服务单号

@property (weak, nonatomic) IBOutlet UILabel *manLb;                  //服务对象

@property (weak, nonatomic) IBOutlet UILabel *phoneLb;               //电话

@property (weak, nonatomic) IBOutlet UILabel *addressLb;              //地址

@property (weak, nonatomic) IBOutlet UILabel *timeLb;                 //下单或预约时间

@property (weak, nonatomic) IBOutlet UILabel *ServiceProviderLb;       //服务商

@property (weak, nonatomic) IBOutlet UILabel *timeTitleLb;            //时间的标题UILabel

@end

@implementation ServiceInfoEmailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
