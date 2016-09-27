//
//  AllArticleTableViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/5/10.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "AllArticleTableViewController.h"

#import "ArticleModel.h"

#import "CommonArticleCell.h"

#import "NewsDetailViewControler.h"

@interface AllArticleTableViewController ()
{
    //资讯数据源
    NSArray *dataProvider;
}

@end

@implementation AllArticleTableViewController

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
    
    [self getNewsData];
    
    self.title = @"更多资讯";
    self.tableView.tableFooterView = [[UIView alloc] init];
}

/**
 *  获取资讯文章列表
 */
-(void)getNewsData
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_get_articles parameters:@{@"page" : @1000,
                                                                    @"p" : @1,
                                                                    @"type" : @0}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     NSDictionary *dict1 =  [dict objectForKey:@"datas"];
                                     [HUD removeFromSuperview];
                                     dataProvider = [ArticleModel objectArrayWithKeyValuesArray:dict1];
                                     [self.tableView reloadData];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                     [NoticeHelper AlertShow:@"获取失败!" view:self.view];
                                 }];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataProvider.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonArticleCell *articlecell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonArticleCell"];
    
    if (articlecell == nil)
        articlecell = [CommonArticleCell commonArticleCell];
    ArticleModel *item = dataProvider[indexPath.row];
    
    articlecell.titleLab.text = item.title;
    articlecell.subtitle = item.abstract;
    articlecell.commentcountLab.text = item.comment_count;
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_ImgArticle,item.logo_url]];
    [articlecell.headImg sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
    return articlecell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsDetailViewControler *view = [[NewsDetailViewControler alloc] init];
    ArticleModel *item = dataProvider[indexPath.row];
    view.articleItem = item;
    NSString *url;
    if (![SharedAppUtil defaultCommonUtil].userVO)
        url = [NSString stringWithFormat:@"%@/admin/manager/index.php/family/article_detail/%@?key=cxjk&like",URL_Local,item.id];
    else
        url = [NSString stringWithFormat:@"%@/admin/manager/index.php/family/article_detail/%@?key=%@&like",URL_Local,item.id,[SharedAppUtil defaultCommonUtil].userVO.key];
    view.url = url;
    [self.navigationController pushViewController:view animated:YES];
}

@end
