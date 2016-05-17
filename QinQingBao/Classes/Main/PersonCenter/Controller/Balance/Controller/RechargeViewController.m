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
    
    //进入当前界面就生成一个订单号
    NSString *tradeNum;
}
@end

@implementation RechargeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupGroups];
    
    [self createBottomButton];
    
    self.navigationItem.title = @"充值";
    
    tradeNum = @"";
    for (int i = 0; i < 15; i++)
    {
        NSInteger ran = (arc4random() % (10));
        tradeNum = [NSString stringWithFormat:@"%@%ld",tradeNum,(long)ran];
    }
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
    money.rightText.delegate = self;
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
    [bottomBtn addTarget:self action:@selector(bottomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:bottomBtn];
    
    self.tableView.tableFooterView = footerView;
}


-(void)bottomButtonAction:(UIButton *)sender
{
    if (money.rightText.text.length == 0)
        return [NoticeHelper AlertShow:@"请输入充值金额" view:nil];
    
    [self.view endEditing:YES];
    
    [MTPayHelper payWithAliPayWitTradeNO:tradeNum productName:@"账户充值" amount:money.rightText.text productDescription:@"寸欣健康账户充值" success:^(NSDictionary *dict, NSString *signedString) {
        
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
                    
                    [self chcekBlance];
                }
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
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
-(void)chcekBlance
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_add_member_blance parameters: @{@"money" :money.rightText.text,
                                                                          @"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                          @"way" : @1,
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
                                         [NoticeHelper AlertShow:@"充值成功！" view:nil];
                                         //验证成功
                                         [self.navigationController popViewControllerAnimated:YES];
                                     }
                                     [HUD removeFromSuperview];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.view endEditing:YES];
                                     [HUD removeFromSuperview];
                                 }];
    
}

#pragma mark 只能输入数字

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

@end
