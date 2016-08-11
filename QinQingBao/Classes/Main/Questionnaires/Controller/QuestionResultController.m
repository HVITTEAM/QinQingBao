//
//  QuestionResultController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/7/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "QuestionResultController.h"
#import "RadianView.h"
#import "ResultModel.h"
#import "ReportListModel.h"

@interface QuestionResultController ()
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet RadianView *circleView;
@property (strong, nonatomic) IBOutlet UIScrollView *bgview;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *lab1;
@property (strong, nonatomic) IBOutlet UILabel *lab2;
@property (strong, nonatomic) IBOutlet UILabel *lab3;
@property (strong, nonatomic) IBOutlet UIButton *btn1;
@property (strong, nonatomic) IBOutlet UIButton *btn2;
@property (strong, nonatomic) IBOutlet UIImageView *bottomImg;
- (IBAction)btn1Handler:(id)sender;
- (IBAction)btn2Handler:(id)sender;

@end

@implementation QuestionResultController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *img = [[UIImageView alloc] init];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        [img sd_setImageWithURL:[NSURL URLWithString:@"https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/logo_white_fe6da1ec.png"] placeholderImage:[UIImage imageWithName:@"placeholder_serviceMarket"]];
    });
    dispatch_group_async(group, queue, ^{
        [img sd_setImageWithURL:[NSURL URLWithString:@"https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/logo_white_fe6da1ec.png"] placeholderImage:[UIImage imageWithName:@"placeholder_serviceMarket"]];
    });
    dispatch_group_async(group, queue, ^{  [img sd_setImageWithURL:[NSURL URLWithString:@"https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/logo_white_fe6da1ec.png"] placeholderImage:[UIImage imageWithName:@"placeholder_serviceMarket"]];
        
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"全部加载完成");
    });
    
    self.title = @"评估结果";
    
    self.circleView.upperCircleColor = [UIColor orangeColor];
    self.circleView.lowerCircleColor = [UIColor lightGrayColor];
    self.circleView.lineWidth = 15;
    self.circleView.lineThick = 1.5;
    self.circleView.lineSpace = 5;
    
    
    self.btn1.layer.cornerRadius = 8;
    self.btn2.layer.cornerRadius = 8;
    if (self.reportListModel) {
        [self getReportResult];
    }else [self getResult];
}


- (IBAction)btn1Handler:(id)sender {
    [NoticeHelper AlertShow:@"该功能尚未开通" view:nil];
}

- (IBAction)btn2Handler:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)getResult
{
    NSMutableDictionary *resultdict = [[NSMutableDictionary alloc] init];
    [resultdict setObject:self.exam_id forKey:@"exam_id"];
    [resultdict setObject:self.answerProvider forKey:@"qitem"];
    NSLog(@"%@",resultdict);
    NSString *dictstr = [self dictionaryToJson:[resultdict copy]];
    NSString * encodingString = [dictstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self submit_exam:encodingString];
}

/**
 *  获取数据源
 */
-(void)submit_exam:(NSString *)resultStr
{
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] initWithDictionary:@{@"result" : resultStr,
                                                                                       @"client" : @"ios",
                                                                                       @"calculatype":self.calculatype
                                                                                       }];
    if ( [SharedAppUtil defaultCommonUtil].userVO.key)
    {
        [paramDict setObject:[SharedAppUtil defaultCommonUtil].userVO.key forKey:@"key"];
    }
    
    
    [CommonRemoteHelper RemoteWithUrl:URL_Submit_exam parameters:paramDict
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     NSDictionary *dict1 = [dict objectForKey:@"datas"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         
                                     }
                                     else
                                     {
                                         ResultModel *model = [ResultModel objectWithKeyValues:dict1];
                                         self.circleView.percentValue = [model.r_dangerpercent[0] floatValue] / [model.r_dangerpercent[1] floatValue] *100;
                                         self.circleView.dangerText = model.r_dangercoefficient;
                                         self.titleLab.text = model.r_hmtitle;
                                         self.circleView.midStr = model.hmd_diseaseprobability;
                                         
                                         self.lab1.text = model.r_result.hmd_advise_diet;
                                         self.lab2.text = model.r_result.hmd_advise_sports;
                                         self.lab3.text = model.r_result.hmd_advise_other;
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                 }];
}

//词典转换为字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/**
 *  获取问卷具体答案,从个人中心的评估列表中进入时会调用
 */
-(void)getReportResult
{
    NSDictionary *params = @{
                             @"client":@"ios",
                             @"key":[SharedAppUtil defaultCommonUtil].userVO.key,
                             @"rid":self.reportListModel.r_id
                             };
    [CommonRemoteHelper RemoteWithUrl:URL_Get_report_detail parameters:params
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     NSDictionary *dict1 = [dict objectForKey:@"datas"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         
                                     }
                                     else
                                     {
                                         ResultModel *model = [ResultModel objectWithKeyValues:dict1];
                                         self.circleView.percentValue = [model.r_dangerpercent[0] floatValue] / [model.r_dangerpercent[1] floatValue] *100;
                                         self.circleView.dangerText = model.r_dangercoefficient;
                                         self.circleView.midStr = model.hmd_diseaseprobability;
                                         self.titleLab.text = model.r_hmtitle;
                                         
                                         self.lab1.text = model.r_result.hmd_advise_diet;
                                         self.lab2.text = model.r_result.hmd_advise_sports;
                                         self.lab3.text = model.r_result.hmd_advise_other;
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                 }];
}

@end
