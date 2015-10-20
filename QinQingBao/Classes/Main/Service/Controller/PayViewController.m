//
//  PayViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/8.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "PayViewController.h"
#import "Order.h"
#import "DataSigner.h"



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

/*
 * 确认支付
 */
-(void)payClickHandler
{
    NSLog(@"确认支付");
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088101568353491";
    NSString *seller = @"2088101568353491";
    NSString *privateKey = @"2088101568353491";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = @"002"; //订单ID（由商家自行制定）
    order.productName = @"test"; //商品标题
    order.productDescription = @"test"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2d",100]; //商品价格
    order.notifyURL =  @"http://www.xxx.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"QinQingBao";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            //【callback 处理支付结果】
            NSLog(@"reslut = %@",resultDic);
        }];
        
    }

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
