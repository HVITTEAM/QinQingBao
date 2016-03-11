//
//  OrderSubmitSuccessViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/16.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "OrderSubmitSuccessViewController.h"
#import "MTChangeCountView.h"
#import "GoodsOrderDetailViewController.h"

static CGFloat BUTTONHEIGHT = 50;
static CGFloat VIEWHEIGHT;
static CGFloat PADDINGBOTTON = 70;

@interface OrderSubmitSuccessViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
@property(nonatomic,assign)NSInteger choosedCount;

@end

@implementation OrderSubmitSuccessViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.choosedCount = 1;
    
    VIEWHEIGHT = MTScreenH *0.35;
    
    [self initView];
    
}


- (void)initView
{
    
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, MTScreenH - VIEWHEIGHT, MTScreenW, VIEWHEIGHT)];
    bgview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgview];
    
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, VIEWHEIGHT - BUTTONHEIGHT, MTScreenW, BUTTONHEIGHT)];
    [sureBtn setTitle:@"去支付" forState:UIControlStateNormal];
    [sureBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    sureBtn.backgroundColor = [UIColor colorWithRGB:@"dd2726"];
    [sureBtn setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bgview addSubview:sureBtn];
    
    UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMinY(sureBtn.frame) - PADDINGBOTTON, 150, 30)];
    
    // 设置富文本的时候，先设置的先显示，后设置的，如果与先设置的样式不一致，是不会覆盖的，富文本设置的效果具有先后顺序，大家要注意
    
    numLab.textColor = [UIColor colorWithRGB:@"333333"];
    NSString *string                            = [NSString stringWithFormat:@"合计:￥%@",self.orderModel.order_amount];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    // 设置富文本样式
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor redColor]
                             range:NSMakeRange(3, string.length - 3)];
    
    numLab.attributedText = attributedString;
    [self.view addSubview:numLab];

    
    numLab.font = [UIFont systemFontOfSize:16];
    [bgview addSubview:numLab];
    
    UILabel *feelab = [[UILabel alloc] initWithFrame:CGRectMake(MTScreenW - 200 - 20, CGRectGetMinY(sureBtn.frame) - PADDINGBOTTON, 200, 30)];
    feelab.text = [NSString stringWithFormat:@"(含运费:￥%@)",self.orderModel.shipping_fee];
    feelab.textColor = [UIColor colorWithRGB:@"333333"];
    feelab.font = [UIFont systemFontOfSize:16];
    feelab.textAlignment  = NSTextAlignmentRight;
    [bgview addSubview:feelab];
    
    UILabel *typeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(numLab.frame) - 80, MTScreenW, 30)];
    typeLab.text = @"订单提交成功";
    typeLab.textAlignment = NSTextAlignmentCenter;
    typeLab.textColor = [UIColor colorWithRGB:@"333333"];
    typeLab.font = [UIFont systemFontOfSize:18];
    [bgview addSubview:typeLab];
    
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(typeLab.frame) + 20, MTScreenW, 0.5)];
    line.backgroundColor=[UIColor colorWithRGB:@"e2e2e2"];
    [bgview addSubview:line];
    
    UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(numLab.frame) + 10, MTScreenW, 0.5)];
    line1.backgroundColor=[UIColor colorWithRGB:@"e2e2e2"];
    [bgview addSubview:line1];
    
    UIImage *btimg = [UIImage imageNamed:@"btn_dismissItem_highlighted"];
    UIImage *selectImg = [UIImage imageNamed:@"btn_dismissItem"];
    UIButton *dismissBtn = [[UIButton alloc]initWithFrame:CGRectMake(MTScreenW - 30, 5, 15, 15)];
    [dismissBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [dismissBtn setImage:btimg forState:UIControlStateNormal];
    [dismissBtn setImage:selectImg forState:UIControlStateSelected];
    [bgview addSubview:dismissBtn];
}


//确定
-(void)sureClick:(UIButton *)sender
{
    [self payOrder];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.parentViewController.navigationController popViewControllerAnimated:YES];
}

/**支付**/
-(void)payOrder
{
    [MTPayHelper payWithAliPayWitTradeNO:self.orderModel.pay_sn productName:@"百货" amount:self.orderModel.order_amount productDescription:@"海予孝心商城" success:^(NSDictionary *dict,NSString *signedString) {
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
                    
                    //支付成功之后跳转到订单详情界面
                    GoodsOrderDetailViewController *detailVC = [[GoodsOrderDetailViewController alloc] init];
                    [detailVC setOrderID:self.orderModel.order_id];
                    [self.nav pushViewController:detailVC animated:YES];
                    [self api_alipay:out_trade_no pay_sn:self.orderModel.pay_sn signedString:sign];
                }
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSDictionary *dict) {
        NSLog(@"支付失败");
        //用户中途取消
        if ([[dict objectForKey:@"resultStatus"] isEqualToString:@"6001"])
        {
            self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    self.cancelClick();
}

/**订单 - 支付付款 订单状态修改**/
-(void)api_alipay:(NSString *)out_trade_no pay_sn:(NSString *)pay_sn signedString:(NSString *)signedString
{
    [CommonRemoteHelper RemoteWithUrl:URL_Alipay parameters: @{@"out_trade_no" : pay_sn,
                                                               @"request_token" : @"requestToken",
                                                               @"result" : @"success",
                                                               @"trade_no" : out_trade_no,
                                                               @"sign" : signedString,
                                                               @"sign_type" : @"RSA"}
                                 type:CommonRemoteTypeGet success:^(NSDictionary *dict, id responseObject) {
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         NSLog(@"支付结果验证成功");
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"支付结果验证出错了....");
                                 }];
}

-(void)back
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确认取消支付吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: @"取消",nil];
    [alertView show];
   
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        [self dismissViewControllerAnimated:YES completion:nil];
        self.cancelClick();
    }
}

@end
