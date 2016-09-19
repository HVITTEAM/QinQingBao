//
//  PostsTableViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/9/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "PostsTableViewController.h"
#import "CardCell.h"
#import "PostsModel.h"
#import "SiglePicCardCell.h"

@interface PostsTableViewController ()
{
    NSArray *postsArr;
}
@end

@implementation PostsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self setupRefresh];
    
    [self getData];
 
}

#pragma mark 集成刷新控件

-(void)getData
{
    if (self.type == BBSType_4 || self.type == BBSType_1)
    {
        [self getRecommendlist];
    }
    else
    {
        [self getUserPosts];
    }
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
}

/**
 *  获取帖子数据
 */
-(void)getUserPosts
{
    [CommonRemoteHelper RemoteWithUrl:URL_Get_flaglist parameters: @{@"flag" : [NSString stringWithFormat:@"%ld",(long)self.type] }
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     [self.tableView.header endRefreshing];
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum integerValue] > 0)//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         postsArr = [PostsModel objectArrayWithKeyValuesArray:[dict objectForKey:@"datas"]];
                                         if (postsArr.count == 0)
                                             [self.tableView initWithPlaceString:@"暂无数据"];
                                         [self.tableView reloadData];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.tableView.header endRefreshing];
                                     
                                 }];
}

/**
 *  获取说说和资讯数据
 */
-(void)getRecommendlist
{
    [CommonRemoteHelper RemoteWithUrl:URL_Get_recommendlist parameters: @{@"recommend" : self.type == BBSType_4 ? @"2" : @"3"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     [self.tableView.header endRefreshing];
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         postsArr = [PostsModel objectArrayWithKeyValuesArray:[dict objectForKey:@"datas"]];
                                         [self.tableView reloadData];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.tableView.header endRefreshing];
                                     
                                 }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return postsArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    //    if (indexPath.section == 0)
    //    {
    //        ProfileTopCell *consumeCell = [ProfileTopCell creatProfileConsumeCellWithTableView:tableView];
    //        consumeCell.tapConsumeCellBtnCallback = ^(ProfileTopCell *consumeCell,NSUInteger idx){
    //
    //            if ([SharedAppUtil defaultCommonUtil].userVO == nil)
    //                return   [MTNotificationCenter postNotificationName:MTNeedLogin object:nil userInfo:nil];
    //
    //            if (idx == 100)
    //            {
    //                return;
    //            }
    //            else if (idx == 200)
    //            {
    //                return;
    //            }
    //            [NoticeHelper AlertShow:@"尚未开通,敬请期待！" view:nil];
    //
    //            PostsDetailViewController *view = [[PostsDetailViewController alloc] init];
    //            [self.navigationController pushViewController:view animated:YES];
    //        };
    //        cell = consumeCell;
    //    }
    //    else if (indexPath.section == 1)
    //    {
    
    if (self.type == BBSType_4 || self.type == BBSType_1)
    {
        SiglePicCardCell *picCell = [SiglePicCardCell createCellWithTableView:tableView];
        [picCell setData];
        cell = picCell;
        //    [cardCell setItemdata:postsArr[indexPath.row]];
    }
    else
    {
        CardCell *cardCell = [CardCell createCellWithTableView:tableView];
        [cardCell setItemdata:postsArr[indexPath.row]];
        cell = cardCell;
    }
    
    return cell;
}


@end
