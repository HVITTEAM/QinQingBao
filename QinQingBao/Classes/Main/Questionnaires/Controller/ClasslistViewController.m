//
//  ClasslistViewController.m
//  QinQingBao
//
//  Created by shi on 16/8/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ClasslistViewController.h"
#import "AllQuestionController.h"
#import "ClasslistModel.h"
#import "ClasslistModelCell.h"
#import "SexViewController.h"


@interface ClasslistViewController ()

@property (strong,nonatomic)NSMutableArray *dataProvider;

@end

@implementation ClasslistViewController

-(instancetype)init
{
    if (self = [self initWithStyle:UITableViewStylePlain]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"健康评估";
    
    self.dataProvider = [[NSMutableArray alloc] init];
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self getDataProvider];
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataProvider.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ClasslistModelCell *cell = [ClasslistModelCell createCellWithTableView:tableView];
    
    [cell setModelWith:self.dataProvider[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 145;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:tableView cellForRowAtIndexPath:indexPath].height;
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
    ClasslistModel *model = self.dataProvider[indexPath.row];
    NSArray *exam_infoArray = model.exam_info;
    
    if (exam_infoArray.count == 1) {
        SexViewController *vc = [[SexViewController alloc] init];
        vc.examId = exam_infoArray[0];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(exam_infoArray.count> 1){
        AllQuestionController *vc = [[AllQuestionController alloc] init];
        vc.c_id = model.c_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/**
 *  获取数据源
 */
-(void)getDataProvider
{
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    
    [CommonRemoteHelper RemoteWithUrl:URL_Get_classlist parameters:nil type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
        
        if([dict[@"code"] integerValue] != 0){
            [NoticeHelper AlertShow:dict[@"errorMsg"] view:nil];
            [self.tableView initWithPlaceString:@"暂无数据"];
            return;
        }
        [self.tableView removePlace];
        NSMutableArray *datas = [[ClasslistModel objectArrayWithKeyValuesArray:dict[@"datas"]] mutableCopy];
        [self.dataProvider addObjectsFromArray:[datas copy]];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView initWithPlaceString:@"暂无数据"];
        [NoticeHelper AlertShow:@"请求出错" view:nil];
    }];}

@end
