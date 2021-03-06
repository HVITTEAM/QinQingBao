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

@interface PayViewController ()<UIAlertViewDelegate>
{
    //选择的支付方式
    NSInteger selectedIndex;
}

@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self initTableviewSkin];
    
    selectedIndex = 2;
}

/**
 *  设置tableView属性
 */
-(void)initTableviewSkin
{
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.tableFooterView = [[UIView alloc] init];
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
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"back_icon.png"
                                                                 highImageName:@"back_icon.png"
                                                                        target:self action:@selector(back)];
}

-(void)back
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"是否确定取消付款?"
                                                       delegate:nil
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"去意已决", nil];
    alertView.delegate = self;
    [alertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
        [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 3;
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
    if (indexPath.section == 0 )
        return 80;
    else
        return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0)
    {
        PayHeadCell *headcell = [tableView dequeueReusableCellWithIdentifier:@"MTPayHeadCell"];
        
        if (headcell == nil)
            headcell = [PayHeadCell payHeadCell];
        
        [headcell setItem:self.serviceDetailItem];
        [headcell setOrderItem:self.orderItem];
        
        headcell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage resizedImage:@"common_card_middle_background.png"]];
        
        cell = headcell;
    }
    else  if (indexPath.section == 3)
    {
        PayButtonCell *payBtncell = [tableView dequeueReusableCellWithIdentifier:@"MTPayBtncell"];
        
        if (payBtncell == nil)
            payBtncell = [PayButtonCell payButtonCell];
        
        __weak typeof(self) weakSelf = self;
        payBtncell.payClick = ^(UIButton *button){
            [weakSelf payClickHandler];
        };
        cell =  payBtncell;
    }
    else if (indexPath.section == 1)
    {
        UITableViewCell *contentcell = [tableView dequeueReusableCellWithIdentifier:@"MTContentcell"];
        if (contentcell == nil)
        {
            contentcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MTContentcell"];
            contentcell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
            contentcell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row == 0)
        {
            NSString *string = [NSString stringWithFormat: @"还需支付:%@元",self.orderItem.wprice];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
            // 设置富文本样式
            [attributedString addAttribute:NSForegroundColorAttributeName
                                     value:[UIColor redColor]
                                     range:NSMakeRange(5, self.orderItem.wprice.length)];
            contentcell.textLabel.attributedText = attributedString;
            
            contentcell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage resizedImage:@"common_card_middle_background.png"]];
            
        }
        cell = contentcell;
    }
    else
    {
        UITableViewCell *payTypecell = [tableView dequeueReusableCellWithIdentifier:@"MTPayTypecell"];
        if (payTypecell == nil)
        {
            payTypecell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MTPayTypecell"];
            payTypecell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
            payTypecell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if(indexPath.row == 0)
        {
            payTypecell.imageView.image = [UIImage imageNamed:@"unionpay.png"];
            payTypecell.textLabel.text = @"货到付款";
        }
        else if(indexPath.row == 1)
        {
            payTypecell.imageView.image = [UIImage imageNamed:@"weichat.png"];
            payTypecell.textLabel.text = @"微信支付";
        }
        else if(indexPath.row == 2)
        {
            payTypecell.imageView.image = [UIImage imageNamed:@"alipay.png"];
            payTypecell.textLabel.text = @"支付宝支付";
            payTypecell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage resizedImage:@"common_card_middle_background.png"]];
        }
        if (selectedIndex == indexPath.row)
            payTypecell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            payTypecell.accessoryType = UITableViewCellAccessoryNone;
        
        cell = payTypecell;
    }
    return cell;
}

//选中Cell响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 2)
        return;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    selectedIndex = indexPath.row;
    
    [self.tableView reloadData];
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
    NSString *partner = @"2088121051826945";
    NSString *seller = @"ofc.er@hvit.com.cn";
    NSString *privateKey = @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAKdIyxd3pZwIRBOXBkmkZRsTO9VTlsTlh3+cCxYKWgJc9FsKnOcLQxweSB8NVgwlgilc7LfIFKperP+P+U3KHv/NFlmoz5jJ1OTR9oQF+FoMVYqF9C9C8v3NNGxGnHQwak6d67wxYxntUXQjKFUZWlCnFNXR99D34rseGW6ro74xAgMBAAECgYAewAvNKYpAz2gsLbPTL6wCORvjj/UEBqlMtNN43rhC/PFSFvZWpkRU0+AwDRSHMRHnJpTBB798veCRLdcHDKN71/aPuCoESU4UONwVpHE3cpdDVQ0ATIDDMf5lww6WI29xEbuOcKSQMXJPhyBNCT6hYVbORwr7dQMts2P3xA8JHQJBANqJ6XfDbPfx0Io2xI2zfYhXAOIUf6YQ/ACVcoyAHFsi8vCg7pEbfHf5K9nlAqPBTqJpZLQ8w2N12KctPWQ61hcCQQDD9bJeyIs0an6zvEt0TFgBCTpkTsC6zTsYQj7HuYE05FJofgiXRQaq3PfzlhEKOl4uOx84sQibfPSvXrS7RQL3AkA8Issd66bmq6IJBn0byRJ4HAjgLWfa2L2fo4A77VzgL0POt1ouj/O2R9irQvtw+FadFodhmX7itaECj85e8FnNAkACcWCs39EkcSNtOC60n3MFaEkLERRD/+T5s3G26bAbqbEBTnjq8dhYbvLEXZ2OxBWCfAgym7pgvdkLCqI0J3MXAkAhw0vU9MIi9GWz3PoQzXsJyUHE03+zOjlm4ZLWvBNi3YQuXOZ7VXVcf0yT2VPw8N0vvHiAil6go+E3zS+VehRU";
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
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [NSString stringWithFormat:@"%@%u",currentDateStr,arc4random()%1000 + 9000]; //订单ID（由商家自行制定）
    order.productName = self.serviceDetailItem.icontent; //商品标题
    order.productDescription = @"商品描述"; //商品描述
    order.amount = self.orderItem.wprice; //商品价格
    order.notifyURL =  @"http://www.hvit.com.cn"; //回调URL
    
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
            
            if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"6001"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果"
                                                                message:[resultDic objectForKey:@"memo"]
                                                               delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
            else if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果"
                                                                message:@"支付成功"
                                                               delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                UIViewController *vc = self.navigationController.viewControllers[2];
                [self.navigationController popToViewController:vc animated:YES];
            }
            
            //【callback 处理支付结果】
            NSLog(@"reslut = %@",resultDic);
        }];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}


@end
