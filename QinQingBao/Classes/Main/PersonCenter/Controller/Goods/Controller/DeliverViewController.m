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
}

@end

@implementation DeliverViewController

- (void)viewDidLoad
{
    self.title = @"物流详细";
    
    self.view.backgroundColor = HMGlobalBg;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [super viewDidLoad];
    
    [self initView];
    
    [self getDataProvider];
}

-(void)initView
{
    bgview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH)];
    bgview.backgroundColor = HMGlobalBg;
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, MTScreenW, 23)];
    lab1.textColor = [UIColor colorWithRGB:@"666666"];
    lab1.font = [UIFont systemFontOfSize:14];
    lab1.text = @"物流状态:已签收";
    [bgview addSubview:lab1];
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(30, 33, MTScreenW, 23)];
    lab2.textColor = [UIColor colorWithRGB:@"666666"];
    lab2.font = [UIFont systemFontOfSize:14];
    lab2.text = @"运单号:已签收";
    [bgview addSubview:lab2];
    
    UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectMake(30, 56, MTScreenW, 23)];
    lab3.textColor = [UIColor colorWithRGB:@"666666"];
    lab3.font = [UIFont systemFontOfSize:14];
    lab3.text = @"信息来源:韵达快递";
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

                                               TimeLineViewControl *timeline = [[TimeLineViewControl alloc] initWithTimeArray:nil andTimeDescriptionArray:model.deliver_info andCurrentStatus:1 andFrame:CGRectMake(-30, 80, MTScreenW,MTScreenH)];
                                                [bgview addSubview:timeline];
                                                bgview.contentSize = CGSizeMake(MTScreenW, timeline.totalHeight + 120);
                                            });
                                         }
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"发生错误！%@",error);
                                         [HUD removeFromSuperview];
                                     }];
    
//    NSArray *timeArr= [NSArray arrayWithObjects: @"2016-01-19 20:42:13&nbsp;&nbsp;上海市|收件|上海市【青浦东分部】，【苏泊尔海淮专卖店/021-69788558】已揽收",
//                       @"2016-01-19 21:27:38&nbsp;&nbsp;上海市|到件|到上海市【青浦东部】",
//                       @"2016-01-20 23:56:06&nbsp;&nbsp;上海市|到件|到上海市【上海分拨中心】",
//                       @"2016-01-21 00:12:24&nbsp;&nbsp;上海市|发件|上海市【上海分拨中心】，正发往【中山分拨中心】",
//                       @"2016-01-22 09:39:18&nbsp;&nbsp;中山市|到件|到中山市【中山分拨中心】",
//                       @"2016-01-23 09:33:37&nbsp;&nbsp;中山市|发件|中山市【中山分拨中心】，正发往【珠海分拨仓】",
//                       @"2016-01-23 12:24:07&nbsp;&nbsp;珠海市|到件|到珠海市【珠海分拨仓】",
//                       @"2016-01-24 06:55:42&nbsp;&nbsp;珠海市|发件|珠海市【珠海分拨仓】，正发往【珠海金鼎分部】",
//                       @"2016-01-24 09:42:17&nbsp;&nbsp;珠海市|到件|到珠海市【珠海金鼎分部】",
//                       @"2016-01-24 13:29:56&nbsp;&nbsp;珠海市|派件|珠海市【珠海金鼎分部】，【黄培健/13823003125】正在派件",
//                       @"2016-01-24 16:18:34&nbsp;&nbsp;珠海市|签收|珠海市【珠海金鼎分部】，门卫 已签收", nil];
//    TimeLineViewControl *timeline = [[TimeLineViewControl alloc] initWithTimeArray:nil
//                                                           andTimeDescriptionArray:[timeArr copy]
//                                                                  andCurrentStatus:1
//                                                                          andFrame:CGRectMake(-30, 80, MTScreenW, MTScreenH)];
//    [bgview addSubview:timeline];
//    bgview.contentSize = CGSizeMake(MTScreenW, timeline.totalHeight + 120);
    
}

@end
