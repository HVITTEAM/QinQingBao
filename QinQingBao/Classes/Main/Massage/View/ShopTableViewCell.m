//
//  ShopTableViewCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/4/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ShopTableViewCell.h"
#import "MapViewController.h"

@implementation ShopTableViewCell

- (IBAction)chatClickHandler:(id)sender
{
    NSURL *url  = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",self.item.orgtelnum]];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)mapClickHandler:(id)sender
{
    MapViewController *map = [[MapViewController alloc] init];
    map.latitude = self.item.orglat;
    map.longitude = self.item.orglon;
    map.address = self.item.totalname;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:map animated:YES completion:nil];
}

+ (ShopTableViewCell *)shopTableViewCell {
    ShopTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ShopTableViewCell" owner:self options:nil] firstObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)setItem:(ServiceItemModel *)item
{
    _item = item;
    
    self.nameLab.text = item.orgname;
    self.addressLab.text = item.totalname;
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Img,item.orglogo]];
    [self.iconImg sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
    self.distanceLab.text = [NoticeHelper kilometre2meter:[item.distance floatValue]];
    self.distanceLab.textColor = MTNavgationBackgroundColor;
}

@end
