//
//  MarketClasslistController.m
//  QinQingBao
//
//  Created by shi on 16/8/15.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "MarketClasslistController.h"
#import "MarketClasslistCell.h"
#import "MarketViewController.h"
#import "TypeinfoModel.h"

@interface MarketClasslistController ()

@property (strong,nonatomic)NSArray *dataProvider;

@end

@implementation MarketClasslistController

-(instancetype)init
{
    if (self = [self initWithStyle:UITableViewStylePlain]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.backgroundColor = HMGlobalBg;
    
    self.navigationItem.title = @"服务市场";
    
    [self getdatsFromServices];
}

-(NSArray *)dataProvider
{
    if (!_dataProvider) {
        _dataProvider = [[NSArray alloc] init];
    }
    return _dataProvider;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataProvider.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MarketClasslistCell *cell = [MarketClasslistCell createCellWithTableView:tableView];
    
    TypeinfoModel *model = self.dataProvider[indexPath.row];
    NSURL *url = [[NSURL alloc] initWithString:model.url_app];
    [cell.contentImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MarketViewController *view = [[MarketViewController alloc] init];
    view.typeinfoModel = self.dataProvider[indexPath.row];
    [self.navigationController pushViewController:view animated:YES];
}

-(void)getdatsFromServices
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSDictionary *params = @{
                             @"beside_id" : @"[43]",
                             @"p":@1,
                             @"page":@50
                             };
    
    [CommonRemoteHelper RemoteWithUrl:URL_Get_typeinfo_applist parameters:params
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         [NoticeHelper AlertShow:[dict objectForKey:@"errorMsg"] view:nil];
                                     }
                                     else
                                     {
                                         self.dataProvider = [TypeinfoModel objectArrayWithKeyValuesArray:[dict objectForKey:@"datas"]];

                                         [self.tableView reloadData];
                                     }
                                     [HUD removeFromSuperview];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [NoticeHelper AlertShow:@"获取失败!" view:self.view];
                                     [HUD removeFromSuperview];
                                 }];
    
   

}


@end
