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
    self.title = [NSString stringWithFormat:@"当前城市--%@",[CCLocationManager shareLocation].lastCity];
    
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
    dataProvider = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cityGroups.plist" ofType:nil]];
}

-(void)back
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 )
        return 170;
    else
        return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataProvider.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = [dataProvider[section] objectForKey:@"cities"];
    return section ==1 ? 1 : arr.count;
}

#pragma mark - 代理方法
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 20)];
    view.backgroundColor = HMColor(230, 230, 230);
    UILabel *lab = [[UILabel alloc] init];
    switch (section) {
        case 0:
             lab.text = @"定位城市";
            break;
        case 1:
             lab.text = @"热门城市";
            break;
        case 2:
             lab.text = [dataProvider[section] objectForKey:@"title"];
            break;
        default:
            lab.text = [dataProvider[section] objectForKey:@"title"];
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

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [dataProvider valueForKeyPath:@"title"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    switch (indexPath.section)
    {
        case 0:
        {
            GPSCell *gpscell =  [tableView dequeueReusableCellWithIdentifier:@"MTGPSCell"];
            if (gpscell == nil)
                gpscell = [GPSCell GPSCell];

            //赋值
            UIButton *btn = (UIButton *)[gpscell viewWithTag:1];
            [btn setTitle:[CCLocationManager shareLocation].lastCity forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor whiteColor];
            btn.layer.borderWidth = 0.5;
            btn.layer.borderColor = [HMColor(222, 222, 222) CGColor];

            cell = gpscell;
        }
            break;
        case 1:
        {
            HotCitiesCell *hotcell =  [tableView dequeueReusableCellWithIdentifier:@"MTHotCitiesCell"];
            if (hotcell == nil)
                hotcell = [HotCitiesCell hotCitiesCell];
            NSArray * arr = [dataProvider[indexPath.section] objectForKey:@"cities"];
            hotcell.dataProvider = [arr mutableCopy];
            cell = hotcell;
        }
            break;
        default:
        {
            UITableViewCell *commoncell = [tableView dequeueReusableCellWithIdentifier:@"CommonCityCell"];
            if (commoncell == nil)
                commoncell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommonCityCell"];
            NSArray *arr = [dataProvider[indexPath.section] objectForKey:@"cities"];
            
            commoncell.textLabel.text = arr[indexPath.row];
            commoncell.textLabel.font = [UIFont systemFontOfSize:14];
            cell = commoncell;
        }
            break;
    }
  
    
    for(UIView *view in [cell subviews])
    {
        if([[[view class] description] isEqualToString:@"UITableViewIndex"])
        {
            [view setBackgroundColor:[UIColor redColor]];
//            [view setFont:[UIFont systemFontOfSize:14]];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        NSString *str = [dataProvider[indexPath.section] objectForKey:@"cities"];
        [self.delegate selectedChange:str];
    }];
}

@end
