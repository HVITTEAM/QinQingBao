//
//  DeliverViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/30.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "DeliverViewController.h"
#import "TimeLineViewControl.h"
#import "DeliverInfoModel.h"

@interface DeliverViewController ()
{
    UIScrollView *bgview;
    UILabel *lab1;
    UILabel *lab2;
    UILabel *lab3;
    UIImageView *icon;
}

@end

@implementation DeliverViewController

- (void)viewDidLoad
{
    self.title = @"物流详细";
    
    [super viewDidLoad];
    
    [self initView];
    
    [self getDataProvider];
}

-(void)initView
{
    bgview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH)];
    bgview.backgroundColor = [UIColor whiteColor];
    
    icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"car.png"]];
    icon.frame = CGRectMake(30, 15, 16, 16);
    
    lab1 = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, MTScreenW, 23)];
    lab1.textColor = [UIColor colorWithRGB:@"666666"];
    lab1.font = [UIFont systemFontOfSize:14];
    [bgview addSubview:lab1];
    
    lab2 = [[UILabel alloc] initWithFrame:CGRectMake(60, 33, MTScreenW, 23)];
    lab2.textColor = [UIColor colorWithRGB:@"666666"];
    lab2.font = [UIFont systemFontOfSize:14];
    [bgview addSubview:lab2];
    
    lab3 = [[UILabel alloc] initWithFrame:CGRectMake(60, 56, MTScreenW, 23)];
    lab3.textColor = [UIColor colorWithRGB:@"666666"];
    lab3.font = [UIFont systemFontOfSize:14];
    [bgview addSubview:lab3];
    
    [self.view addSubview:bgview];
}

-(void)getDataProvider
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *order_id;
    if (self.item) {
        CommonOrderModel *orderModel = self.item.order_list[0];
        order_id = orderModel.order_id;
    }else if (self.orderId) {
        order_id = self.orderId;
    }else order_id = @"";
    
    [CommonRemoteHelper RemoteWithUrl:URL_Search_deliver parameters:@{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                      @"client" : @"ios",
                                                                      @"order_id" : order_id
                                                                      }
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     [HUD removeFromSuperview];
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         DeliverInfoModel * model = [DeliverInfoModel objectWithKeyValues:dict[@"datas"]];
                                         
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             switch ([model.state integerValue])
                                             {
                                                 case 0:
                                                     lab1.text = @"物流状态:在途";
                                                     break;
                                                 case 1:
                                                     lab1.text = @"物流状态:揽件";
                                                     break;
                                                 case 2:
                                                     lab1.text = @"物流状态:疑难";
                                                     break;
                                                 case 3:
                                                     lab1.text = @"物流状态:签收";
                                                     break;
                                                 case 4:
                                                     lab1.text = @"物流状态:退签";
                                                     break;
                                                 case 5:
                                                     lab1.text = @"物流状态:派件";
                                                     break;
                                                 case 6:
                                                     lab1.text = @"物流状态:退回";
                                                     break;
                                                 default:
                                                     break;
                                             }
                                             [bgview addSubview:icon];
                                             lab2.text = [NSString stringWithFormat:@"物流单号:%@",model.shipping_code];
                                             lab3.text = [NSString stringWithFormat:@"信息来源:%@",model.express_name];
                                             TimeLineViewControl *timeline = [[TimeLineViewControl alloc] initWithTimeArray:nil andTimeDescriptionArray:[[model.deliver_info reverseObjectEnumerator] allObjects] andCurrentStatus:1 andFrame:CGRectMake(-30, 100, MTScreenW,MTScreenH)];
                                             [bgview addSubview:timeline];
                                             bgview.contentSize = CGSizeMake(MTScreenW, timeline.totalHeight + 100);                                            });
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                 }];
    
}

@end
