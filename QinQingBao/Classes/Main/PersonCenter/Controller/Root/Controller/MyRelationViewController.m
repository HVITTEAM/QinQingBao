//
//  MyRelationViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/9/20.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "MyRelationViewController.h"
#import "BBSRelationModel.h"
#import "BBSRelationCell.h"

#import "PublicProfileViewController.h"

@interface MyRelationViewController ()
{
    NSMutableArray *dataProvider;
}

@end

@implementation MyRelationViewController

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
    
    [self initTableview];
    
    [self getDataProvider];
}

-(void)initTableview
{
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

-(void)getDataProvider
{
    NSDictionary *paramDict = [[NSDictionary alloc] init];
    if (self.type == 1)
    {
        self.title = @"关注列表";
        paramDict = @{@"action" : @"attention",
                      @"attention_uid" :self.uid,
                      @"client" : @"ios",
                      @"page" : @"1000",
                      @"p" : @"1"};
    }
    else
    {
        self.title = @"粉丝列表";
        paramDict = @{@"action" : @"fans",
                      @"fans_uid" : self.uid,
                      @"client" : @"ios",
                      @"page" : @"1000",
                      @"p" : @"1"};
    }
    [CommonRemoteHelper RemoteWithUrl:URL_Get_attention_list parameters: paramDict
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum integerValue] > 0)//如果返回的是NSString 说明有错误
                                     {
                                        if([codeNum integerValue] == 17001 && dataProvider.count == 0)
                                         {
                                             [self.tableView reloadData];

                                             [self.view initWithPlaceString:PlaceholderStr_Fans imgPath:@"placeholder-0.png"];
                                         }
                                         else if([codeNum integerValue] == 17001)
                                         {
                                             [self.view initWithPlaceString:PlaceholderStr_Fans imgPath:@"placeholder-0.png"];
                                         }
                                         else
                                         {
                                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                             [alertView show];
                                         }
                                     }
                                     else
                                     {
                                         NSDictionary *datas  = [dict objectForKey:@"datas"];
                                         if (self.type == 1)
                                         {
                                             dataProvider = [[BBSRelationModel objectArrayWithKeyValuesArray:[datas objectForKey:@"attention_list"]] mutableCopy];
                                         }
                                         else
                                         {
                                             dataProvider = [[BBSRelationModel objectArrayWithKeyValuesArray:[datas objectForKey:@"fans_list"]] mutableCopy];
                                         }
                                         [self.tableView reloadData];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                 }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataProvider.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BBSRelationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MTBBSRelationCell"];
    
    if(cell == nil)
        cell = [BBSRelationCell BBSRelationCell];
    
    cell.owerId = _uid;
    cell.relationChangeBlock = ^(NSString *targetUId,NSInteger type)
    {
        [self relationOperateWithID:targetUId type:type];
    };
    [cell setItem:dataProvider[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PublicProfileViewController *view = [[PublicProfileViewController alloc] init];
    BBSRelationModel *item = dataProvider[indexPath.row];
    view.uid = item.fans_id ? item.fans_id : item.attention_id;
    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark -- 与后台数据交互模块

/**
 *  加关注与取消关注
 * targetUId 操作的目标id type 0删除 1添加
 */
-(void)relationOperateWithID:(NSString *)targetUId type:(NSInteger)type
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Get_attention_do parameters: @{@"action" : type == 1 ? @"add" : @"del",
                                                                         @"uid" : [SharedAppUtil defaultCommonUtil].bbsVO.BBS_Member_id,
                                                                         @"rel" : targetUId,
                                                                         @"client" : @"ios",
                                                                         @"key" : [SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     [HUD removeFromSuperview];
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum integerValue] > 0)//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         NSString *str = [[dict objectForKey:@"datas"] objectForKey:@"message"];
                                         [dataProvider removeAllObjects];
                                         [self getDataProvider];
                                         [NoticeHelper AlertShow:str view:nil];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                 }];
}

@end
