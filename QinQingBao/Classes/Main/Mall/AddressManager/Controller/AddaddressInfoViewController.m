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

@interface AddaddressInfoViewController ()<UIActionSheetDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
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
//城市 数组
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
    
    //    switch (PickType)
    //    {
    //        case 0:
    //            selectedProvinceItem  = areaList[0];
    //            break;
    //        case  1:
    //            selectedCityItem  = areaList[0];
    //            break;
    //        case  2:
    //            selectedRegionItem  = areaList[0];
    //            break;
    //        default:
    //            break;
    //    }
    //
    //    AreaModel *item = areaList[row];
    //    return item.area_name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
        {
            selectedProvinceItem = [[AreaModel alloc] initWithName:@"浙江" areaid:@"11"];
            
            selectedCityItem = [[AreaModel alloc] initWithName:[[self.cityArr objectAtIndex:0] objectForKey:@"name"] areaid:[[self.cityArr objectAtIndex:0] objectForKey:@"areaid"] ];
            selectedRegionItem = [[AreaModel alloc] initWithName:[[self.areaArr objectAtIndex:0] objectForKey:@"name"] areaid:[[self.areaArr objectAtIndex:0] objectForKey:@"areaid"]];
            break;
        }
        case 1:
        {
            self.areaArr = [[self.cityArr objectAtIndex:row] objectForKey:@"regions"];
            [pickView reloadComponent:2];
            [pickView selectRow:0 inComponent:2 animated:YES];
            selectedCityItem = [[AreaModel alloc] initWithName:[[self.cityArr objectAtIndex:row] objectForKey:@"name"] areaid:[[self.cityArr objectAtIndex:row] objectForKey:@"areaid"] ];
            self.areaArr = self.cityArr[row][@"regions"];
            selectedRegionItem = [[AreaModel alloc] initWithName:[[self.areaArr objectAtIndex:0] objectForKey:@"name"] areaid:[[self.areaArr objectAtIndex:0] objectForKey:@"areaid"]];
            break;
        }
        case 2:
        {
            selectedRegionItem = [[AreaModel alloc] initWithName:[[self.areaArr objectAtIndex:row] objectForKey:@"name"] areaid:[[self.areaArr objectAtIndex:row] objectForKey:@"areaid"]];
            break;
        }
        default:
            break;
    }
    
    //    switch (PickType) {
    //        case 0:
    //            selectedProvinceItem  = areaList[row];
    //            break;
    //        case  1:
    //            selectedCityItem  = areaList[row];
    //            break;
    //        case  2:
    //            selectedRegionItem  = areaList[row];
    //            break;
    //        default:
    //            break;
    //    }
}

- (IBAction)clickProvince:(id)sender
{
    //    [self getProviceData:@"0"];
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
    self.view.backgroundColor = HMGlobalBg;
    self.telephoneTextField.placeholder = @"选填";
    if (self.item)
    {
        NSArray *arr = [self.item.area_info componentsSeparatedByString:@"-"];
        //        self.provinceTextField.text  = arr[0];
        //        self.cityTextField.text  = arr[1];
        //        self.regionTextField.text  = arr[2];
        //        self.nameTextField.text = self.item.true_name;
        //        self.phoneTextField.text = self.item.mob_phone;
        //        self.telephoneTextField.text = self.item.tel_phone;
        //        self.addressTextField.text = self.item.address;
        
        self.provinceTextField.text  = self.item.area_info;
        
        selectedProvinceItem = [[AreaModel alloc] initWithName:@"浙江" areaid:@"11"];
        selectedCityItem  = [[AreaModel alloc] initWithName:arr[1] areaid:self.item.city_id];
        selectedRegionItem  = [[AreaModel alloc] initWithName:arr[2] areaid:self.item.area_id];
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
    }
    //    if ([_telephoneTextField.text isEqualToString:@""]) {
    //        return [NoticeHelper AlertShow:@"请填写电话号码" view:self.view];
    //    }
    if ([_provinceTextField.text isEqualToString:@""])
        return [NoticeHelper AlertShow:@"请填写区域信息" view:self.view];
    //    if ([_cityTextField.text isEqualToString:@""])
    //        return [NoticeHelper AlertShow:@"请填写城市信息" view:self.view];
    //    if ([_regionTextField.text isEqualToString:@""])
    //        return [NoticeHelper AlertShow:@"请填写区县信息" view:self.view];
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
                                                                        @"city_id" : selectedCityItem.area_id,
                                                                        @"area_id" : selectedRegionItem.area_id}
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
    
    self.provinceArr = @[@"浙江省"];
    self.cityArr = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"areaList.plist" ofType:nil]];
    self.areaArr = self.cityArr[0][@"regions"];
    selectedProvinceItem = [[AreaModel alloc] initWithName:@"浙江" areaid:@"11"];
    selectedCityItem = [[AreaModel alloc] initWithName:[[self.cityArr objectAtIndex:0] objectForKey:@"name"] areaid:[[self.cityArr objectAtIndex:0] objectForKey:@"areaid"] ];
    selectedRegionItem = [[AreaModel alloc] initWithName:[[self.areaArr objectAtIndex:0] objectForKey:@"name"] areaid:[[self.areaArr objectAtIndex:0] objectForKey:@"areaid"]];
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    //上移30个单位，按实际情况设置
    
    if (CGRectGetMaxY(textField.frame) > MTScreenH - 216)
    {
        CGRect rect = CGRectMake(0.0f,MTScreenH - 216 - CGRectGetMaxY(textField.frame),MTScreenW,MTScreenH);
        self.view.frame = rect;
        [UIView commitAnimations];
    }
    
    if (textField == self.regionTextField || textField == self.provinceTextField || textField == self.cityTextField)
        return NO;
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.25f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    //上移30个单位，按实际情况设置
    CGRect rect = CGRectMake(0.0f,0,MTScreenW,MTScreenH);
    self.view.frame = rect;
    [UIView commitAnimations];
}

//要实现的Delegate方法,键盘next下跳
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.returnKeyType == UIReturnKeyDone)
    {
        [self.view endEditing:YES];
    }
    if(textField.returnKeyType==UIReturnKeyNext)
    {
        
    }
    return YES;
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
