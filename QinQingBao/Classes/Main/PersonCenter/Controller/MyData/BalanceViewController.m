//
//  BalanceViewController.m
//  QinQingBao
//   我的余额
//  Created by 董徐维 on 16/5/4.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "BalanceViewController.h"

@interface BalanceViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation BalanceViewController

-(instancetype)init
{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView
{
    self.headView.layer.cornerRadius = self.headView.height/2;
    
    self.rechargeBtn.layer.borderColor = [[UIColor colorWithRGB:@"cccccc"] CGColor];
    self.rechargeBtn.layer.borderWidth = 0.5;
    
    self.table.delegate = self;
    self.table.dataSource = self;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *commoncell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonCell"];
    
    if (commoncell == nil)
        commoncell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MTCommonCell"];
    
    commoncell.textLabel.text = @"服务详情";
    
    return commoncell;
}



@end
