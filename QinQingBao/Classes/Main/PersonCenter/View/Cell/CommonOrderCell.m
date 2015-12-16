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
    self.addressLab.text = [NSString stringWithFormat:@"客户地址: %@%@",item.totalname,item.waddress];
    self.titleLab.text = item.tname;
    self.statusLab.text = [self getStatusByStatus:[item.status intValue]];
    self.namaLab.text = [NSString stringWithFormat:@"服务对象: %@",item.wname];
}

-(NSString *)getStatusByStatus:(int)status
{
    NSString *str;
    if (status <= 8)
    {
        str = @"等待接单";
        self.statusLab.textColor = [UIColor orangeColor];
        self.deleteBtn.titleLabel.text = @"取消订单";
    }
    else if (status <20)
    {
        str = @"已接单";
        self.statusLab.textColor = [UIColor orangeColor];
        self.deleteBtn.titleLabel.text = @"联系商家";
    }
    else if (status >20 && status < 29)
    {
        self.statusLab.hidden = YES;
        self.deleteBtn.hidden = YES;
    }
    else if ( status >30 && status < 39)
    {
        str = @"服务结束";
        self.statusLab.textColor = [UIColor orangeColor];
        self.deleteBtn.titleLabel.text = @"评价";
    }
    else if ( status >40 && status < 49)
    {
        str = @"未评价";
        self.statusLab.textColor = [UIColor orangeColor];
        self.deleteBtn.titleLabel.text = @"联系商家";
    }
    else if ( status >50 && status < 59)
    {
        str = @"已取消";
        self.statusLab.textColor = MTNavgationBackgroundColor;
        self.deleteBtn.hidden = YES;
        
    }
    else if ( status >60 && status < 69)
    {
        str = @"已拒单";
        self.statusLab.textColor = MTNavgationBackgroundColor;
        self.deleteBtn.hidden = YES;
    }
    else if ( status >80 && status < 89)
    {
        str = @"完成";
        self.statusLab.textColor = MTNavgationBackgroundColor;
        self.deleteBtn.hidden = YES;
    }
    else if ( status >100 && status < 109)
    {
        str = @"投诉中";
        self.statusLab.textColor = [UIColor orangeColor];
        if (status == 102)
            self.deleteBtn.hidden = YES;
        else if (status == 109)
            self.deleteBtn.hidden = NO;
    }
    else if ( status >110 && status < 119)
    {
        str = @"退货中";
        self.statusLab.textColor = [UIColor orangeColor];
        self.deleteBtn.hidden = YES;
    }
    
    return str;
}

- (IBAction)deleteBtnClickHandler:(id)sender
{
    self.deleteClick(sender);
}
@end
