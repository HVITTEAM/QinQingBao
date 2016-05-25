//
//  EvaluationViewController.m
//  QinQingBao
//
//  Created by shi on 16/5/19.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "EvaluationViewController.h"
#import "EvaluateCell.h"
#import "OrderModel.h"

@interface EvaluationViewController ()<EvaluateCellDelegate>

@property(copy,nonatomic)NSString *evaluateContent;       //评价内容

@property(assign,nonatomic)NSInteger score;               //评分

@end

@implementation EvaluationViewController

-(instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    return self;
}


#pragma mark - 生命周期方法

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 60)];
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, MTScreenW - 40,40)];
    [confirmBtn setTitle:@"提交" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.backgroundColor = HMColor(255, 126, 0);
    confirmBtn.layer.cornerRadius = 8.0f;
    confirmBtn.layer.masksToBounds = YES;
    [confirmBtn addTarget:self action:@selector(submitEvaluate:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:confirmBtn];
    self.tableView.tableFooterView = footView;
    
    //设置默认选项
    self.score = 5;
    self.evaluateContent = @"默认好评";
    self.navigationItem.title = @"服务评价";
}

#pragma mark - 协议方法
#pragma mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //评价cell
    EvaluateCell *evaluateCell = [EvaluateCell createEvaluateCellWithTableView:tableView];
    evaluateCell.delegate = self;
    return evaluateCell;
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 9;
}

#pragma mark - EvaluateCellDelegate
/**
 *  评分后回调
 */
-(void)evaluateCell:(EvaluateCell *)cell evaluateScore:(NSInteger)score
{
    self.score = score;
    NSLog(@"%ld",(long)self.score);
}

/**
 *  评价内容发生变化后回调
 */
-(void)evaluateCell:(EvaluateCell *)cell didEvaluateContentChange:(NSString *)newContent
{
    self.evaluateContent = newContent;
    NSLog(@"%@",self.evaluateContent);
}

#pragma mark - 网络相关方法
/**
 *  提交评论
 */
-(void)submitEvaluate:(UIButton *)sender
{
    if (self.evaluateContent.length == 0)
        return [NoticeHelper AlertShow:@"请输入评论内容" view:nil];
    
    NSDictionary *dict =  @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                            @"client" : @"ios",
                            @"member_id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                            @"wid":self.orderModel.wid,
                            @"cont":self.evaluateContent,
                            @"grade":@(self.score)
                            };
    [CommonRemoteHelper RemoteWithUrl:URL_Save_dis_cont parameters:dict type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
        if ([dict[@"code"] integerValue] == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"评价成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            if (self.viewControllerOfback) {
                [self.navigationController popToViewController:self.viewControllerOfback animated:YES];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            [NoticeHelper AlertShow:dict[@"errorMsg"] view:self.view];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [NoticeHelper AlertShow:@"评论提交失败" view:self.view];
    }];
}



@end
