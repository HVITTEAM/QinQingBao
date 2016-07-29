//
//  SexViewController.m
//  Healthy
//
//  Created by shi on 16/7/11.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "SexViewController.h"
#import "BasicViewController.h"


@interface SexViewController ()
{
    //试卷id
    NSString *exam_id;
}

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
- (IBAction)manClick:(id)sender;
- (IBAction)femanClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *manImg;
@property (strong, nonatomic) IBOutlet UIButton *femanImg;

@end

@interface SexViewController ()
{
    NSArray *dataProvider;
    //当前选择的选择
    NSString *selectedId;
}

@end

@implementation SexViewController



-(instancetype)init
{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.nextBtn.layer.cornerRadius = 7.0f;
    
    [self getDataProvider];
}

-(void)initView
{
    if (!dataProvider || dataProvider.count == 0)
        return;
    QuestionModel *item = dataProvider[0];
    self.titleLab.text =  item.eq_title;
    self.title = item.eq_title;
    
    //设置初始值
    QuestionModel_1 *item1 = item.questions[0];
    OptionModel *optionItem = item1.options[0];
    selectedId = optionItem.qo_id;
}

- (IBAction)nextBtnClicke:(id)sender
{
    if (!dataProvider || dataProvider.count == 0)
        return;
    QuestionModel *item = dataProvider[0];
    QuestionModel_1 *item1 = item.questions[0];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    [dict1 setObject:item1.q_id forKey:@"q_id"];
    [dict1 setObject:selectedId forKey:@"qa_detail"];
    [arr addObject:dict1];
    
    BasicViewController *vc = [[BasicViewController alloc] init];
    vc.dataProvider = dataProvider;
    vc.answerProvider = arr;
    vc.exam_id = exam_id;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  获取数据源
 */
-(void)getDataProvider
{
    [CommonRemoteHelper RemoteWithUrl:URL_Get_questions parameters:@{@"id" : self.item.e_id}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     NSDictionary *dict1 = [dict objectForKey:@"datas"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         
                                     }
                                     else
                                     {
                                         dataProvider = [QuestionModel objectArrayWithKeyValuesArray:[dict1 objectForKey:@"questions"]];
                                         exam_id = [dict1 objectForKey:@"e_id"];
                                         [self initView];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                 }];
}


- (IBAction)manClick:(id)sender
{
    QuestionModel *item = dataProvider[0];
    QuestionModel_1 *item1 = item.questions[0];
    for (OptionModel *optionItem in item1.options)
    {
        if ([optionItem.qo_content rangeOfString:@"男"].location != NSNotFound)
        {
            selectedId = optionItem.qo_id;
        }
    }
    [self.manImg setBackgroundImage:[UIImage imageNamed:@"sex_selected.png"] forState:UIControlStateNormal];
    [self.femanImg setBackgroundImage:nil forState:UIControlStateNormal];
}

- (IBAction)femanClick:(id)sender {
    QuestionModel *item = dataProvider[0];
    QuestionModel_1 *item1 = item.questions[0];
    for (OptionModel *optionItem in item1.options)
    {
        if ([optionItem.qo_content rangeOfString:@"女"].location != NSNotFound)
        {
            selectedId = optionItem.qo_id;
        }
    }
    [self.femanImg setBackgroundImage:[UIImage imageNamed:@"sex_selected.png"] forState:UIControlStateNormal];
    [self.manImg setBackgroundImage:nil forState:UIControlStateNormal];
    
}
@end
