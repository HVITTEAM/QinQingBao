//
//  InvoiceDetailViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/9.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "InvoiceDetailViewController.h"
#import "MTCommonTextCell.h"

@interface InvoiceDetailViewController ()
{
    MTCommonTextCell *textCell;
}

@end

@implementation InvoiceDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.type == InvoiceTypePersonal ? @"个人发票" : @"公司";
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor  =HMGlobalBg;
    [self initNavigation];
}


/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(okCkick)];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    UITableViewCell *commoncell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonCell"];
    
    textCell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonTextCell"];
    
    if (commoncell == nil)
        commoncell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MTCommonCell"];
    
    commoncell.textLabel.textColor = [UIColor colorWithRGB:@"333333"];
    commoncell.textLabel.font = [UIFont systemFontOfSize:14];
    commoncell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    
    switch (indexPath.row)
    {
        case 0:
        {
            if(textCell == nil)
                textCell = [MTCommonTextCell commonTextCell];
            [textCell setItemWithTittle:@"单位名称:" placeHolder:@"请填写单位名称"];
            cell = textCell;
        }
            break;
        default:
            break;
    }
    return cell;
}

-(void)okCkick
{
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:MTInvoiceNotification object:textCell.textField.text];
    [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count-3] animated:YES];
}


@end
