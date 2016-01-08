//
//  ServiceCustomCell.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/14.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "ServiceCustomCell.h"

@implementation ServiceCustomCell

+ (ServiceCustomCell*) serviceCustomCell
{
    ServiceCustomCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"ServiceCustomCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)changeAddressHandler:(id)sender
{
    self.changeAddressClick((UIButton *)sender);
}

-(void)setdataWithItem:(FamilyModel *)item
{
    NSString *str = [NoticeHelper intervalSinceNowByyear:item.member_birthday];
    self.nameLab.text = item.member_truename;
    self.phoneLab.text = item.member_mobile;
    self.addressLab.editable = NO;
    self.addressWidth.constant = MTScreenW - 90 - 50;
    if (!item.totalname || !item.member_areainfo)
        self.addressLab.text = @"";
    else
        self.addressLab.text = [NSString stringWithFormat:@"%@%@",item.totalname,item.member_areainfo];
    self.sexLab.text = [item.member_sex isEqualToString:@"1"] ? @"男" : [item.member_sex isEqualToString:@"3"] ? @"保密" : @"女";
    self.ageLab.text = str;
}


@end
