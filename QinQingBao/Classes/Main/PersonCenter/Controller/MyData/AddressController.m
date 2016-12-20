//
//  AddressController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/7/15.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "AddressController.h"
#import "HMCommonTextfieldItem.h"

@interface AddressController ()<UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate>
{
    HMCommonArrowItem *textItem0;
    HMCommonTextfieldItem *textItem1;
    
    NSString *selectedCityStr;
    NSString *areaInfoStr;
    
    UIPickerView* pickView;
    
    AreaModel *selectedProvinceItem;
    AreaModel *selectedCityItem;
    AreaModel *selectedRegionItem;
    
    NSInteger selectedProvinceIndex;
    NSInteger selectedCityIndex;
    NSInteger selectedRegionIndex;
    
}

//省 数组
@property (strong, nonatomic) NSArray *provinceArr;
//城市 数组
@property (strong, nonatomic) NSArray *cityArr;
//区县 数组
@property (strong, nonatomic) NSArray *areaArr;
@end

@implementation AddressController

-(NSArray *)provinceArr
{
    if (!_provinceArr) {
        _provinceArr = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"china.plist" ofType:nil]];
        self.cityArr = self.provinceArr[0][@"cities"];
        self.areaArr = self.cityArr[0][@"regions"];
    }
    return _provinceArr;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
    
    [self initDataPickView];
    
    [self initNavigation];
    
    self.view.backgroundColor = HMGlobalBg;
}

-(void)setItemInfoWith:(NSString *)cityStr regionStr:(NSString *)regionStr regionCode:(NSString*)regionCode areaInfo:(NSString*)areaInfo
{
    selectedCityStr = cityStr;
    areaInfoStr = areaInfo;
    selectedRegionItem = [[AreaModel alloc] initWithName:regionStr areaid:@"" dvcode:regionCode];
    
    if (selectedRegionItem) {
        // 遍历查找选中的城市区划 并选中
        for (NSDictionary *provinceItem in self.provinceArr)
        {
            NSArray *carr  = [provinceItem valueForKey:@"cities"];
            for (NSDictionary *cityItem in carr)
            {
                NSArray *aarr = [cityItem valueForKey:@"regions"];
                for (NSDictionary *regionItem in aarr)
                {
                    if ([[regionItem valueForKey:@"dvcode"] isEqualToString:selectedRegionItem.dvcode])
                    {
                        self.cityArr = carr;
                        self.areaArr = aarr;
                        selectedProvinceIndex = [self.provinceArr indexOfObject:provinceItem];
                        selectedCityIndex = [self.cityArr indexOfObject:cityItem];
                        selectedRegionIndex = [self.areaArr indexOfObject:regionItem];
                        
                        selectedProvinceItem = [[AreaModel alloc] initWithName:[provinceItem objectForKey:@"name"] areaid:@"" dvcode:[provinceItem objectForKey:@"dvcode"]];
                        selectedCityItem = [[AreaModel alloc] initWithName:[cityItem objectForKey:@"name"] areaid:@"" dvcode:[cityItem objectForKey:@"dvcode"]];
                        selectedRegionItem = [[AreaModel alloc] initWithName:[regionItem objectForKey:@"name"] areaid:@"" dvcode:[regionItem objectForKey:@"dvcode"]];
                        break;
                    }
                }
            }
        }
    }
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
 *  导航栏设置
 */
-(void)initNavigation
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneClickHandler)];
}

/**
 *   创建、并初始化2个NSArray对象，分别作为2列的数据
 */
