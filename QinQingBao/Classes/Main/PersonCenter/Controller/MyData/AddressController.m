//
//  AddressController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/7/15.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "AddressController.h"
#import "HMCommonTextfieldItem.h"

#import "AreaModelTotal.h"

#import "CitiesTotal.h"

@interface AddressController ()<UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate>
{
    HMCommonArrowItem *textItem0;
    HMCommonArrowItem *textItem;
    HMCommonTextfieldItem *textItem1;
    
    NSString *selectedCityStr;
    NSString *areaInfoStr;
    
    NSMutableArray *areaList;
    
    NSMutableArray *regionList;
    
    UIPickerView* pickView;
    
    
    AreaModel *selectedProvinceItem;
    AreaModel *selectedCityItem;
    AreaModel *selectedRegionItem;
}

//省 数组
@property (strong, nonatomic) NSArray *provinceArr;
//城市 数组
@property (strong, nonatomic) NSArray *cityArr;
//区县 数组
@property (strong, nonatomic) NSArray *areaArr;
@end

@implementation AddressController

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
    
    [self initDatePickView];
    
    self.view.backgroundColor = HMGlobalBg;
}

-(void)setItemInfoWith:(NSString *)cityStr regionStr:(NSString *)regionStr regionCode:(NSString*)regionCode areaInfo:(NSString*)areaInfo
{
    selectedCityStr = cityStr;
    areaInfoStr = areaInfo;
    
//    selectedStreetStr = regionStr;
    selectedRegionItem = [[AreaModel alloc] initWithName:regionStr areaid:regionCode dvcode:regionCode];
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneClickHandler)];
    
    //适配ios7.0的导航栏
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0 && !self.changeDataBlock)
    {
        self.navigationController.navigationBar.translucent = NO;
    }
}


/**
 *   创建、并初始化2个NSArray对象，分别作为2列的数据
 */
-(void)initDatePickView
{
    pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 10, MTScreenW - 30, 200)];
    pickView.dataSource = self;
    pickView.delegate = self;
    
    self.provinceArr = @[@"浙江省"];
    self.cityArr = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"areaList.plist" ofType:nil]];
    self.areaArr = self.cityArr[0][@"regions"];
    selectedProvinceItem = [[AreaModel alloc] initWithName:@"浙江" areaid:@"11" dvcode:@"330000"];
    selectedCityItem = [[AreaModel alloc] initWithName:[[self.cityArr objectAtIndex:0] objectForKey:@"name"] areaid:[[self.cityArr objectAtIndex:0] objectForKey:@"areaid"] dvcode:[[self.cityArr objectAtIndex:0] objectForKey:@"dvcode"]];
    selectedRegionItem = [[AreaModel alloc] initWithName:[[self.areaArr objectAtIndex:0] objectForKey:@"name"] areaid:[[self.areaArr objectAtIndex:0] objectForKey:@"areaid"] dvcode:[[self.cityArr objectAtIndex:0] objectForKey:@"dvcode"]];
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
    textItem0 = [HMCommonArrowItem itemWithTitle:@"所在区域" icon:nil];
    textItem0.subtitle = selectedCityStr;
    __weak __typeof(self)weakSelf = self;
    
    textItem0.operation = ^{
        [weakSelf setDatePickerCity];
    };
    group0.items = @[textItem0];
    
    // 3.创建组
    HMCommonGroup *group1 = [HMCommonGroup group];
    [self.groups addObject:group1];
    // 3.设置组的所有行数据
    textItem1 = [HMCommonTextfieldItem itemWithTitle:@"详细地址" icon:nil];
    textItem1.placeholder = @"请输入详细地址";
    textItem1.textValue = areaInfoStr;
    group1.items = @[textItem1];
    
    //刷新表格
    [self.tableView reloadData];
}

#pragma mark --- DatePicker

-(void)setDatePickerCity
{
    UIAlertController* alertVc=[UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n"
                                                                   message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction* ok=[UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
            selectedCityStr  = [NSString stringWithFormat:@"%@%@%@",selectedProvinceItem.area_name,selectedCityItem.area_name,selectedRegionItem.area_name];
            [self setupGroups];
    }];
    
    UIAlertAction* no=[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
    [alertVc.view addSubview:pickView];
    [alertVc addAction:ok];
    [alertVc addAction:no];
    [self presentViewController:alertVc animated:YES completion:nil];
}

/**
 *  确认修改
 */
-(void)doneClickHandler
{
    selectedCityStr  = [NSString stringWithFormat:@"%@%@%@",selectedProvinceItem.area_name,selectedCityItem.area_name,selectedRegionItem.area_name];
    if (self.changeDataBlock)
        self.changeDataBlock(selectedRegionItem,selectedCityStr,textItem1.rightText.text);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
            return self.provinceArr.count;
            break;
        case 1:
            return self.cityArr.count;
            break;
        case 2:
            return self.areaArr.count;
            break;
        default:
            return 0;
            break;
    }
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
        switch (component)
    {
        case 0:
            return [self.provinceArr objectAtIndex:row];
            break;
        case 1:
            return [[self.cityArr objectAtIndex:row] objectForKey:@"name"];
            break;
        case 2:
            return [[self.areaArr objectAtIndex:row] objectForKey:@"name"];
            break;
        default:
            return  @"";
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
       switch (component)
    {
        case 0:
        {
            selectedProvinceItem = [[AreaModel alloc] initWithName:@"浙江" areaid:@"11" dvcode:@"330000"];
            
            selectedCityItem = [[AreaModel alloc] initWithName:[[self.cityArr objectAtIndex:0] objectForKey:@"name"] areaid:[[self.cityArr objectAtIndex:0] objectForKey:@"areaid"] dvcode:[[self.cityArr objectAtIndex:0] objectForKey:@"dvcode"]];
            selectedRegionItem = [[AreaModel alloc] initWithName:[[self.areaArr objectAtIndex:0] objectForKey:@"name"] areaid:[[self.areaArr objectAtIndex:0] objectForKey:@"areaid"] dvcode:[[self.areaArr objectAtIndex:0] objectForKey:@"dvcode"]];
            break;
        }
        case 1:
        {
            self.areaArr = [[self.cityArr objectAtIndex:row] objectForKey:@"regions"];
            [pickView reloadComponent:2];
            [pickView selectRow:0 inComponent:2 animated:YES];
            selectedCityItem = [[AreaModel alloc] initWithName:[[self.cityArr objectAtIndex:row] objectForKey:@"name"] areaid:[[self.cityArr objectAtIndex:row] objectForKey:@"areaid"] dvcode:[[self.cityArr objectAtIndex:0] objectForKey:@"dvcode"]];
            self.areaArr = self.cityArr[row][@"regions"];
            selectedRegionItem = [[AreaModel alloc] initWithName:[[self.areaArr objectAtIndex:0] objectForKey:@"name"] areaid:[[self.areaArr objectAtIndex:0] objectForKey:@"areaid"] dvcode:[[self.areaArr objectAtIndex:0] objectForKey:@"dvcode"]];
            break;
        }
        case 2:
        {
            selectedRegionItem = [[AreaModel alloc] initWithName:[[self.areaArr objectAtIndex:row] objectForKey:@"name"] areaid:[[self.areaArr objectAtIndex:row] objectForKey:@"areaid"] dvcode:[[self.areaArr objectAtIndex:0] objectForKey:@"dvcode"]];
            break;
        }
        default:
            break;
    }
}

@end
