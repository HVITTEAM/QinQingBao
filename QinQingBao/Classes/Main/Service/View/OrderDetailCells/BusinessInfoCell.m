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
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"联系电话"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"客服电话:96345",[NSString stringWithFormat:@"商家固话:%@",_itemInfo.orgtelnum],
                                  _itemInfo.orgphone ? [NSString stringWithFormat:@"商家手机:%@",_itemInfo.orgphone] : nil,nil];
    [actionSheet showInView:self];
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSURL *url;
    switch (buttonIndex)
    {
        case 0:
            url = [NSURL URLWithString:@"telprompt://96345"];
            break;
        case 1:
            url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",_itemInfo.orgtelnum]];
            break;
        case 2:
            url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",_itemInfo.orgphone]];
            break;
        default:
            break;
    }
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
    
    self.distanceLab.text = [NoticeHelper kilometre2meter:[itemInfo.distance floatValue]];
    self.distanceLab.textColor = MTNavgationBackgroundColor;
    self.nameLab.text = itemInfo.orgname;
    self.addressLab.text = [NSString stringWithFormat:@"%@%@",itemInfo.totalname,itemInfo.orgaddress];
    self.telLab.text = [NSString stringWithFormat:@"联系电话:  %@",itemInfo.orgtelnum ?  itemInfo.orgtelnum : itemInfo.orgphone];
}
@end
