//
//  DataCitiesViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/12/7.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "DataCitiesViewController.h"
#import "CitiesTotal.h"


@interface DataCitiesViewController ()
{
    NSMutableArray *dataProvider;
    bool isReadPushBack;
}

@end

@implementation DataCitiesViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavgation];
    
    if (!self.dvcode_id)
        self.dvcode_id = @"0";
    
    [self getDataProvider];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (isReadPushBack)
    {
         [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
    }
}

-(void)initNavgation
{
    self.tableView.backgroundColor = HMGlobalBg;
    self.title = self.viewTitle ? self.viewTitle :@"选择省份";
    self.tableView.tableFooterView = [[UIView alloc] init];
}


-(void)getDataProvider
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Get_address parameters: @{@"dvcode_id" : self.dvcode_id ,
                                                                    @"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                    @"client" : @"ios",
                                                                    @"all" : @0}
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
                                     [self.view endEditing:YES];
                                     [HUD removeFromSuperview];
                                 }];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataProvider.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MtCommonCell"];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MtCommonCell"];
    
    CityModel * vo = dataProvider[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = vo.dvname;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.title isEqualToString:@"选择城市"])
    {
        CityModel *vo = dataProvider[indexPath.row];
        self.detailStr = [NSString stringWithFormat:@"%@%@",self.detailStr,vo.dvname];
        self.selectedHandler(vo, self.detailStr);
        isReadPushBack = YES;
        
        [self viewDidAppear:YES];
    }
    else
    {
        DataCitiesViewController *VC = [[DataCitiesViewController alloc] init];
        CityModel *vo = dataProvider[indexPath.row];
        VC.selectedHandler = self.selectedHandler;
        VC.dvcode_id = vo.dvcode;
        VC.detailStr = vo.dvname;
        VC.viewTitle = @"选择城市";
        [self.navigationController pushViewController:VC animated:YES];
    }
}

@end