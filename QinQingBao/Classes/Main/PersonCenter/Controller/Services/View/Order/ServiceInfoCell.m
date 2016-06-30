//
//  ServiceInfoCell.m
//  QinQingBao
//
//  Created by shi on 16/3/22.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ServiceInfoCell.h"
#import "OrderModel.h"

@interface ServiceInfoCell ()
@property (weak, nonatomic) IBOutlet UILabel *SerialNumberLb;         //服务单号

@property (weak, nonatomic) IBOutlet UILabel *manLb;                  //服务对象

@property (weak, nonatomic) IBOutlet UILabel *phoneLb;               //电话

@property (weak, nonatomic) IBOutlet UILabel *addressLb;              //地址

@property (weak, nonatomic) IBOutlet UILabel *timeLb;                 //下单或预约时间

@property (weak, nonatomic) IBOutlet UILabel *ServiceProviderLb;       //服务商

@property (weak, nonatomic) IBOutlet UILabel *timeTitleLb;            //时间的标题UILabel

@end

@implementation ServiceInfoCell

+(instancetype)createServiceInfoCellWithTableView:(UITableView *)tableview
{
    static NSString *serviceInfoCellId = @"serviceInfoCell";
    ServiceInfoCell *cell = [tableview dequeueReusableCellWithIdentifier:serviceInfoCellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ServiceInfoCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDataWithOrderModel:(OrderModel *)orderModel
{
    self.SerialNumberLb.text = orderModel.wcode;
    self.manLb.text = orderModel.wname;
    self.phoneLb.text = orderModel.wtelnum;
    self.addressLb.text = [NSString stringWithFormat:@"%@%@",orderModel.totalname,orderModel.waddress];
    self.ServiceProviderLb.text = orderModel.orgname;
    
    NSDate *tempDate = [self.formatterIn dateFromString:orderModel.wtime];
    NSString *serviceTimeStr = [self.formatterOut stringFromDate:tempDate];
    self.timeLb.text = serviceTimeStr;
    
    //tid 43为理疗服务  44为健康检测
    self.timeTitleLb.text = @"预约时间";
    if ([orderModel.tid isEqualToString:@"44"]) {
        self.timeTitleLb.text = @"下单时间";
    }
}

@end