-(void)initDataPickView
{
    pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 10, MTScreenW - 30, 200)];
    pickView.dataSource = self;
    pickView.delegate = self;
    
    if (selectedRegionItem)
        return;
    selectedProvinceItem = [[AreaModel alloc] initWithName:[[self.provinceArr objectAtIndex:0] objectForKey:@"name"] areaid:@"" dvcode:[[self.provinceArr objectAtIndex:0] objectForKey:@"dvcode"]];
    selectedCityItem = [[AreaModel alloc] initWithName:[[self.cityArr objectAtIndex:0] objectForKey:@"name"] areaid:@"" dvcode:[[self.cityArr objectAtIndex:0] objectForKey:@"dvcode"]];
    selectedRegionItem = [[AreaModel alloc] initWithName:[[self.areaArr objectAtIndex:0] objectForKey:@"name"] areaid:@"" dvcode:[[self.areaArr objectAtIndex:0] objectForKey:@"dvcode"]];
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
    HMCommonGroup *group0 = [HMCommonGroup group];
    [self.groups addObject:group0];
    
    __weak __typeof(self)weakSelf = self;
    
    textItem0 = [HMCommonArrowItem itemWithTitle:@"所在区域" icon:nil];
    textItem0.subtitle = selectedCityStr;
    textItem0.operation = ^{
        [weakSelf showDataPicker];
    };
    group0.items = @[textItem0];
    
    HMCommonGroup *group1 = [HMCommonGroup group];
    [self.groups addObject:group1];
    textItem1 = [HMCommonTextfieldItem itemWithTitle:@"详细地址" icon:nil];
    textItem1.placeholder = @"请输入详细地址";
    textItem1.textValue = areaInfoStr;
    group1.items = @[textItem1];
    
    [self.tableView reloadData];
}

#pragma mark --- DatePicker

-(void)showDataPicker
{
    UIAlertController* alertVc=[UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n"
                                                                   message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction* ok=[UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        selectedCityStr  = [NSString stringWithFormat:@"%@%@%@",selectedProvinceItem.area_name,selectedCityItem.area_name ? selectedCityItem.area_name:@"",selectedRegionItem.area_name?selectedRegionItem.area_name:@""];
        [self setupGroups];
    }];
    
    [pickView selectRow:selectedProvinceIndex inComponent:0 animated:YES];
    [pickView selectRow:selectedCityIndex inComponent:1 animated:YES];
    [pickView selectRow:selectedRegionIndex inComponent:2 animated:YES];
    
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
    if (textItem1.rightText.text.length == 0) {
        return [NoticeHelper AlertShow:@"请填写详细地址" view:self.view];
    }
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
            return [[self.provinceArr objectAtIndex:row] objectForKey:@"name"];
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
            selectedProvinceItem = [[AreaModel alloc] initWithName:[[self.provinceArr objectAtIndex:row] objectForKey:@"name"] areaid:@"" dvcode:[[self.cityArr objectAtIndex:0] objectForKey:@"dvcode"]];
            
            self.cityArr = self.provinceArr[row][@"cities"];
            selectedCityItem = [[AreaModel alloc] initWithName:[[self.cityArr objectAtIndex:0] objectForKey:@"name"] areaid:@"" dvcode:[[self.cityArr objectAtIndex:0] objectForKey:@"dvcode"]];
            
            self.areaArr = self.cityArr[0][@"regions"];
            selectedRegionItem = [[AreaModel alloc] initWithName:[[self.areaArr objectAtIndex:0] objectForKey:@"name"] areaid:@"" dvcode:[[self.areaArr objectAtIndex:0] objectForKey:@"dvcode"]];
            
            [pickView reloadComponent:1];
            [pickView reloadComponent:2];
            
            [pickView selectRow:0 inComponent:1 animated:YES];
            [pickView selectRow:0 inComponent:2 animated:YES];
            
            break;
        }
        case 1:
        {
            self.areaArr = [[self.cityArr objectAtIndex:row] objectForKey:@"regions"];
            [pickView reloadComponent:2];
            [pickView selectRow:0 inComponent:2 animated:YES];
            selectedCityItem = [[AreaModel alloc] initWithName:[[self.cityArr objectAtIndex:row] objectForKey:@"name"] areaid:@"" dvcode:[[self.cityArr objectAtIndex:0] objectForKey:@"dvcode"]];
            self.areaArr = self.cityArr[row][@"regions"];
            selectedRegionItem = [[AreaModel alloc] initWithName:[[self.areaArr objectAtIndex:0] objectForKey:@"name"] areaid:@"" dvcode:[[self.areaArr objectAtIndex:0] objectForKey:@"dvcode"]];
            break;
        }
        case 2:
        {
            selectedRegionItem = [[AreaModel alloc] initWithName:[[self.areaArr objectAtIndex:row] objectForKey:@"name"] areaid:@"" dvcode:[[self.areaArr objectAtIndex:row] objectForKey:@"dvcode"]];
            break;
        }
        default:
            break;
    }
}

@end
