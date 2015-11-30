//
//  CommonOrderCell.m
//  QinQinBao
//
//  Created by 董徐维 on 15/6/24.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "CommonOrderCell.h"

@implementation CommonOrderCell


+(CommonOrderCell *) commonOrderCell
{
    CommonOrderCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"CommonOrderCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - 调整子控件的位置
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.topSapce.backgroundColor = HMColor(234, 234, 234);
    self.bottomSpace.backgroundColor = HMColor(234, 234, 234);
    
    self.deleteBtn.layer.borderWidth = 1;
    self.deleteBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    self.deleteBtn.layer.cornerRadius = 8;
}

-(void)setItem:(OrderModel *)item
{
    _item = item;
    self.timeLab.text = [NSString stringWithFormat:@"下单时间: %@",item.wctime];
    self.addressLab.text = [NSString stringWithFormat:@"客户地址: %@",item.waddress];
    self.titleLab.text = item.icontent;
    self.statusLab.text = [self getStatusByStatus:[item.status intValue]];
    self.namaLab.text = [NSString stringWithFormat:@"服务对象: %@",item.wname];
}

-(NSString *)getStatusByStatus:(int)status
{
    NSString *str;
    switch (status) {
        case 0:
            str = @"等待接单";
            break;
        case 1:
            str = @"等待接单";
            break;
        case 2:
            str = @"等待接单";
            break;
        case 3:
            str = @"已接单";
            self.deleteBtn.titleLabel.text = @"联系商家";
            break;
        case 4:
            str = @"已接单";
            self.deleteBtn.titleLabel.text = @"联系商家";
            break;
        case 5:
            str = @"服务结束";
            self.deleteBtn.titleLabel.text = @"评价";
            break;
        case 6:
            str = @"已评价";
            break;
        case 7:
            str = @"已评价";
            break;
        case 8:
            str = @"取消受理中";
            self.deleteBtn.titleLabel.text = @"联系商家";
            break;
        case 9:
            str = @"已取消";
            break;
        case 10:
            str = @"已拒单";
            self.deleteBtn.titleLabel.text = @"联系商家";
            break;
        default:
            break;
    }

    return str;
}

- (IBAction)deleteBtnClickHandler:(id)sender
{
    self.deleteClick(sender);
}
@end
