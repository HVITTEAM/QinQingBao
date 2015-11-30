//
//  CitiesViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/11/24.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "CitiesViewController.h"
#import "HotCitiesCell.h"

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
    self.title = @"城市选择";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
}

-(void)getDataProvider
{
    dataProvider = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cityGroups.plist" ofType:nil]];
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 )
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
    return section ==0 ? 1 : arr.count;
}

#pragma mark - 代理方法
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return  [dataProvider[section] objectForKey:@"title"];
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
            
//            UIButton *btn = (UIButton *)[cell viewWithTag:1];
//            [btn setTitle:self.dataProvider[indexPath.row] forState:UIControlStateNormal];
//            btn.backgroundColor = [UIColor whiteColor];
//            btn.layer.borderWidth = 0.5;
//            btn.layer.borderColor = [HMColor(222, 222, 222) CGColor];

            
            HotCitiesCell *hotcell =  [tableView dequeueReusableCellWithIdentifier:@"MTHotCitiesCell"];
            if (hotcell == nil)
                hotcell = [HotCitiesCell hotCitiesCell];
            NSArray * arr = [dataProvider[indexPath.section] objectForKey:@"cities"];
            hotcell.dataProvider = [arr mutableCopy];
            cell = hotcell;
        }
            break;
        case 1:
        {
            UITableViewCell *commoncell = [tableView dequeueReusableCellWithIdentifier:@"CommonCityCell"];
            if (commoncell == nil)
                commoncell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommonCityCell"];
            NSArray *arr = [dataProvider[indexPath.section] objectForKey:@"cities"];
            
            commoncell.textLabel.text = arr[indexPath.row];
            
            cell = commoncell;
        }
            break;
        default:
        {
            UITableViewCell *commoncell = [tableView dequeueReusableCellWithIdentifier:@"CommonCityCell"];
            if (commoncell == nil)
                commoncell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommonCityCell"];
            NSArray *arr = [dataProvider[indexPath.section] objectForKey:@"cities"];
            
            commoncell.textLabel.text = arr[indexPath.row];
            
            cell = commoncell;
        }
            break;
    }
  
    return cell;
}

@end
