//
//  PostsTableViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/9/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "PostsTableViewController.h"
#import "PostsDetailViewController.h"

#import "CardCell.h"
#import "PostsModel.h"
#import "QuestionCell.h"
#import "SiglePicCardCell.h"

@interface PostsTableViewController ()
{
    NSArray *postsArr;
    
    NSArray *recommendlist;
}
@end

@implementation PostsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 105, 0);
    
    [self setupRefresh];
    
    [self getData];
    
}

#pragma mark 集成刷新控件

-(void)getData
{
    if (self.type == BBSType_4 || self.type == BBSType_1)
    {
        [self getRecommendlist];
        [self getUserPosts];
    }
    else if (self.type == BBSType_4)
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
                                             [self.tableView initWithPlaceString:@"暂无数据" imgPath:nil];
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
                                         recommendlist = [PostsModel objectArrayWithKeyValuesArray:[dict objectForKey:@"datas"]];
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
    if (self.type  == BBSType_1)
        return 3;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.type  == BBSType_1)
    {
        switch (section)
        {
            case 0:
                return 3;
                break;
            case 1:
                return 1;
                break;
            case 2:
                return postsArr.count;
                break;
            default:
                return  postsArr.count;
        }
    }
    else  if (self.type  == BBSType_4)
        return recommendlist.count;
    else
        return postsArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.type  == BBSType_1)
        return 8;
    return 0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (self.type == BBSType_4 || self.type == BBSType_1)
    {
        if (indexPath.section == 0)
        {
            SiglePicCardCell *picCell = [SiglePicCardCell createCellWithTableView:tableView];
            [picCell setItemdata:recommendlist[indexPath.row]];
            cell = picCell;
        }
        else if (indexPath.section == 1)
        {
            QuestionCell *quecell = [QuestionCell createCellWithTableView:tableView];
            cell = quecell;
        }
        else
        {
            CardCell *cardCell1 = [CardCell createCellWithTableView:tableView];
            [cardCell1 setItemdata:postsArr[indexPath.row]];
            cell = cardCell1;
        }
    }
    else
    {
        CardCell *cardCell = [CardCell createCellWithTableView:tableView];
        [cardCell setItemdata:postsArr[indexPath.row]];
        cell = cardCell;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostsDetailViewController *view = [[PostsDetailViewController alloc] init];
//    [view setItemdata:postsArr[indexPath.row]];
    [self.parentVC.navigationController pushViewController:view animated:YES];
}

@end
