//
//  MarketViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/6/21.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "MarketViewController.h"

#import "CommonMarketCell.h"

@interface MarketViewController ()

@end

@implementation MarketViewController

-(instancetype)init
{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HMGlobalBg;
    self.title = @"服务市场";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 190;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommonMarketCell *marketcell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonMarketCell"];
    
    if (marketcell == nil)
        marketcell = [CommonMarketCell commonMarketCell];
    
    return marketcell;
}



@end
