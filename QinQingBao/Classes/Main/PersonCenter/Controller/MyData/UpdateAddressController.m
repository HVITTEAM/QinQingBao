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

@interface UpdateAddressController ()<UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate>
{
    HMCommonArrowItem *textItem0;
    HMCommonArrowItem *textItem;
    HMCommonTextfieldItem *textItem1;
    
    NSMutableArray *addressArr;
    
    CityModel *selectedCity;
    NSString *selectedCityStr;
    CityModel *selectedStreet;
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
    if (! self.inforVO.member_areaid)
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
    selectedCity = [CityModel objectWithKeyValues:addressArr[1]];
    
    CityModel *vo = [[CityModel alloc] init];
    vo.dvcode = self.inforVO.member_areaid;
    vo.dvname = selectedStreetStr;
    selectedStreet = vo;
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
    if (self.dict)
        self.title = [self.dict valueForKey:@"title"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneClickHandler)];
    
    //适配ios7.0的导航栏
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0 && !self.changeDataBlock)
    {
        self.navigationController.navigationBar.translucent = NO;
    }
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
    NSLog(@"dadda%@",selectedCity.dvname);
    __weak __typeof(self)weakSelf = self;
    __weak __typeof(HMCommonArrowItem)*item = textItem;
    
    textItem0.operation = ^{
        DataCitiesViewController *VC = [[DataCitiesViewController alloc] init];
        VC.selectedHandler = ^(CityModel *VO, NSString *str)
        {
            selectedCityStr = str;
            selectedCity = VO;
            selectedStreet = nil;
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
    //    __weak __typeof(CityModel)*cityVO = selectedCity;
    textItem.operation = ^{
        if (!selectedCity)
            return [NoticeHelper AlertShow:@"请选择城市" view:weakSelf.view];
        StreetViewController *VC = [[StreetViewController alloc] init];
        VC.dvcode_id = selectedCity.dvcode;
        VC.selectedHandler = ^(CityModel *VO, NSString *str)
        {
            selectedStreetStr = str;
            selectedStreet = VO;
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
    textItem1.placeholder = [self.dict valueForKey:@"placeholder"];
    group1.items = @[textItem1];
    dispatch_async(dispatch_get_main_queue(), ^{
        textItem1.rightText.text = self.inforVO.member_areainfo;
    });
    
    
    //刷新表格
    [self.tableView reloadData];
}

/**
 *  确认修改
 */
-(void)doneClickHandler
{
    NSString * str = textItem1.rightText.text;
    
    if (!selectedStreet || !str)
        return [NoticeHelper AlertShow:@"请填写详细信息" view:self.view];
    
    [self.view endEditing:YES];
    
    NSString *addressStr = [self.title isEqualToString:@"修改地址"] ? str : self.inforVO.member_areainfo;
    NSString *nameStr = [self.title isEqualToString:@"修改姓名"] ? textItem.rightText.text : self.inforVO.member_truename;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"ios" forKey:@"client"];
    if (self.inforVO.member_sex != nil)
        [dict setObject:self.inforVO.member_sex forKey:@"member_sex"];
    if (nameStr)
        [dict setObject:nameStr forKey:@"member_truename"];
    if (self.inforVO.member_birthday != nil)
        [dict setObject:self.inforVO.member_birthday forKey:@"member_birthday"];
    if (addressStr)
        [dict setObject:addressStr forKey:@"member_areainfo"];
    if (selectedStreet)
        [dict setObject:selectedStreet.dvcode forKey:@"member_areaid"];
    if ([SharedAppUtil defaultCommonUtil].userVO.key != nil)
        [dict setObject:[SharedAppUtil defaultCommonUtil].userVO.key forKey:@"key"];
    
    if (self.changeDataBlock)
    {
        [self.navigationController popViewControllerAnimated:YES];
        return self.changeDataBlock(dict,[NSString stringWithFormat:@"%@%@",selectedCityStr,selectedStreetStr]);
    }
    
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


-(void)show
{
    // 加载plist文件，初始化三个NSArray对象
    provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
    cities = [[provinces objectAtIndex:0] objectForKey:@"cities"];
    state = [[provinces objectAtIndex:0] objectForKey:@"state"];
    
    areaPicker = [[UIPickerView alloc] init];
    areaPicker.dataSource = self;
    areaPicker.delegate = self;
    
    UIAlertController* alertVc=[UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n"
                                                                   message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction* ok=[UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        textItem0.rightText.text = selectedAddress;
        [self.tableView reloadData];
    }];
    UIAlertAction* no=[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
    [alertVc.view addSubview:areaPicker];
    [alertVc addAction:ok];
    [alertVc addAction:no];
    [self presentViewController:alertVc animated:YES completion:nil];
    
    
    //    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
    //                                                             delegate:self
    //                                                    cancelButtonTitle:@"取消"
    //                                               destructiveButtonTitle:nil
    //                                                    otherButtonTitles:@"确定",nil];
    //    actionSheet.userInteractionEnabled = YES;
    //    actionSheet.backgroundColor = [UIColor clearColor];
    
    //    [actionSheet addSubview:areaPicker];
    //    [actionSheet showInView:self.view];
}

#pragma mark - HZAreaPicker delegate
// UIPickerViewDataSource中定义的方法，该方法的返回值决定改控件包含多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

// UIPickerViewDataSource中定义的方法，该方n法的返回值决定该控件指定列包含多少哥列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // 如果是第一列，返回provinces的个数
    // 也就是provinces包含多少个元素，大天朝有多少个省份里面就有多少个
    if (component == 0) {
        return provinces.count;
    } else if(component == 1){
        // 如果是第二列，返回cities的个数
        return cities.count;
    } else {
        return areas.count;
    }
}
// UIPickerViewDelegate中定义的方法，该方法返回NSString将作为UIPickerView中指定列和列表项上显示的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // 如果是第一列，返回provinces中row索引出得元素
    switch (component)
    {
        case 0:
            return [[provinces objectAtIndex:row] objectForKey:@"state"];
            break;
        case 1:
            return [[cities objectAtIndex:row] objectForKey:@"city"];
            break;
        case 2:
            return [areas objectAtIndex:row];
            break;
        default:
            return @"";
            break;
    }
}

// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            cities = [[provinces objectAtIndex:row] objectForKey:@"cities"];
            [areaPicker selectRow:0 inComponent:1 animated:YES];
            [areaPicker reloadComponent:1];
            
            areas = [[cities objectAtIndex:0] objectForKey:@"areas"];
            [areaPicker selectRow:0 inComponent:2 animated:YES];
            [areaPicker reloadComponent:2];
            
            state = [[provinces objectAtIndex:row] objectForKey:@"state"];
            city = [[cities objectAtIndex:0] objectForKey:@"city"];
            if ([areas count] > 0) {
                district = [areas objectAtIndex:0];
            } else{
                district = @"";
            }
            break;
        case 1:
            areas = [[cities objectAtIndex:row] objectForKey:@"areas"];
            [areaPicker selectRow:0 inComponent:2 animated:YES];
            [areaPicker reloadComponent:2];
            
            city = [[cities objectAtIndex:row] objectForKey:@"city"];
            if ([areas count] > 0) {
                district = [areas objectAtIndex:0];
            } else{
                district = @"";
            }
            break;
        case 2:
            if ([areas count] > 0) {
                district = [areas objectAtIndex:row];
            } else{
                district = @"";
            }
            break;
    }
    selectedAddress = [NSString stringWithFormat:@"%@%@%@",state,city,district];
}

@end
