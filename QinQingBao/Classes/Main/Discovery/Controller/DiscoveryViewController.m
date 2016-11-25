//
//  DiscoveryViewController.m
//  QinQingBao
//
//  Created by shi on 16/9/9.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "LoopImageView.h"
#import "ScrollMenuTableCell.h"
#import "CommunityViewController.h"
#import "CircleModel.h"
#import "PostsDetailViewController.h"
#import "HomePicModel.h"
#import "CardCell.h"
#import "ShopDetailViewController.h"
#import "MarketDeatilViewController.h"
#import "MarketDeatilViewController.h"
#import "AdvertisementController.h"
#import "PostsModel.h"

#import "PublicProfileViewController.h"
#import "SearchViewController.h"
#import "MarketViewController.h"
#import "MapViewController.h"


@interface DiscoveryViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    PostsModel *selectedDeleteModel;
    NSIndexPath *selectedDeleteindexPath;
}

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *advDatas;     //轮播图数据

@end

@implementation DiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self getAdvertisementpic];
}

- (void)setupUI
{
    //导航栏
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    UITextField *searhField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, MTScreenW - 20, 30)];
    searhField.placeholder = @"输入搜索关键字";
    searhField.borderStyle = UITextBorderStyleRoundedRect;
    searhField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searhField.font = [UIFont systemFontOfSize:14];
    searhField.leftViewMode = UITextFieldViewModeAlways;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 2, 16, 16)];
    imgView.image = [UIImage imageNamed:@"search_gray"];
    [leftView addSubview:imgView];
    searhField.leftView = leftView;
    searhField.delegate = self;
    self.navigationItem.titleView = searhField;
    
    //UITableView
    UITableView *tbv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH) style:UITableViewStyleGrouped];
    tbv.delegate = self;
    tbv.dataSource = self;
    tbv.backgroundColor = HMColor(245, 245, 245);
    tbv.separatorInset = UIEdgeInsetsZero;
    tbv.layoutMargins = UIEdgeInsetsZero;
    [self.view addSubview:tbv];
    self.tableView = tbv;
    self.tableView.separatorColor = [UIColor colorWithRGB:@"ebebeb"];
    
    __weak typeof(self) weakSelf = self;
    //轮播图
    LoopImageView *loopView = [[LoopImageView alloc] init];
    loopView.bounds = CGRectMake(0, 0, MTScreenW, (int)(MTScreenW / 3));
    loopView.tapLoopImageCallBack= ^(NSInteger idx){
        [weakSelf onClickImage:idx];
    };
    tbv.tableHeaderView = loopView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    
    UITableViewCell *cell = nil;
    if (indexPath.row == 0){   //标题
        static NSString *cellId = @"titleCellId";
        UITableViewCell * titleCell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!titleCell) {
            titleCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
            titleCell.textLabel.font = [UIFont systemFontOfSize:16];
            titleCell.layoutMargins = UIEdgeInsetsZero;
        }
        
        switch (indexPath.section) {
            case 0:
                titleCell.textLabel.text = @"健康检测";
                break;
            case 1:
                titleCell.textLabel.text = @"服务网点";
                break;
            default:
                titleCell.textLabel.text = @"健康圈";
                break;
        }
        cell = titleCell;
        
    }else if (indexPath.section == 1 && indexPath.row == 1){  //地图cell
        static NSString *mapCellId = @"mapCell";
        UITableViewCell *mapCell = [tableView dequeueReusableCellWithIdentifier:mapCellId];
        if (!mapCell) {
            mapCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mapCellId];
            mapCell.selectionStyle = UITableViewCellSelectionStyleNone;
            mapCell.layoutMargins = UIEdgeInsetsZero;
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 90)];
            img.image = [UIImage imageNamed:@"采集网点.png"];
            [mapCell.contentView addSubview:img];
        }
        
        cell = mapCell;
    }else{
        ScrollMenuTableCell * menuCell = [ScrollMenuTableCell createCellWithTableView:tableView];
        menuCell.row = 1;
        menuCell.col = 4;
        menuCell.colSpace = 30;
        if (indexPath.section == 0) {
            //健康检测
            menuCell.margin = UIEdgeInsetsMake(10, 10, 10, 10);
            menuCell.shouldShowIndicator = NO;
            menuCell.datas = @[@{KScrollMenuTitle:@"心脑血管",KScrollMenuImg:@"xnxg_icon"},
                               @{KScrollMenuTitle:@"精英压力",KScrollMenuImg:@"jyyl_icon"},
                               @{KScrollMenuTitle:@"肝脏排毒",KScrollMenuImg:@"gzpd_icon"},
                               @{KScrollMenuTitle:@"其他",KScrollMenuImg:@"qt_icon"}
                               ];
            menuCell.selectMenuItemCallBack = ^(NSInteger idx){
                //跳转服务市场
                
                NSString *title = nil;
                NSString *tid = nil;
                switch (idx) {
                    case 0:
                        title = @"心脑血管";
                        tid = @"44";
                        break;
                    case 1:
                        title = @"精英压力";
                        tid = @"45";
                        break;
                    case 2:
                        title = @"肝脏排毒";
                        tid = @"46";
                        break;
                    default:
                        title = @"其他";
                        tid = @"47";
                        break;
                }
                
                MarketViewController *marketListVC = [[MarketViewController alloc] init];
                marketListVC.navTitle = title;
                marketListVC.tid = tid;
                [weakSelf.navigationController pushViewController:marketListVC animated:YES];
            };
        }else{
            
            menuCell.shouldShowIndicator = NO;
            menuCell.margin = UIEdgeInsetsMake(10, 10, 10, 10);
            
            NSMutableArray *ar = [[NSMutableArray alloc] init];
            for (int i = 0; i < 4; i++)
            {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                switch (i) {
                    case 0:
                        dict[KScrollMenuTitle] = @"专项运动";
                        dict[KScrollMenuImg] = @"d1.png";
                        break;
                    case 1:
                        dict[KScrollMenuTitle] = @"饮食调养";
                        dict[KScrollMenuImg] = @"d2.png";
                        break;
                    case 2:
                        dict[KScrollMenuTitle] =  @"心理干预";
                        dict[KScrollMenuImg] = @"d3.png";
                        break;
                    case 3:
                        dict[KScrollMenuTitle] =  @"自然疗法";
                        dict[KScrollMenuImg] = @"d4.png";
                        break;
                    default:
                        break;
                }
                
                [ar addObject:dict];
            }
            
            menuCell.datas = ar;
            menuCell.selectMenuItemCallBack = ^(NSInteger idx){
                [NoticeHelper AlertShow:@"暂未开通" view:nil];
            };
        }
        cell = menuCell;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
        return 40;
    }else if (indexPath.section == 0){
        return 90;
    }else if (indexPath.section == 1){
        return 90;
    }else {
        return 90;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MapViewController *map = [[MapViewController alloc] init];
    //    map.address = [NSString stringWithFormat:@"%@%@",_itemInfo.totalname,_itemInfo.orgaddress];;
    //    map.latitude = _itemInfo.orglat;
    //    map.longitude = _itemInfo.orglon;
    [self presentViewController:map animated:YES completion:nil];
}

