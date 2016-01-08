//
//  CitiesViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/11/24.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "CitiesViewController.h"
#import "HotCitiesCell.h"
#import "GPSCell.h"
#import "CCLocationManager.h"
#import "CitiesTotal.h"
#import "CityModel.h"

@interface CitiesViewController ()
{
    NSArray *dataProvider;
}

@end

@implementation CitiesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavgation];
    
    [self getDataProvider];
}

-(void)initNavgation
{
    self.title = [NSString stringWithFormat:@"当前城市--%@",self.selectedCity];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"btn_dismissItem.png"
                                                                 highImageName:@"btn_dismissItem_highlighted.png"
                                                                        target:self action:@selector(back)];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)getDataProvider
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Get_conf_address parameters: @{}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         [NoticeHelper AlertShow:@"获取失败!" view:self.view];
                                     }
                                     else
                                     {
                                         CitiesTotal *result = [CitiesTotal objectWithKeyValues:dict];
                                         dataProvider = result.datas;
                                         [self.tableView reloadData];
                                     }
                                     [HUD removeFromSuperview];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                     [NoticeHelper AlertShow:@"获取失败!" view:self.view];
                                 }];
}

-(void)back
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return section == 1? 1 : dataProvider.count;
    return dataProvider.count;
}

#pragma mark - 代理方法
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 20)];
    view.backgroundColor = HMColor(230, 230, 230);
    UILabel *lab = [[UILabel alloc] init];
    switch (section) {
        case 1:
            lab.text = @"定位城市";
            break;
        case 0:
            lab.text = @"开通城市";
            break;
        default:
            
            break;
    }
    lab.frame = CGRectMake(20, 5, 100, 20);
    lab.font = [UIFont systemFontOfSize:16];
    lab.textColor = [UIColor grayColor];
    [view addSubview:lab];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    tableView.sectionIndexColor = MTNavgationBackgroundColor;
//    return [dataProvider valueForKeyPath:@"title"];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    switch (indexPath.section)
    {
//        case 0:
//        {
//            GPSCell *gpscell =  [tableView dequeueReusableCellWithIdentifier:@"MTGPSCell"];
//            if (gpscell == nil)
//                gpscell = [GPSCell GPSCell];
//            
//            //赋值
//            UIButton *btn = (UIButton *)[gpscell viewWithTag:1];
//            [btn setTitle:[CCLocationManager shareLocation].lastCity forState:UIControlStateNormal];
//            btn.backgroundColor = [UIColor whiteColor];
//            btn.layer.borderWidth = 0.5;
//            btn.layer.borderColor = [HMColor(222, 222, 222) CGColor];
//            [btn addTarget:self action:@selector(btnClickHandler:) forControlEvents:UIControlEventTouchUpInside];
//            cell = gpscell;
//        }
//            break;
        case 0:
        {
            UITableViewCell *commoncell = [tableView dequeueReusableCellWithIdentifier:@"CommonCityCell"];
            if (commoncell == nil)
                commoncell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommonCityCell"];
            
            CityModel *vo = dataProvider[indexPath.row];
            
            if ([vo.dvname isEqualToString:self.selectedCity])
                commoncell.accessoryType = UITableViewCellAccessoryCheckmark;
            commoncell.textLabel.text = vo.dvname;
            commoncell.textLabel.font = [UIFont systemFontOfSize:14];
            cell = commoncell;
        }
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        CityModel *vo = dataProvider[indexPath.row];
        [SharedAppUtil defaultCommonUtil].cityVO = vo;
        [self.delegate selectedChange:vo.dvname];
    }];
}

-(void)btnClickHandler:(UIButton *)btn
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate selectedChange:btn.titleLabel.text];
    }];
}


@end
