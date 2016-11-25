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
#import "QuestionResultController3.h"

#define LINESPACE 4


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
    //push太慢
    
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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];

}


- (IBAction)btn1Handler:(id)sender {
    [NoticeHelper AlertShow:@"该功能尚未开通" view:nil];
}

- (IBAction)btn2Handler:(id)sender {
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}

-(void)getResult
{
    NSMutableDictionary *resultdict = [[NSMutableDictionary alloc] init];
    [resultdict setObject:self.exam_id forKey:@"exam_id"];
    [resultdict setObject:self.e_title forKey:@"r_etitle"];
    [resultdict setObject:self.answerProvider forKey:@"qitem"];
    
    NSLog(@"%@",resultdict);
    NSString *dictstr = [self dictionaryToJson:[resultdict copy]];
    //去掉换行符
    NSString * encodingString = [dictstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *resultStr = [encodingString stringByReplacingOccurrencesOfString:@"%0A%20%20" withString:@""];
    [self submit_exam:resultStr];
    NSLog(@"%@",resultStr);
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
//                                         self.circleView.percentValue = [model.r_result.hmd_diseaseprobability floatValue];
//                                         self.circleView.dangerText = model.r_dangercoefficient;
//                                         self.titleLab.text = model.r_hmtitle;
//                                         self.circleView.midStr = model.r_result.hmd_diseaseprobability;
//                                         
//                                         self.lab1.text = model.r_result.hmd_advise_diet;
//                                         self.lab2.text = model.r_result.hmd_advise_sports;
//                                         self.lab3.text = model.r_result.hmd_advise_other;
                                         
                                        QuestionResultController3 *questionResultVC = [[QuestionResultController3 alloc] init];
                                         
                                         questionResultVC.r_ids = model.r_ids;
                                         questionResultVC.r_dangercoefficient = model.r_dangercoefficient;
                                         questionResultVC.hmd_advise = model.r_result.hmd_advise;

                                        [self.navigationController pushViewController:questionResultVC animated:YES];
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
                                         self.circleView.percentValue = [model.r_result.hmd_diseaseprobability floatValue];
                                         self.circleView.dangerText = model.r_dangercoefficient;
                                         self.circleView.midStr = model.r_result.hmd_diseaseprobability;
                                         self.titleLab.text = model.r_hmtitle;
                                         
                                         
                                         NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:model.r_result.hmd_advise_diet];
                                         NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
                                         [paragraphStyle1 setLineSpacing:LINESPACE];//调整行间距
                                         [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [model.r_result.hmd_advise_diet length])];
                                         self.lab1.attributedText = attributedString1;
                                         
                                         NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:model.r_result.hmd_advise_sports];
                                         NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
                                         [paragraphStyle2 setLineSpacing:LINESPACE];//调整行间距
                                         [attributedString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle2 range:NSMakeRange(0, [model.r_result.hmd_advise_sports length])];
                                         self.lab2.attributedText = attributedString2;

                                         NSMutableAttributedString *attributedString3 = [[NSMutableAttributedString alloc] initWithString:model.r_result.hmd_advise_other];
                                         NSMutableParagraphStyle *paragraphStyle3 = [[NSMutableParagraphStyle alloc] init];
                                         [paragraphStyle3 setLineSpacing:LINESPACE];//调整行间距
                                         [attributedString3 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle3 range:NSMakeRange(0, [model.r_result.hmd_advise_other length])];
                                         self.lab3.attributedText = attributedString3;
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                 }];
}


-(void)back
{
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}

@end