#pragma mark - 网络相关

/**
 * 获取轮播图片
 **/
-(void)getAdvertisementpic
{
    [CommonRemoteHelper RemoteWithUrl:URL_Advertisementpic parameters:@{@"bc_uses_type" : @"1",
                                                                        @"bc_type" : @"0"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
        if([dict[@"code"] integerValue] != 0){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return ;
        }
        
        self.advDatas = [HomePicModel objectArrayWithKeyValuesArray:dict[@"datas"][@"data"]];
        
        NSMutableArray *imageUrls = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.advDatas.count; i++) {
            HomePicModel *model = self.advDatas[i];
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",URL_AdvanceImg,model.bc_value];
            [imageUrls addObject:urlStr];
        }
        LoopImageView *loopView = (LoopImageView *)self.tableView.tableHeaderView;
        loopView.imageUrls = imageUrls;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [NoticeHelper AlertShow:@"轮播图获取失败!" view:self.view];
    }];
}

#pragma mark - 事件方法
/**
 *  轮播广告点击事件
 */
-(void)onClickImage:(NSInteger)idx
{
    HomePicModel *item = self.advDatas[idx];
    if (item.bc_article_url.length == 0)
        return;
    
    // 43 超声理疗 44 精准健康监测分析 45疾病易感性基因检测
    
    if ([item.bc_type_app_id isEqualToString:@"43"])
    {
        ShopDetailViewController *view = [[ShopDetailViewController alloc] init];
        view.iid = item.bc_item_id;
        view.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:view animated:YES];
        
    }
    else if ([item.bc_type_app_id isEqualToString:@"44"])
    {
        MarketDeatilViewController *view = [[MarketDeatilViewController alloc] init];
        view.iid = item.bc_item_id;
        view.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:view animated:YES];
    }
    else if ([item.bc_type_app_id isEqualToString:@"45"])
    {
        MarketDeatilViewController *view = [[MarketDeatilViewController alloc] init];
        view.iid = item.bc_item_id;
        view.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:view animated:YES];
    }
    else
    {
        AdvertisementController *adver = [[AdvertisementController alloc] init];
        adver.item = item;
        [self.navigationController pushViewController:adver animated:YES];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    SearchViewController *searchVc = [[SearchViewController alloc] init];
    searchVc.type = SearchTypePosts;
    [self.navigationController pushViewController:searchVc animated:YES];
    return NO;
}

@end
