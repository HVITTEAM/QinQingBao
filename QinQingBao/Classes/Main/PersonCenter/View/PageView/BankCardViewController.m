//
//  BankCardViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/8/26.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "BankCardViewController.h"

@interface BankCardViewController ()

@end

@implementation BankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = HMGlobalBg;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *listViewCellId = @"bankCardCell";
    BankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:listViewCellId];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"BankCardCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }
    return  cell;
}
@end
