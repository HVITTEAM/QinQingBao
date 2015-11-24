//
//  UpdateAddressController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/11/20.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "UpdateAddressController.h"
#import "HMCommonTextfieldItem.h"

@interface UpdateAddressController ()<UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate>
{
    HMCommonTextfieldItem *textItem0;
    HMCommonTextfieldItem *textItem;
    
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
    
    [self.groups removeAllObjects];
    
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
    self.title = [self.dict valueForKey:@"title"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneClickHandler)];
}

# pragma  mark 设置数据源
/**
 *  初始化模型数据
 */
- (void)setupGroups
{
    [self setupGroup];
}

- (void)setupGroup
{
    // 1.创建组
    HMCommonGroup *group0 = [HMCommonGroup group];
    [self.groups addObject:group0];
    
    // 1.设置组的所有行数据
    textItem0= [HMCommonTextfieldItem itemWithTitle:@"地区" icon:nil];
    textItem0.placeholder = @"请选择地区";
    __weak __typeof(self)weakSelf = self;
    
    textItem0.operation = ^{
        [weakSelf show];
    };
    group0.items = @[textItem0];
    
    // 2.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    textItem = [HMCommonTextfieldItem itemWithTitle:@"详细地址" icon:nil];
    textItem.placeholder = [self.dict valueForKey:@"placeholder"];
    group.items = @[textItem];
    
}

-(void)doneClickHandler
{
    NSString * str = [NSString stringWithFormat:@"%@%@",selectedAddress,textItem.rightText.text];
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
    if ([SharedAppUtil defaultCommonUtil].userVO.key != nil)
        [dict setObject:[SharedAppUtil defaultCommonUtil].userVO.key forKey:@"key"];
    
    
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
    
    // 加载plist文件，初始化三个NSArray对象，然后做一些非法的事情，你懂的
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