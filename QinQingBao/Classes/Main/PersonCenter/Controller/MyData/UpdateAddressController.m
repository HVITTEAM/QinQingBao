//
//  UpdateAddressController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/11/20.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "UpdateAddressController.h"
#import "HMCommonTextfieldItem.h"
#import "DataCitiesViewController.h"
#import "StreetViewController.h"
#import "CityModel.h"
#import "CitiesTotal.h"

@interface UpdateAddressController ()<UIActionSheetDelegate>
{
    HMCommonArrowItem *textItem0;
    HMCommonArrowItem *textItem;
    HMCommonTextfieldItem *textItem1;
    
    NSMutableArray *addressArr;
    
    NSString *selectedCityStr;
    NSString *selectedStreetStr;
    
    NSArray *provinces;
    NSArray *cities;
    NSArray *state;
    NSArray *areas;
    NSString *city;
    NSString *district;
    
    
    NSString *selectedAddress;
    UIPickerView *areaPicker;
}
@property (nonatomic, retain) CityModel *selectedCity;

@property (nonatomic, retain) CityModel *selectedStreet;


@end

@implementation UpdateAddressController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initNavigation];
    
    [self setupGroups];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableviewSkin];
    
    [self getAddress];
    
    if (self.inforVO.totalname)
    {
        NSArray *array = [self.inforVO.totalname componentsSeparatedByString:@"市"]; //从字符A中分隔成2个元素的数组
        selectedCityStr = [NSString stringWithFormat:@"浙江省%@市",array[0]];
        selectedStreetStr = [NSString stringWithFormat:@"%@",array[1]];
    }
}

-(void)getAddress
{
    if (!self.inforVO.member_areaid)
        return;
    [CommonRemoteHelper RemoteWithUrl:URL_Get_address parameters:@{@"dvcode_id" : self.inforVO.member_areaid,
                                                                   @"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                   @"client" : @"ios",
                                                                   @"all" : @5}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         NSLog(@"获取地址失败");
                                     }
                                     else
                                     {
                                         addressArr = [dict objectForKey:@"datas"][0];
                                         [self initAddressVO];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.view endEditing:YES];
                                 }];
    
}

-(void)initAddressVO
{
    _selectedCity = [CityModel objectWithKeyValues:addressArr[1]];
    
    CityModel *vo = [[CityModel alloc] init];
    vo.dvcode = self.inforVO.member_areaid;
    vo.dvname = selectedStreetStr;
    _selectedStreet = vo;
}

/**
 *  设置tableView属性
 */
-(void)initTableviewSkin
{
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionFooterHeight = HMStatusCellMargin;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(HMStatusCellMargin - 35, 0, 0, 0);
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
//    if (self.dict)
//        self.title = [self.dict valueForKey:@"title"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneClickHandler)];
}

# pragma  mark 设置数据源
/**
 *  初始化模型数据
 */
- (void)setupGroups
{
    [self.groups removeAllObjects];
    
    [self setupGroup];
}

- (void)setupGroup
{
    // 1.创建组
    HMCommonGroup *group0 = [HMCommonGroup group];
    [self.groups addObject:group0];
    
    // 1.设置组的所有行数据
    textItem0= [HMCommonArrowItem itemWithTitle:@"城市" icon:nil];
    textItem0.subtitle = selectedCityStr;
    NSLog(@"dadda%@",_selectedCity.dvname);
    __weak __typeof(self)weakSelf = self;
    
    textItem0.operation = ^{
        DataCitiesViewController *VC = [[DataCitiesViewController alloc] init];
        VC.selectedHandler = ^(CityModel *VO, NSString *str)
        {
            selectedCityStr = str;
            _selectedCity = VO;
            _selectedStreet = nil;
            [weakSelf setupGroups];
            selectedStreetStr = nil;
            [weakSelf.tableView reloadData];
        };
        [weakSelf.navigationController pushViewController:VC animated:YES];
    };
    group0.items = @[textItem0];
    
    // 2.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    // 2.设置组的所有行数据
    textItem = [HMCommonArrowItem itemWithTitle:@"街道社区" icon:nil];
    textItem.subtitle = selectedStreetStr;
    textItem.operation = ^{
        if (!weakSelf.selectedCity)
            return [NoticeHelper AlertShow:@"请选择城市" view:weakSelf.view];
        StreetViewController *VC = [[StreetViewController alloc] init];
        VC.dvcode_id = weakSelf.selectedCity.dvcode;
        VC.selectedHandler = ^(CityModel *VO, NSString *str)
        {
            selectedStreetStr = str;
            _selectedStreet = VO;
            [weakSelf setupGroups];
            [weakSelf.tableView reloadData];
        };
        [weakSelf.navigationController pushViewController:VC animated:YES];
    };
    
    group.items = @[textItem];
    
    // 3.创建组
    HMCommonGroup *group1 = [HMCommonGroup group];
    [self.groups addObject:group1];
    // 3.设置组的所有行数据
    textItem1 = [HMCommonTextfieldItem itemWithTitle:@"门牌号" icon:nil];
//    textItem1.placeholder = [self.dict valueForKey:@"placeholder"];
    textItem1.textValue = self.inforVO.member_areainfo;
    group1.items = @[textItem1];
    
    //刷新表格
    [self.tableView reloadData];
}

