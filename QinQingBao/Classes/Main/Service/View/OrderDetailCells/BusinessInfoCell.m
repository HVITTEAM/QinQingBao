//
//  BusinessInfoCell.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/6.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "BusinessInfoCell.h"
#import "MapViewController.h"

@implementation BusinessInfoCell

- (IBAction)chatButtonHandler:(id)sender
{
    NSLog(@"chat");
    //----------------------------
    self.callBusinsee(sender);
    //----------------------------
}

- (IBAction)mapButtonHandler:(id)sender
{
    MapViewController *map = [[MapViewController alloc] init];
    map.address = [NSString stringWithFormat:@"%@%@",_itemInfo.totalname,_itemInfo.orgaddress];;
    map.latitude = _itemInfo.orglat;
    map.longitude = _itemInfo.orglon;
    [self.parentViewcontroller presentViewController:map animated:YES completion:nil];
}

+(BusinessInfoCell *) businessCell
{
    BusinessInfoCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"BusinessInfoCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    self.contentView.backgroundColor = HMGlobalBg;
}

- (IBAction)callClickHandler:(id)sender
{
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
    self.distanceLab.text = [NSString stringWithFormat:@"距我 %@",[NoticeHelper kilometre2meter:[itemInfo.distance floatValue]]];
    self.distanceLab.textColor = MTNavgationBackgroundColor;
    self.nameLab.hidden = YES;
    self.addressLab.text = [NSString stringWithFormat:@"地址: %@%@",itemInfo.totalname,itemInfo.orgaddress];
    self.addressLab.numberOfLines = 0;
    CGRect size = [self.addressLab.text boundingRectWithSize:CGSizeMake(MTScreenW - 20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.addressLab.font,NSFontAttributeName, nil] context:nil];
    self.addressLabHeight.constant = size.size.height+5;
    self.bgviewHeight.constant = self.addressLab.y + size.size.height + 53;
    self.height = self.bgviewHeight.constant + 5;
}
@end
