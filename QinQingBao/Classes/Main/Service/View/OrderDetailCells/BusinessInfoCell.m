//
//  BusinessInfoCell.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/6.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "BusinessInfoCell.h"

@implementation BusinessInfoCell

+(BusinessInfoCell *) businessCell
{
    BusinessInfoCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"BusinessInfoCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    self.contentView.backgroundColor = HMGlobalBg;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)callClickHandler:(id)sender
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",_itemInfo.orgphone]];
    [[UIApplication sharedApplication] openURL:url];
}

-(void)setItemInfo:(ServiceItemModel *)itemInfo
{
    _itemInfo = itemInfo;
    self.distanceLab.text = [NoticeHelper kilometre2meter:[itemInfo.distance floatValue]];
    self.nameLab.text = itemInfo.orgname;
    self.addressLab.text = itemInfo.orgaddress;
    self.telLab.text = [NSString stringWithFormat:@"联系电话:  %@",itemInfo.orgphone];
}
@end
