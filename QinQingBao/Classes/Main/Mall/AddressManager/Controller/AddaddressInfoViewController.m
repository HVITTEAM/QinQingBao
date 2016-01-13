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
@end

@implementation AddaddressInfoViewController

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [areaList count];
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    AreaModel *item = areaList[row];
    return item.area_name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (PickType) {
        case 0:
            selectedProvinceItem  = areaList[row];
            break;
        case  1:
            selectedCityItem  = areaList[row];
            break;
        case  2:
            selectedRegionItem  = areaList[row];
            break;
        default:
            break;
    }
    
}


- (IBAction)clickProvince:(id)sender
{
    [self getProviceData:@"0"];
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
        self.provinceTextField.text  = arr[0];
        self.cityTextField.text  = arr[1];
        self.regionTextField.text  = arr[2];
        self.nameTextField.text = self.item.true_name;
        self.phoneTextField.text = self.item.mob_phone;
        self.telephoneTextField.text = self.item.tel_phone;
        self.addressTextField.text = self.item.address;
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
        return [NoticeHelper AlertShow:@"请填写省份信息" view:self.view];
    if ([_cityTextField.text isEqualToString:@""])
        return [NoticeHelper AlertShow:@"请填写城市信息" view:self.view];
    if ([_regionTextField.text isEqualToString:@""])
        return [NoticeHelper AlertShow:@"请填写区县信息" view:self.view];
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
                                                                         @"area_info" : [NSString stringWithFormat:@"%@-%@-%@",self.provinceTextField.text,self.cityTextField.text,self.regionTextField.text],
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
                                                                        @"area_info" : [NSString stringWithFormat:@"%@-%@-%@",selectedProvinceItem.area_name,selectedCityItem.area_name,selectedRegionItem.area_name],
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
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self setDatePickerIos8];
    else
        [self setDatePickerIos7];
}


#pragma mark --- DatePicker

-(void)setDatePickerIos8
{
    UIAlertController* alertVc=[UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n"
                                                                   message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction* ok=[UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        switch (PickType) {
            case 0:
                self.provinceTextField.text  = selectedProvinceItem.area_name;
                break;
            case  1:
                self.cityTextField.text  =selectedCityItem.area_name;
                break;
            case  2:
                self.regionTextField.text  = selectedRegionItem.area_name;
                break;
            default:
                break;
        }
    }];
    UIAlertAction* no=[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
    [alertVc.view addSubview:pickView];
    [alertVc addAction:ok];
    [alertVc addAction:no];
    [self presentViewController:alertVc animated:YES completion:nil];
}

-(void)setDatePickerIos7
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle: @"\n\n\n\n\n\n\n\n\n\n\n"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"确认"
                                  otherButtonTitles:nil];
    
    [actionSheet addSubview:pickView];
    [actionSheet showInView:self.view];
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
    if (textField == self.regionTextField || textField == self.provinceTextField || textField == self.cityTextField)
        return NO;
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
