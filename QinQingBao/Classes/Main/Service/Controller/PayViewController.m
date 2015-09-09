//
//  PayViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/8.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "PayViewController.h"

@interface PayViewController ()

@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self initTableviewSkin];
}

/**
 *  设置tableView属性
 */
-(void)initTableviewSkin
{
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.tableFooterView = [[UIView alloc] init];
    //        self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor =  HMGlobalBg;
    
}

-(void)sendMsg
{
    
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.title = @"订单支付";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 4;
            break;
        default:
            return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0 )
        return 80;
    else
        return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *head = @"headCell";
    NSString *content = @"contentCell";
    NSString *pay = @"payBtnCell";
    PayButtonCell *payBtncell = [tableView dequeueReusableCellWithIdentifier:pay];
    UITableViewCell *contentcell = [tableView dequeueReusableCellWithIdentifier:content];
    UITableViewCell *headcell = [tableView dequeueReusableCellWithIdentifier:head];
    
    if (indexPath.section == 0)
    {
        if (headcell == nil)
        {
            //提交订单
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"PayHeadCell" owner:self options:nil];
            headcell = [nib lastObject];
            headcell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return  headcell;
    }
    else  if (indexPath.section == 2)
    {
        if (payBtncell == nil)
        {
            //提交订单
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"PayButtonCell" owner:self options:nil];
            payBtncell = [nib lastObject];
            payBtncell.selectionStyle = UITableViewCellSelectionStyleNone;
            __weak typeof(self) weakSelf = self;
            payBtncell.payClick = ^(UIButton *button){
                [weakSelf payClickHandler];
            };
        }
        return  payBtncell;
    }
    
    else
    {
        if (contentcell == nil)
        {
            contentcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:content];
            contentcell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        }
        if (indexPath.row == 0)
        {
            NSString *string = @"还需支付:70元";
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
            // 设置富文本样式
            [attributedString addAttribute:NSForegroundColorAttributeName
                                     value:[UIColor redColor]
                                     range:NSMakeRange(5, 3)];
            contentcell.textLabel.attributedText = attributedString;
        }
        else if(indexPath.row == 1)
            contentcell.textLabel.text = @"货到付款";
        else if(indexPath.row == 2)
            contentcell.textLabel.text = @"微信支付";
        else if(indexPath.row == 3)
            contentcell.textLabel.text = @"支付宝支付";
        return contentcell;
    }
}

-(void)payClickHandler
{
    NSLog(@"确认支付");
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
