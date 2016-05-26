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
#import "SectionHeadView.h"

@interface CitiesViewController ()
{
    NSArray *dataProvider;
    NSMutableArray *expandedSectionArr;
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
    expandedSectionArr = [[NSMutableArray alloc] init];
    
    self.title = @"选择地区";
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"btn_dismissItem.png"
                                                                 highImageName:@"btn_dismissItem_highlighted.png"
                                                                        target:self action:@selector(back)];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)getDataProvider
{
    dataProvider = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"areaList.plist" ofType:nil]];
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataProvider.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr;
    if (section == 0)
        return 1;
    else
        if ([expandedSectionArr indexOfObject:[NSString stringWithFormat:@"%ld",(long)section]] != NSNotFound)
        {
            arr  = [dataProvider[section -1] objectForKey:@"regions"];
            return arr.count;
        }
        else
            return 0;
}

#pragma mark - 代理方法
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SectionHeadView *sectionView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 50) expanded:YES];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 20)];
    view.backgroundColor = HMColor(230, 230, 230);
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(20, 5, 100, 20);
    lab.font = [UIFont systemFontOfSize:16];
    lab.textColor = [UIColor grayColor];
    [view addSubview:lab];
    
    if (section == 0)
    {
        lab.text = @"定位城市";
        return view;
    }
    else
    {
        NSString *title = [dataProvider[section -1] objectForKey:@"name"];
        [sectionView setTitle:title indexSection:section];
        sectionView.expandedClick = ^(NSInteger section)
        {
            if ([expandedSectionArr indexOfObject:[NSString stringWithFormat:@"%ld",(long)section]] == NSNotFound)
                [expandedSectionArr addObject:[NSString stringWithFormat:@"%ld",(long)section]];
            else
                [expandedSectionArr removeObject:[NSString stringWithFormat:@"%ld",(long)section]];
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        };
        return sectionView;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 30;
    else
        return 50;
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    tableView.sectionIndexColor = MTNavgationBackgroundColor;
//    return [dataProvider valueForKeyPath:@"title"];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0)
    {
        GPSCell *gpscell =  [tableView dequeueReusableCellWithIdentifier:@"MTGPSCell"];
        if (gpscell == nil)
            gpscell = [GPSCell GPSCell];
        
        //赋值
        UIButton *btn = (UIButton *)[gpscell viewWithTag:1];
        if (![SharedAppUtil defaultCommonUtil].lat)
            [gpscell setCityValue:@"定位失败，请重试"];
        else
            [gpscell setCityValue:[CCLocationManager shareLocation].lastCity];
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = [HMColor(222, 222, 222) CGColor];
        [btn addTarget:self action:@selector(btnClickHandler:) forControlEvents:UIControlEventTouchUpInside];
        cell = gpscell;
    }
    else
    {
        UITableViewCell *commoncell = [tableView dequeueReusableCellWithIdentifier:@"CommonCityCell"];
        if (commoncell == nil)
        {
            commoncell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommonCityCell"];
        }
        NSArray *arr = [dataProvider[indexPath.section -1] objectForKey:@"regions"];
        
        commoncell.textLabel.text = [arr[indexPath.row] objectForKey:@"name"];
        commoncell.textLabel.font = [UIFont systemFontOfSize:14];
        commoncell.backgroundColor = HMGlobalBg;
        cell = commoncell;
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 )
        return;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        NSArray *arr = [dataProvider[indexPath.section -1] objectForKey:@"regions"];
        NSDictionary *dict1 = arr[indexPath.row];
        
        CityModel *vo = [[CityModel alloc] init];
        vo.dvname = [dict1 objectForKey:@"name"];
        vo.dvcode = [dict1 objectForKey:@"dvcode"];
        
        [SharedAppUtil defaultCommonUtil].cityVO = vo;
        [self.delegate selectedChange:vo.dvname];
    }];
}

-(void)btnClickHandler:(UIButton *)btn
{
    if (![CCLocationManager shareLocation].lastCity)
    {
        [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            NSLog(@"%f %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude);
            [SharedAppUtil defaultCommonUtil].lat = [NSString stringWithFormat:@"%f",locationCorrrdinate.latitude];
            [SharedAppUtil defaultCommonUtil].lon = [NSString stringWithFormat:@"%f",locationCorrrdinate.longitude];
        }];
        
        //获取定位城市和地区block
        [[CCLocationManager shareLocation] getCityAndArea:^(NSString *addressString) {
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    }
    else
    {
        [self.delegate selectedChange:btn.titleLabel.text];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
