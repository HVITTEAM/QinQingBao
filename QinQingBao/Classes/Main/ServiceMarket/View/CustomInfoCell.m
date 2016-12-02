//
//  CustomInfoCell.m
//  QinQingBao
//
//  Created by shi on 16/7/4.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CustomInfoCell.h"
#import "MarketCustomInfo.h"

@implementation CustomInfoCell

+(instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"customInfoCell";
    CustomInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CustomInfoCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.nameLb.text = nil;
    self.phoneNumLb.text = nil;
    self.emailLb.text = nil;
    self.addressLb.text = nil;
    self.sexLb.text = nil;
    self.birthdayLb.text = nil;
    self.heightLb.text = nil;
    self.weightLb.text = nil;
    self.womanSpecial.text = nil;
    self.caseHistoryLb.text = nil;
    self.medicationLb.text = nil;
}

-(void)setdataWithCustomInfo:(MarketCustomInfo *)aCustomInfo
{
    UIColor *valueColor = [UIColor grayColor];
    UIColor *noValueColor = [UIColor lightGrayColor];
    
    //姓名
    self.nameLb.text = aCustomInfo.name.length > 0 ? aCustomInfo.name : @"必填项，请填写姓名";
    self.nameLb.textColor = aCustomInfo.name.length > 0 ? valueColor : noValueColor;
    
    //手机号码
    self.phoneNumLb.text = aCustomInfo.tel.length > 0 ? aCustomInfo.tel : @"必填项，请填写手机号码" ;
    self.phoneNumLb.textColor = aCustomInfo.tel.length > 0 ? valueColor : noValueColor;
    
    //邮箱
    self.emailLb.text = aCustomInfo.email.length > 0 ? aCustomInfo.email : @"必填,例sample@hvit.com.cn";
    self.emailLb.textColor = aCustomInfo.email.length > 0  ? valueColor : noValueColor;
    
    //地址
    if (aCustomInfo.totalname && aCustomInfo.areainfo)
    {
        self.addressLb.text = [NSString stringWithFormat:@"%@%@",aCustomInfo.totalname,aCustomInfo.areainfo];
        self.addressLb.textColor =  valueColor;
    }
    else
    {
        self.addressLb.text = @"必填项，请填写地址";
        self.addressLb.textColor = noValueColor;
    }
    
    self.sexLb.text = aCustomInfo.sex.length > 0 ? aCustomInfo.sex: @"选填";
    self.sexLb.textColor = aCustomInfo.sex.length > 0 ? valueColor: noValueColor;
    
    self.birthdayLb.text = aCustomInfo.birthday.length > 0 ? aCustomInfo.birthday: @"选填";
    self.birthdayLb.textColor = aCustomInfo.birthday.length > 0 ? valueColor: noValueColor;
    
    self.heightLb.text = aCustomInfo.height.length > 0 ? [NSString stringWithFormat:@"%@ cm",aCustomInfo.height]: @"选填";
    self.heightLb.textColor = aCustomInfo.height.length > 0 ? valueColor: noValueColor;
    
    self.weightLb.text = aCustomInfo.weight.length > 0 ? [NSString stringWithFormat:@"%@ kg",aCustomInfo.weight]: @"选填";
    self.weightLb.textColor = aCustomInfo.weight.length > 0 ? valueColor: noValueColor;
    
    self.womanSpecial.text = aCustomInfo.womanSpecial.length > 0 ? aCustomInfo.womanSpecial: @"选填";
    self.womanSpecial.textColor = aCustomInfo.womanSpecial.length > 0 ? valueColor: noValueColor;
    
    self.caseHistoryLb.text = aCustomInfo.caseHistory.length > 0 ? aCustomInfo.caseHistory: @"选填";
    self.caseHistoryLb.textColor = aCustomInfo.caseHistory.length > 0 ? valueColor: noValueColor;
    
    self.medicationLb.text = aCustomInfo.medicine.length > 0 ? aCustomInfo.medicine: @"选填";
    self.medicationLb.textColor = aCustomInfo.medicine.length > 0 ? valueColor: noValueColor;
}

-(void)setupCellHeight
{
    self.width = MTScreenW;
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
    
    if (self.isExtend) {
        self.height = CGRectGetMaxY(self.medicationLb.frame) + 13;
        return;
    }
    
    self.height = CGRectGetMaxY(self.addressLb.frame) + 13;
}


@end
