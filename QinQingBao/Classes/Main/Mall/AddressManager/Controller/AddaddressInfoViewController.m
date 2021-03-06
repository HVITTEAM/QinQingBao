//
//  AddaddressInfoViewController.m
//  QinQingBao
//
//  Created by Dual on 16/1/9.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "AddaddressInfoViewController.h"
#import "AreaModelTotal.h"
#import "AreaModel.h"

@interface AddaddressInfoViewController ()<UIActionSheetDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray *areaList;
    
    UIPickerView* pickView;
    
    AreaModel *selectedProvinceItem;
    AreaModel *selectedCityItem;
    AreaModel *selectedRegionItem;
    
    NSInteger PickType;
}

//省 数组
@property (strong, nonatomic) NSArray *provinceArr;
//城市 数组e
@property (strong, nonatomic) NSArray *cityArr;
//区县 数组
@property (strong, nonatomic) NSArray *areaArr;
@end

@implementation AddaddressInfoViewController

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
    switch (component) {
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

- (IBAction)clickProvince:(id)sender
{
    [self showDatePicker];
    PickType = 0;
}

- (IBAction)clickCity:(id)sender
{
    if ([_provinceTextField.text isEqualToString:@""])
    {
        [NoticeHelper AlertShow:@"请填写省份信息" view:self.view];
    }else
    {
        PickType = 1;
        [self getProviceData:selectedProvinceItem.area_id];
    }
}
- (IBAction)clickRegion:(id)sender {
    if ([_cityTextField.text isEqualToString:@""]) {
        [NoticeHelper AlertShow:@"请填写城市信息" view:self.view];
    }else
    {
        PickType = 2;
        [self getProviceData:selectedCityItem.area_id];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavgation];
    
    [self initDatePickView];
    
    [self initView];
}

-(void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.telephoneTextField.placeholder = @"选填";
    if (self.item)
    {
        NSArray *arr = [self.item.area_info componentsSeparatedByString:@"-"];
        
        self.provinceTextField.text  = self.item.area_info;
        self.nameTextField.text = self.item.true_name;
        self.phoneTextField.text = self.item.mob_phone;
        self.telephoneTextField.text = self.item.tel_phone;
        self.addressTextField.text = self.item.address;
        
        selectedProvinceItem = [[AreaModel alloc] initWithName:@"浙江" areaid:@"11" dvcode:@"330000"];
        selectedCityItem  = [[AreaModel alloc] initWithName:arr[1] areaid:self.item.city_id dvcode:self.item.dvcode];
        selectedRegionItem  = [[AreaModel alloc] initWithName:arr[2] areaid:self.item.area_id dvcode:self.item.dvcode];
    }
}

-(void)initNavgation
{
    UIBarButtonItem *manager = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(clickHander)];
    self.navigationItem.rightBarButtonItem = manager;
}

