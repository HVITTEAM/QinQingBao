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
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"联系电话"
//                                                             delegate:self
//                                                    cancelButtonTitle:@"取消"
//                                               destructiveButtonTitle:nil
//                                                    otherButtonTitles:@"客服电话:96345",[NSString stringWithFormat:@"商家固话:%@",_itemInfo.orgtelnum],
//                                  _itemInfo.orgphone ? [NSString stringWithFormat:@"商家手机:%@",_itemInfo.orgphone] : nil,nil];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"联系电话"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"客服电话:0573-96345",nil];
    [actionSheet showInView:self];
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSURL *url  = [NSURL URLWithString:@"telprompt://0573-96345"];
    if (buttonIndex == 1)
        return;
    [[UIApplication sharedApplication] openURL:url];
}

-(void)setItemInfo:(ServiceItemModel *)itemInfo
{
    _itemInfo = itemInfo;
    self.titleLab.font = [UIFont systemFontOfSize:16];
    self.distanceLab.textColor = [UIColor darkGrayColor];
    self.nameLab.textColor = [UIColor darkGrayColor];
    self.addressLab.textColor = [UIColor darkGrayColor];
    self.telLab.textColor = [UIColor darkGrayColor];
    self.distanceLab.text = [NSString stringWithFormat:@"距我 %@",[NoticeHelper kilometre2meter:[itemInfo.distance floatValue]]];
    self.distanceLab.textColor = MTNavgationBackgroundColor;
//    self.nameLab.text = itemInfo.icontent;
    self.nameLab.hidden = YES;
    self.addressLab.text = [NSString stringWithFormat:@"地址: %@%@",itemInfo.totalname,itemInfo.orgaddress];
//    self.telLab.text = [NSString stringWithFormat:@"联系电话:  %@",itemInfo.orgtelnum ?  itemInfo.orgtelnum : itemInfo.orgphone];
}
@end
