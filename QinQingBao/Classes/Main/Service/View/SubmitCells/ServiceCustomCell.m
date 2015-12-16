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
    
    // Configure the view for the selected state
}

-(void)setdataWithItem:(FamilyModel *)item
{
    NSString *str = [NoticeHelper intervalSinceNowByyear:@"2008-01-01"];
    self.nameLab.text = item.member_truename;
    self.phoneLab.text = item.member_mobile;
    self.addressLab.text = [NSString stringWithFormat:@"%@%@",item.totalname,item.member_areainfo];
    self.sexLab.text = [item.member_sex isEqualToString:@"1"] ? @"男" : @"女";
    self.ageLab.text = str;
}


@end
