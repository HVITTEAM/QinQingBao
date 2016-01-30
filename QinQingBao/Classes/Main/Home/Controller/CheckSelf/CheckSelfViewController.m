//
//  CheckSelfViewController.m
//  QinQingBao
//
//  Created by shi on 15/8/25.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#define kBodyTableViewRowHeight 50
#define kSymptomTableViewRowHeight 50
#define kNaviBarHeight 64

#import "CheckSelfViewController.h"
#import "CheckSelfBodyModel.h"
#import "SymptomNameModel.h"
#import "BodyCell.h"
#import "SymptomDetailViewController.h"

@interface CheckSelfViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *bodyTableView;             //症状位置

@property (weak, nonatomic) IBOutlet UITableView *symptomTableView;            //症状

@property(strong,nonatomic)NSMutableArray *bodyArray;                      //症状位置数据源

@property(strong,nonatomic)NSMutableArray *symptomArray;            //具体症状数据源

@property(strong,nonatomic)MBProgressHUD *hud;

@end

@implementation CheckSelfViewController

-(instancetype)init
{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self initTableView];
    
    [self loadBodyDatas];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark -- getter方法 --

-(NSMutableArray *)bodyArray
{
    if (!_bodyArray) {
        _bodyArray = [[NSMutableArray alloc] init];
    }
    return _bodyArray;
}

-(NSMutableArray *)symptomArray
{
    if (!_symptomArray) {
        _symptomArray = [[NSMutableArray alloc] init];
    }
    return _symptomArray;
}

#pragma mark -- 初始化子视图方法 --

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.navigationItem.title = @"状态自查";
    self.automaticallyAdjustsScrollViewInsets = YES;
}

/**
 *  初始化表视图
 */
-(void)initTableView
{
    self.bodyTableView.delegate = self;
    self.bodyTableView.dataSource = self;
    self.bodyTableView.rowHeight = kBodyTableViewRowHeight;
//    self.bodyTableView.contentInset = UIEdgeInsetsMake(kNaviBarHeight, 0, 0, 0);
    self.bodyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.symptomTableView.delegate = self;
    self.symptomTableView.dataSource = self;
    self.symptomTableView.rowHeight = kSymptomTableViewRowHeight;
    self.symptomTableView.contentInset = UIEdgeInsetsMake(kNaviBarHeight, 0, 0, 0);
    self.symptomTableView.separatorInset = UIEdgeInsetsZero;
    if ([ self.symptomTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.symptomTableView  setLayoutMargins:UIEdgeInsetsZero];
    }
    self.symptomTableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark -- 协议方法 --
#pragma mark tableView dataSourse

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.bodyTableView == tableView) {
        return self.bodyArray.count;
    }
    return self.symptomArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *bodyCellId = @"bodyCell";
    static NSString *symptomCellId = @"symptomCell";
    
    if (self.bodyTableView == tableView) {
        //返回症状位置Cell
        BodyCell *cell = [tableView dequeueReusableCellWithIdentifier:bodyCellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"BodyCell" owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.titleLb.text = ((CheckSelfBodyModel *)self.bodyArray[indexPath.row]).name;
        
        return cell;
    }else{
        //返回具体症状Cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:symptomCellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:symptomCellId];
            cell.detailTextLabel.textColor = HMColor(102, 102, 102);
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
        }
        
        cell.detailTextLabel.text = ((SymptomNameModel *)self.symptomArray[indexPath.row]).name;
        
        return cell;
    }
}

#pragma mark tableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.bodyTableView == tableView){
        
        CheckSelfBodyModel *model = self.bodyArray[indexPath.row];
        [self loadSymptomNameDatasWithBodyMode:model];
        
    }else{
        SymptomDetailViewController *symptomDetailVC = [[SymptomDetailViewController alloc] init];
        symptomDetailVC.nameModel = self.symptomArray[indexPath.row];
//        [self.tabBarController.tabBar setHidden:YES];
        [self.navigationController pushViewController:symptomDetailVC animated:YES];
    }
}

#pragma mark -- 网络相关方法 --
/**
 *  从服务器下载身体部位数据
 */
-(void)loadBodyDatas
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [CommonRemoteHelper RemoteWithUrl:URL_symptom_body_list parameters:nil type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        //获取数据出错
        if ([dict[@"code"] integerValue] != 0) {
            [NoticeHelper AlertShow:@"抱歉,无法获取到数据" view:self.view];
            return;
        }
       //转成 model
        NSMutableArray *bodyArray = [CheckSelfBodyModel objectArrayWithKeyValuesArray:dict[@"datas"]];
        
        self.bodyArray = bodyArray;
        
        [self.bodyTableView reloadData];
        
        [self loadSymptomNameDatasWithBodyMode:self.bodyArray[0]];
        
        [self.bodyTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

/**
 *  从服务器下载症状数据
 */
-(void)loadSymptomNameDatasWithBodyMode:(CheckSelfBodyModel *)model
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *params = @{
                             @"body_id":@(model.body_id)
                             };
    
    [CommonRemoteHelper RemoteWithUrl:URL_symptom_name_list parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        //获取数据出错
        if ([dict[@"code"] integerValue] != 0) {
            [NoticeHelper AlertShow:@"抱歉,无法获取到数据" view:self.view];
            return;
        }
        //转成 model
        NSMutableArray *symptomTempArray = [SymptomNameModel objectArrayWithKeyValuesArray:dict[@"datas"]];
        self.symptomArray = symptomTempArray;
       [self.symptomTableView reloadData];
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

@end
