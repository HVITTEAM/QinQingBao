//
//  RechargeViewController.m
//  QinQingBao
//
//  Created by shi on 16/5/6.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "RechargeViewController.h"
#import "HMCommonTextfieldItem.h"

@interface RechargeViewController ()<UITextFieldDelegate>
{
    HMCommonTextfieldItem *money;
}
@end

@implementation RechargeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupGroups];
    
    [self createBottomButton];
    
    self.navigationItem.title = @"充值";
}

# pragma  mark - 设置数据源
/**
 *  初始化模型数据
 */
- (void)setupGroups
{
    //每次刷新数据源的时候需要将数据源清空
    [self.groups removeAllObjects];
    
    //重置数据源
    [self setupGroup0];
    [self setupGroup1];
    
    //刷新表格
    [self.tableView reloadData];
}

- (void)setupGroup0
{
    // 创建组
    HMCommonGroup *group = [HMCommonGroup group];
    //    group.footer = @"开业酬宾:充值满300元送50元，2016/05/30 24:00前有效";
    [self.groups addObject:group];
    
    // 设置组的所有行数据
    HMCommonArrowItem *payType = [HMCommonArrowItem itemWithTitle:@"支付宝支付" icon:@"alipay"];
    
    group.items = @[payType];
}

- (void)setupGroup1
{
    // 创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    // 设置组的所有行数据
    money = [HMCommonTextfieldItem itemWithTitle:@"金额" icon:nil];
    money.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    money.delagate = self;
    money.placeholder = @"请输入充值金额";
    group.items = @[money];
}

/**
 *  创建底部按钮
 */
-(void)createBottomButton
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 55)];
    
    // 创建按钮
    UIButton *bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, MTScreenW - 30, 45)];
    bottomBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [bottomBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bottomBtn.backgroundColor = HMColor(47, 193, 181);
    [bottomBtn addTarget:self action:@selector(checkBlance:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:bottomBtn];
    
    self.tableView.tableFooterView = footerView;
}

/**
 *  调用支付宝支付
 */
-(void)payWithMoney:(NSString *)moneycount pdr_sn:(NSString *)pdr_sn
{
    [MTPayHelper payWithAliPayWitTradeNO:pdr_sn productName:@"账户充值" amount:moneycount productDescription:@"寸欣健康账户充值"
                                 notifyURL:URL_AliPay_Blance success:^(NSDictionary *dict, NSString *signedString) {
        
        NSLog(@"支付成功");
        NSString *out_trade_no;
        NSString *sign;
        NSString *html = [dict objectForKey:@"result"];
        NSArray *resultStringArray =[html componentsSeparatedByString:NSLocalizedString(@"&", nil)];
        for (NSString *str in resultStringArray)
        {
            NSString *newstring = nil;
            newstring = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            NSArray *strArray = [newstring componentsSeparatedByString:NSLocalizedString(@"=", nil)];
            for (int i = 0 ; i < [strArray count] ; i++)
            {
                NSString *st = [strArray objectAtIndex:i];
                if ([st isEqualToString:@"out_trade_no"])
                {
                    NSLog(@"%@",[strArray objectAtIndex:1]);
                    out_trade_no = [strArray objectAtIndex:1];
                }
                else if ([st isEqualToString:@"sign"])
                {
                    NSLog(@"%@",[strArray objectAtIndex:1]);
                    sign = [strArray objectAtIndex:1];
                    //支付成功
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }
    } failure:^(NSDictionary *dict) {
        NSLog(@"支付失败");
        //用户中途取消
        if ([[dict objectForKey:@"resultStatus"] isEqualToString:@"6001"])
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

/**
 *  验证充值成功
 */
-(void)checkBlance:(UIButton *)sender
{
    if (money.rightText.text.length == 0 && [money.rightText.text floatValue] > 0)
        return [NoticeHelper AlertShow:@"请输入正确的充值金额" view:nil];
    [self.view endEditing:YES];
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_add_member_blance parameters: @{@"money" :money.rightText.text,
                                                                          @"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                          @"client" : @"ios"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         NSDictionary *data = [dict objectForKey:@"datas"];
                                         [self payWithMoney:[data objectForKey:@"money"] pdr_sn:[data objectForKey:@"pdr_sn"]];
                                     }
                                     [HUD removeFromSuperview];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                 }];
}

#pragma mark 只能输入数字

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [textField isValidAboutMoneyTextFiled:textField shouldChangeCharactersInRange:range replacementString:string decimalNumber:2];
}

@end
