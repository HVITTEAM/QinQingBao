//
//  AddressTableViewController.m
//  QinQingBao
//
//  Created by Dual on 16/1/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "AddressTableViewController.h"
#import "AddressInfoCell.h"
#import "AddressManagerTableViewController.h"

#import "AddressListTotal.h"
@interface AddressTableViewController ()
{
    NSMutableArray *addressDataProvider;
}

@end

@implementation AddressTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self getDataProvider];
}

-(void)initView
{
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.title = @"收货地址";
    UIBarButtonItem *manager = [[UIBarButtonItem alloc] initWithTitle:@"管理" style:UIBarButtonItemStyleDone target:self action:@selector(managerHander)];
    self.navigationItem.rightBarButtonItem = manager;
}

-(void)getDataProvider
{
    [CommonRemoteHelper RemoteWithUrl:URL_Address_list parameters: @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                     @"client" : @"ios",
                                                                     @"page" : @100}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     AddressListTotal *result = [AddressListTotal objectWithKeyValues:dict];
                                     addressDataProvider = result.datas;
                                     if (addressDataProvider.count == 0)
                                         [self.tableView initWithPlaceString:@"暂无数据!"];
                                     [self.tableView reloadData];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"出错了....");
                                 }];
}

- (void)managerHander
{
    AddressManagerTableViewController *addressManager = [AddressManagerTableViewController new];
    [self.navigationController pushViewController:addressManager animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return addressDataProvider.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
        cell = [AddressInfoCell addressInfoCell];
    
    [cell setItem:addressDataProvider[indexPath.row]];
    
    if (indexPath.row == 0)
    {
        cell.chooseLable.alpha = 1;
        cell.chooseBtn.alpha = 1;
    }
    
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedAddressModelBlock)
    {
        self.selectedAddressModelBlock(addressDataProvider[indexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
