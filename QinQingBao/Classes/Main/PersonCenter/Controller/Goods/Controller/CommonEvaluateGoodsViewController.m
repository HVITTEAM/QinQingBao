//
//  CommonEvaluateGoodsViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/15.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CommonEvaluateGoodsViewController.h"
#import "CommonOrderGoodsEvaCell.h"

@interface CommonEvaluateGoodsViewController ()

@end

@implementation CommonEvaluateGoodsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    CommonOrderGoodsEvaCell *commoncell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonOrderGoodsEvaCell"];
    
    if(commoncell == nil)
        commoncell = [CommonOrderGoodsEvaCell commonOrderGoodsEvaCell];
    
    //        [commoncell setitemWithData:self.item];
    cell = commoncell;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


@end
