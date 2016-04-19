//
//  ShopOrderInfoCell.m
//  QinQingBao
//
//  Created by shi on 16/4/15.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ShopOrderInfoCell.h"
#import "MapViewController.h"

@interface ShopOrderInfoCell ()

@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *addressLab;
@property (strong, nonatomic) IBOutlet UILabel *distanceLab;

@property (strong, nonatomic) IBOutlet UIButton *chatBtn;
@property (strong, nonatomic) IBOutlet UIButton *mapBtn;

- (IBAction)chatClickHandler:(id)sender;

- (IBAction)mapClickHandler:(id)sender;

@end
@implementation ShopOrderInfoCell

+(instancetype)createShopOrderInfoCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)idx
{
    static NSString *shopOrderInfoCellId = @"shopOrderInfoCell";
    ShopOrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:shopOrderInfoCellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ShopOrderInfoCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

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

-(void)setItem:(ServiceItemModel *)item
{
    _item = item;
    self.nameLab.text = item.orgname;
    self.addressLab.text = item.totalname;
    self.distanceLab.text = [NoticeHelper kilometre2meter:[item.distance floatValue]];
    self.distanceLab.textColor = MTNavgationBackgroundColor;
}

@end