-(void)clickHander
{
    if ([_nameTextField.text isEqualToString:@""])
        return [NoticeHelper AlertShow:@"请填收货人姓名" view:self.view];
    if ([_phoneTextField.text isEqualToString:@""]) {
        return [NoticeHelper AlertShow:@"请填写手机号码" view:self.view];
    }else if (_phoneTextField.text.length != 11) {
        return [NoticeHelper AlertShow:@"手机号码格式不正确" view:self.view];
    }if ([_provinceTextField.text isEqualToString:@""])
        return [NoticeHelper AlertShow:@"请填写区域信息" view:self.view];
    if ([_addressTextField.text isEqualToString:@""])
        return [NoticeHelper AlertShow:@"请填写详细地址信息" view:self.view];
    [self.view endEditing:YES];
    if ([self.title isEqualToString:@"更改收货地址"])
    {
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [CommonRemoteHelper RemoteWithUrl:URL_Address_edit parameters: @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                         @"client" : @"ios",
                                                                         @"address_id" : self.item.address_id,
                                                                         @"true_name" : _nameTextField.text,
                                                                         @"area_info" : self.provinceTextField.text,
                                                                         @"address" : _addressTextField.text,
                                                                         @"tel_phone" : _telephoneTextField.text,
                                                                         @"mob_phone" : _phoneTextField.text,
                                                                         @"city_id" : self.item.city_id,
                                                                         @"area_id" : self.item.area_id}
                                     type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                         
                                         [HUD removeFromSuperview];
                                         id codeNum = [dict objectForKey:@"code"];
                                         if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                         {
                                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                             [alertView show];
                                         }
                                         else
                                         {
                                             [self.navigationController popViewControllerAnimated:YES];
                                         }
                                     }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"出错了....");
                                      [HUD removeFromSuperview];
                                  }];
        
    }
    else
    {
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [CommonRemoteHelper RemoteWithUrl:URL_Address_Add parameters: @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                        @"client" : @"ios",
                                                                        @"true_name" : _nameTextField.text,
                                                                        @"area_info" : self.provinceTextField.text,
                                                                        @"address" : _addressTextField.text,
                                                                        @"tel_phone" : _telephoneTextField.text,
                                                                        @"mob_phone" : _phoneTextField.text,
                                                                        @"city_id" : selectedCityItem.dvcode,
                                                                        @"area_id" : selectedRegionItem.dvcode}
                                     type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                         
                                         [HUD removeFromSuperview];
                                         id codeNum = [dict objectForKey:@"code"];
                                         if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                         {
                                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                             [alertView show];
                                         }
                                         else
                                         {
                                             [self.navigationController popViewControllerAnimated:YES];
                                         }
                                     }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"出错了....");
                                      [HUD removeFromSuperview];
                                  }];
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
    
//     self.provinceArr = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"china.plist" ofType:nil]];
//    self.cityArr = self.provinceArr[0][@"cities"];
//    self.areaArr = self.cityArr[0][@"regions"];

    
    self.provinceArr = @[@"浙江省"];
    self.cityArr = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"areaList.plist" ofType:nil]];
    self.areaArr = self.cityArr[0][@"regions"];
    selectedProvinceItem = [[AreaModel alloc] initWithName:@"浙江" areaid:@"11" dvcode:@"330000"];
    selectedCityItem = [[AreaModel alloc] initWithName:[[self.cityArr objectAtIndex:0] objectForKey:@"name"] areaid:[[self.cityArr objectAtIndex:0] objectForKey:@"areaid"] dvcode:[[self.cityArr objectAtIndex:0] objectForKey:@"dvcode"]];
    selectedRegionItem = [[AreaModel alloc] initWithName:[[self.areaArr objectAtIndex:0] objectForKey:@"name"] areaid:[[self.areaArr objectAtIndex:0] objectForKey:@"areaid"] dvcode:[[self.areaArr objectAtIndex:0] objectForKey:@"dvcode"]];
}

//获取城市级联信息
-(void)getProviceData:(NSString *)code
{
    [CommonRemoteHelper RemoteWithUrl:URL_Area_list parameters: @{@"area_id" : code,
                                                                  @"key" : [SharedAppUtil defaultCommonUtil].userVO.key}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         AreaModelTotal *result = [AreaModelTotal objectWithKeyValues:[dict objectForKey:@"datas"]];
                                         areaList = result.area_list;
                                         [self showDatePicker];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"出错了....");
                                 }];
}

-(void)showDatePicker
{
    [self setDatePickerIos8];
}


#pragma mark --- DatePicker

-(void)setDatePickerIos8
{
    UIAlertController* alertVc=[UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n"
                                                                   message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction* ok=[UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        self.provinceTextField.text  = [NSString stringWithFormat:@"%@-%@-%@",selectedProvinceItem.area_name,selectedCityItem.area_name,selectedRegionItem.area_name];
    }];
    UIAlertAction* no=[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
    [alertVc.view addSubview:pickView];
    [alertVc addAction:ok];
    [alertVc addAction:no];
    [self presentViewController:alertVc animated:YES completion:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        
    }
}

-(void)setItem:(MallAddressModel *)item
{
    _item = item;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.phoneTextField == textField)
        return [self validateNumber:string withString:@"0123456789"];
    if (self.telephoneTextField == textField)
        return [self validateNumber:string withString:@"-0123456789"];
    return YES;
}

//限制TextField输入
- (BOOL)validateNumber:(NSString*)number withString:(NSString *)str {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:str];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

@end