/**
 *  确认修改
 */
-(void)doneClickHandler
{
    NSString * str = textItem1.rightText.text;
    
    if (!_selectedStreet || !str)
        return [NoticeHelper AlertShow:@"请填写详细信息" view:self.view];
    
    [self.view endEditing:YES];
    
    NSString *addressStr = [self.title isEqualToString:@"修改地址"] ? str : self.inforVO.member_areainfo;
    NSString *nameStr = [self.title isEqualToString:@"修改姓名"] ? textItem.rightText.text : self.inforVO.member_truename;
    NSString *mailStr = [self.title isEqualToString:@"修改邮箱"] ? textItem.rightText.text : self.inforVO.member_email;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"ios" forKey:@"client"];
    
    if (self.inforVO.member_sex != nil && [self.inforVO.member_sex floatValue] > 0)
        [dict setObject:self.inforVO.member_sex forKey:@"member_sex"];
    if (nameStr)
        [dict setObject:nameStr forKey:@"member_truename"];
    if (mailStr)
        [dict setObject:mailStr forKey:@"member_email"];
    if (self.inforVO.member_birthday != nil)
        [dict setObject:self.inforVO.member_birthday forKey:@"member_birthday"];
    
    if (addressStr)
        [dict setObject:addressStr forKey:@"member_areainfo"];
    
    if ([self.title isEqualToString:@"修改地址"])
        [dict setObject:str forKey:@"member_areainfo"];
    
    if ([self.title isEqualToString:@"修改地址"])
        [dict setObject:_selectedStreet.dvcode forKey:@"member_areaid"];
    
    if (_selectedStreet)
        [dict setObject:_selectedStreet.dvcode forKey:@"member_areaid"];
    
    if ([SharedAppUtil defaultCommonUtil].userVO.key != nil)
        [dict setObject:[SharedAppUtil defaultCommonUtil].userVO.key forKey:@"key"];
    
    
    //分情况判断
    if (self.editHandlerBlock)//下单更改地址
    {
        if (_selectedStreet)
            self.inforVO.member_areaid = _selectedStreet.dvcode;
        self.inforVO.member_areainfo = str;
        
        NSString *cityStr = [selectedCityStr substringFromIndex:3];
        self.inforVO.totalname = [NSString stringWithFormat:@"%@%@",cityStr,selectedStreetStr];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        return self.editHandlerBlock(self.inforVO);
    }
    else//个人中心更改资料
    {
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [CommonRemoteHelper RemoteWithUrl:URL_EditUserInfor parameters:dict
                                     type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                         id codeNum = [dict objectForKey:@"code"];
                                         if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                         {
                                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"保存失败" message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                             [alertView show];
                                         }
                                         else
                                         {
                                             [self.navigationController popViewControllerAnimated:YES];
                                             if (self.refleshDta)
                                                 self.refleshDta();
                                         }
                                         [HUD removeFromSuperview];
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"发生错误！%@",error);
                                         [HUD removeFromSuperview];
                                         [self.view endEditing:YES];
                                     }];

    }
}



@end
