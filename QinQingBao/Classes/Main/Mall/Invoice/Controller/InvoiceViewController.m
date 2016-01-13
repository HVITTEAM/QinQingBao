//
//  InvoiceViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/9.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "InvoiceViewController.h"
#import "InvoiceDetailViewController.h"

@interface InvoiceViewController ()
{
  
}

@end

@implementation InvoiceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"发票抬头";
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor  =HMGlobalBg;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    UITableViewCell *commoncell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonCell"];
    
    if (commoncell == nil)
        commoncell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MTCommonCell"];
    commoncell.textLabel.textColor = [UIColor colorWithRGB:@"333333"];
    commoncell.textLabel.font = [UIFont systemFontOfSize:14];
    commoncell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    commoncell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.row)
    {
        case 0:
            commoncell.textLabel.text = @"不需要发票";
            commoncell.imageView.image = [UIImage imageNamed:@"Unselected.png"];
            break;
        case 1:
            commoncell.textLabel.text = @"个人";
            commoncell.imageView.image = [UIImage imageNamed:@"Unselected.png"];
            break;
        case 2:
            commoncell.textLabel.text = @"企业";
            commoncell.imageView.image = [UIImage imageNamed:@"Unselected.png"];
            break;
        default:
            break;
    }
    cell = commoncell;
    
    if(self.selectedIndex == indexPath.row)
        commoncell.imageView.image = [UIImage imageNamed:@"Selected.png"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2)
    {
        InvoiceDetailViewController *vc = [[InvoiceDetailViewController alloc] init];
        vc.type = indexPath.row == 1 ? InvoiceTypePersonal : InvoiceTypeCompany;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.row == 1)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:MTInvoiceNotification object:@"个人"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:MTInvoiceNotification object:@"不需要发票"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
