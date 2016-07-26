//
//  SexViewController.m
//  Healthy
//
//  Created by shi on 16/7/11.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "SexViewController.h"
#import "BasicViewController.h"
#import "QuestionModel.h"

@interface SexViewController ()

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
    self.navigationItem.title = @"性别";
    
    [self getDataProvider];
}

-(void)initView
{
    QuestionModel *item = dataProvider[0];
    self.titleLab.text =  item.eq_title;
}

- (IBAction)nextBtnClicke:(id)sender
{
    BasicViewController *vc = [[BasicViewController alloc] init];
    vc.dataProvider = dataProvider;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  获取数据源
 */
-(void)getDataProvider
{
    [CommonRemoteHelper RemoteWithUrl:URL_Get_questions parameters:nil
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     NSDictionary *dict1 = [dict objectForKey:@"datas"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         
                                     }
                                     else
                                     {
                                         dataProvider = [QuestionModel objectArrayWithKeyValuesArray:[dict1 objectForKey:@"questions"]];
                                         [self initView];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                 }];
}


- (IBAction)manClick:(id)sender
{
    [self.manImg setBackgroundImage:[UIImage imageNamed:@"sex_selected.png"] forState:UIControlStateNormal];
    [self.femanImg setBackgroundImage:nil forState:UIControlStateNormal];
}

- (IBAction)femanClick:(id)sender {
    [self.femanImg setBackgroundImage:[UIImage imageNamed:@"sex_selected.png"] forState:UIControlStateNormal];
    [self.manImg setBackgroundImage:nil forState:UIControlStateNormal];

}
@end
