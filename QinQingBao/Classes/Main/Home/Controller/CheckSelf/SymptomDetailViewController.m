//
//  SymptomDetailViewController.m
//  QinQingBao
//
//  Created by shi on 16/1/21.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#define kNaviBarHeight 64

#import "SymptomDetailViewController.h"
#import "SectionHeaderView.h"
#import "SymptomNameModel.h"
#import "SymptomInfo.h"
#import "DiseaseModel.h"
#import "InfoViewCell.h"
#import "InfoDetailViewController.h"
#import "FoodCell.h"
#import "DiseaseCell.h"
#import "TipsCell.h"

@interface SymptomDetailViewController ()

@property(strong,nonatomic)SymptomInfo *symptomInfo;              //症状详情(tableView数据源)

@property(assign,nonatomic)BOOL isSpread;          //是否展开

@end

@implementation SymptomDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavBar];
    
    [self initTableView];
    
    [self loadSymptomDetailDatasWithNameModel:self.nameModel];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark -- 初始化子视图方法 --
/**
 *  初始化导航栏
 */
-(void)initNavBar
{
    self.navigationItem.title = self.nameModel.name;
}

/**
 *  初始化TableView
 */
-(void)initTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(kNaviBarHeight, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark -- 协议方法 --
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //没有数据时
    if (self.symptomInfo == nil) {
        return 0;
    }
    //正常有数据时
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    //没有数据时
    //    if (self.symptomInfo == nil) {
    //        return 0;
    //    }
    if (section == 2) {
        //可能疾病
        return  self.symptomInfo.disease.count;
    }else if (section == 4){
        //宜忌食物
        return 2;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if (section == 0) {   //症状简介
        NSString *content = self.symptomInfo.info;
        InfoViewCell *cell = [[InfoViewCell alloc] initInfoViewCellWithContent:content
                                                                     tableView:tableView
                                                                     indexpath:indexPath];
        return cell;
    }else if (section == 1){   //病因
        NSString *content = self.symptomInfo.pathogeny;
        InfoViewCell *cell = [[InfoViewCell alloc] initInfoViewCellWithContent:content
                                                                     tableView:tableView
                                                                     indexpath:indexPath];
        return cell;
    }else if (section == 3){       //预防
        NSString *content = self.symptomInfo.prevention;
        InfoViewCell *cell = [[InfoViewCell alloc] initInfoViewCellWithContent:content
                                                                     tableView:tableView
                                                                     indexpath:indexPath];
        return cell;
    }else if (section == 4){       //宜忌食物
        FoodCell *cell = [[FoodCell alloc] initFoodCellWithTableView:tableView indexpath:indexPath];
        if (indexPath.row == 0) {
            cell.titleStr = @"宜吃食物";
            cell.contentStr = self.symptomInfo.suitable_food;
            [cell setupCell];
            return cell;
        }
        cell.titleStr = @"忌吃食物";
        cell.contentStr = self.symptomInfo.unSuitable_food;
        [cell setupCell];
        return cell;
    }else if (section == 5){       //提示
        TipsCell *cell = [[TipsCell alloc] initTipsCellWithTableView:tableView indexpath:indexPath];
        cell.contentStr = self.symptomInfo.tips;
        return cell;
    }
    
    //可能疾病
    DiseaseCell *cell = [[DiseaseCell alloc]initDiseaseCellWithTableView:tableView indexpath:indexPath];
    cell.diseasemodel = self.symptomInfo.disease[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static InfoViewCell *infocell = nil;
    
    NSInteger section = indexPath.section;
    if (section == 0 || section == 1 || section == 3) {
        
        if (!infocell) {
            infocell = [[[NSBundle mainBundle] loadNibNamed:@"InfoViewCell" owner:nil options:nil] lastObject];
        }
        if (section == 0) {          //计算症状简介高度
            return [infocell getCellHeightWithContent:self.symptomInfo.info tableView:tableView];
        }else if (section == 1){     //计算病因高度
            return [infocell getCellHeightWithContent:self.symptomInfo.pathogeny tableView:tableView];
        }else if (section == 3){     //计算预防高度
            return [infocell getCellHeightWithContent:self.symptomInfo.prevention tableView:tableView];
        }
    }else if (section == 4){          //计算宜忌食物高度
        static FoodCell *foodCell = nil;
        if (!foodCell) {
            foodCell = [[FoodCell alloc] initFoodCellWithTableView:tableView indexpath:indexPath];
        }
        if (indexPath.row == 0) {
            foodCell.titleStr = @"宜吃食物";
            foodCell.contentStr = self.symptomInfo.suitable_food;
        }else{
            foodCell.titleStr = @"忌吃食物";
            foodCell.contentStr = self.symptomInfo.unSuitable_food;
        }
        return [foodCell getCellHeightWithTableView:tableView];
        
    }else if (section == 5){         //计算提示高度
        static TipsCell *tipsCell = nil;
        if (!tipsCell) {
            tipsCell = [[TipsCell alloc] initTipsCellWithTableView:tableView indexpath:indexPath];
        }
        return [tipsCell getCellHeightWithContent:self.symptomInfo.tips tableView:tableView];
        
    }else if (section == 2){    //计算可能疾病高度
        
        static DiseaseCell *diseaseCell = nil;
        if (!diseaseCell) {
            diseaseCell = [[DiseaseCell alloc]initDiseaseCellWithTableView:tableView indexpath:indexPath];
        }
        DiseaseModel *model = self.symptomInfo.disease[indexPath.row];
        return [diseaseCell getCellHeightWithModel:model tableView:tableView];
    }
    
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SectionHeaderView *headView;
    
    switch (section) {
        case 0:
            headView = [SectionHeaderView createSectionHeaderWithSectionName:@"症状简介"
                                                                    iconName:@"searchresult_doctors_icon"];
            break;
        case 1:
            headView = [SectionHeaderView createSectionHeaderWithSectionName:@"病因"
                                                                    iconName:@"searchresult_treats_icon"];
            break;
        case 2:
            headView = [SectionHeaderView createSectionHeaderWithSectionName:@"可能疾病"
                                                                    iconName:@"search_result_pedias_icon"];
            break;
        case 3:
            headView = [SectionHeaderView createSectionHeaderWithSectionName:@"预防"
                                                                    iconName:@"searchresult_doctors_icon"];
            break;
        case 4:
            headView = [SectionHeaderView createSectionHeaderWithSectionName:@"宜忌食物"
                                                                    iconName:@"search_result_pedias_icon"];
            break;
        case 5:
            headView = [SectionHeaderView createSectionHeaderWithSectionName:@"温馨提示"
                                                                    iconName:@"search_result_pedias_icon"];
            break;
        default:
            break;
    }
    return headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    
    if (section == 0 || section == 1 || section == 2 || section == 3) {
        InfoDetailViewController * infoDetailVC = [[InfoDetailViewController alloc] init];
        infoDetailVC.navTitle = self.symptomInfo.name;
        if (section == 0) {
            infoDetailVC.detail = self.symptomInfo.info;
            infoDetailVC.headTitle = @"症状简介";
            infoDetailVC.headIconName = @"searchresult_doctors_icon";
            
        }else if (section == 1){
            infoDetailVC.detail = self.symptomInfo.pathogeny;
            infoDetailVC.headTitle = @"病因";
            infoDetailVC.headIconName = @"searchresult_treats_icon";
        }else if (section == 3){
            infoDetailVC.detail = self.symptomInfo.prevention;
            infoDetailVC.headTitle = @"预防";
            infoDetailVC.headIconName = @"searchresult_doctors_icon";
        }else if (section == 2){
            DiseaseModel *diseaseModel = self.symptomInfo.disease[indexPath.row];
            infoDetailVC.detail = diseaseModel.disease_detail;
            infoDetailVC.navTitle = diseaseModel.disease;
            infoDetailVC.headIconName = @"search_result_pedias_icon";
            infoDetailVC.headTitle = @"疾病简介";
        }
        [self.navigationController pushViewController:infoDetailVC animated:YES];
    }
}

/**
 *  从服务器下载症状详情数据
 */
-(void)loadSymptomDetailDatasWithNameModel:(SymptomNameModel *)model
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *params = @{
                             @"id":@(model.SymptomNameId)
                             };
    
    [CommonRemoteHelper RemoteWithUrl:URL_symptom_info parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([dict[@"code"] integerValue] != 0) {
            [NoticeHelper AlertShow:@"抱歉,无法获取到数据" view:self.view];
            return;
        }
        //转成 model
        SymptomInfo *tempInfo  =  [SymptomInfo objectWithKeyValues:dict[@"datas"]];
        self.symptomInfo = tempInfo;
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


@end
