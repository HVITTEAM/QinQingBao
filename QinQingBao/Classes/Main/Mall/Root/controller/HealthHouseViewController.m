//
//  HealthHouseViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/28.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "HealthHouseViewController.h"
#import "GoodsCell.h"
#import "HouseTypeCell.h"

@interface HealthHouseViewController ()

@end

@implementation HealthHouseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)initTableViewSkin
{
    self.title = @"健康屋";
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = HMGlobalBg;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return  195;
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == 0)
    {
        HouseTypeCell *houseTypeCell = [tableView dequeueReusableCellWithIdentifier:@"MTHouseTypeCell"];
        houseTypeCell.nav = self.navigationController;
        if(houseTypeCell == nil)
            houseTypeCell = [HouseTypeCell houseTypeCell];
        cell = houseTypeCell;
    }
    return cell;
}


@end
