//
//  EventInfoController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/5/31.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "EventInfoController.h"
#import "EventMsgModel.h"

@interface EventInfoController ()
{
    NSArray *dataProvider;
}

@end
@implementation EventInfoController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor  = HMGlobalBg;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self getDadaProvider];
}

/** 屏蔽tableView的样式 */
- (id)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

/**
 *  根据类别获取不同的数据源
 */
-(void)getDadaProvider
{
    NSInteger infotype = self.type + 1;
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_get_systemmsginfos_by_type parameters: @{@"type" : [NSString stringWithFormat:@"%ld",(long)infotype],
                                                                                   @"page" : @100,
                                                                                   @"client" : @"ios",
                                                                                   @"p" : @1,
                                                                                   @"key":[SharedAppUtil defaultCommonUtil].userVO.key}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         dataProvider = [EventMsgModel objectArrayWithKeyValuesArray:[dict objectForKey:@"datas"]];
                                         [self.tableView reloadData];
                                     }
                                     [HUD removeFromSuperview];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                 }];
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataProvider.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *commonCell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonCell"];
    if (commonCell == nil)
        commonCell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MTCommonCell"];
    commonCell.textLabel.font = [UIFont fontWithName:@"Helvetica-Medium" size:16];
    commonCell.imageView.image = [UIImage imageNamed:@"1.png"];
    commonCell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
            commonCell.textLabel.text = @"活动资讯";
            break;
        case 1:
            commonCell.textLabel.text = @"健康小贴士";
            break;
        case 2:
            commonCell.textLabel.text = @"通知消息";
            break;
        case 3:
            commonCell.textLabel.text = @"物流助手";
            break;
        default:
            break;
    }
    return commonCell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake((MTScreenW - 150)/2, 15, 150, 23)];
    lab.text = @"6月10日 11:23";
    lab.layer.masksToBounds = YES;
    lab.layer.cornerRadius = 4;
    lab.backgroundColor = HMColor(198, 198, 198);
    lab.font = [UIFont systemFontOfSize:13];
    lab.textColor = [UIColor whiteColor];
    lab.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lab];
    return view;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
