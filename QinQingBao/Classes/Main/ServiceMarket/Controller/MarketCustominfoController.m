//
//  MarketCustominfoController.m
//  QinQingBao
//
//  Created by shi on 16/6/21.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "MarketCustominfoController.h"
#import "AddressController.h"
#import "TextCell.h"
#import "TextTwoCell.h"
#import "CommonRulerViewController.h"

#define kContent @"cellContent"
#define kTitle @"cellTitle"
#define kPlaceHolder @"cellPlaceHolder"

@interface MarketCustominfoController ()

@property (strong,nonatomic)NSArray *datas;     //UITableView数据源

@property (strong,nonatomic)UIControl* dateSelectView;

@property (strong,nonatomic)UIDatePicker *datePicker;

@property (strong,nonatomic)NSIndexPath *currentIdx;

@end

@implementation MarketCustominfoController

-(instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"客户信息";
    
    if (!_customInfo) {
        _customInfo = [[MarketCustomInfo alloc] init];
    }
    
    [self setupFooter];
}

-(NSArray *)datas
{
    if (!_datas) {
        NSMutableDictionary *(^createItem)(NSString *content,NSString *title,NSString *placeHolder) = ^NSMutableDictionary *(NSString *content,NSString *title,NSString *placeHolder){
            
            NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
            [item setValue:content forKey:kContent];
            [item setValue:title forKey:kTitle];
            [item setValue:placeHolder forKey:kPlaceHolder];
            return item;
        };
        
        NSMutableArray *section0 = [[NSMutableArray alloc] init];
        [section0 addObject:createItem(_customInfo.name,@"姓名",@"必填,请填写姓名")];
        [section0 addObject:createItem(_customInfo.tel,@"电话",@"必填,请填写电话")];
        
        NSString *address = [NSString stringWithFormat:@"%@%@",_customInfo.totalname,_customInfo.areainfo];
        [section0 addObject:createItem(address,@"地址",@"必填,请填写地址")];
        [section0 addObject:createItem(_customInfo.email,@"邮箱",@"必填,例sample@hvit.com.cn")];
        
        NSMutableArray *section1 = [[NSMutableArray alloc] init];
        [section1 addObject:createItem(_customInfo.sex,@"性别",@"选填")];
        [section1 addObject:createItem(_customInfo.birthday,@"出生日期",@"选填")];
        [section1 addObject:createItem(_customInfo.height,@"身高",@"选填")];
        [section1 addObject:createItem(_customInfo.weight,@"体重",@"选填")];
        
        NSMutableArray *section2 = [[NSMutableArray alloc] init];
        [section2 addObject:createItem(_customInfo.womanSpecial,@"女性特殊期",@"选填")];
        
        NSMutableArray *section3 = [[NSMutableArray alloc] init];
        [section3 addObject:createItem(_customInfo.caseHistory,@"既往病史",@"选填")];
        [section3 addObject:createItem(_customInfo.medicine,@"服药情况",@"选填")];
        
        self.datas = @[section0,section1,section2,section3];

    }
    return _datas;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datas.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(NSMutableArray *)self.datas[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    NSMutableArray *sections = self.datas[indexPath.section];
    NSMutableDictionary *rowItem = sections[indexPath.row];
    
    if (0 == indexPath.section && 2 != indexPath.row) {
        TextCell *textCell = [TextCell createCellWithTableView:tableView];
        textCell.textLabel.text = rowItem[kTitle];
        textCell.field.text = rowItem[kContent];
        textCell.field.placeholder = rowItem[kPlaceHolder];
        textCell.idx = indexPath;
        textCell.contentChangeCallBack = ^(NSIndexPath *idx,NSString *contentStr){
            weakSelf.datas[idx.section][idx.row][kContent] = contentStr;
        };
        
        return textCell;
    }else if (1 == indexPath.section || 2 == indexPath.section || 0 == indexPath.section){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellid"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = HMColor(51, 51, 51);
        }
        cell.textLabel.text = rowItem[kTitle];
        NSString *temp = rowItem[kContent];
        
        if (1 == indexPath.section && 2 == indexPath.row) {
            cell.detailTextLabel.text = temp.length > 0 ? [NSString stringWithFormat:@"%@ cm",temp]:rowItem[kPlaceHolder];
        }else if (1 == indexPath.section && 3 == indexPath.row){
            cell.detailTextLabel.text = temp.length > 0 ? [NSString stringWithFormat:@"%@ kg",temp]:rowItem[kPlaceHolder];
        }else{
            cell.detailTextLabel.text = temp.length > 0 ? temp:rowItem[kPlaceHolder];
        }
        
        if (temp.length <= 0) {
            cell.detailTextLabel.textColor = HMColor(199, 199, 205);
        }else{
            cell.detailTextLabel.textColor = HMColor(51, 51, 51);
        }
        return cell;
    }else{
        TextTwoCell *textTwoCel = [TextTwoCell createCellWithTableView:tableView];
        
        textTwoCel.titleLb.text = rowItem[kTitle];
        textTwoCel.contentTextView.text = rowItem[kContent];
        textTwoCel.placeHolderLb.text = rowItem[kPlaceHolder];
        
        textTwoCel.idx = indexPath;
        textTwoCel.contentChangeCallBack = ^(NSIndexPath *idx,NSString *contentStr){
            weakSelf.datas[idx.section][idx.row][kContent] = contentStr;
        };

        return textTwoCel;
    }
    return nil;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (3 == indexPath.section) {
        return 114;
    }
    
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView endEditing:YES];
    
    self.currentIdx = indexPath;
    __weak typeof(self)weakSelf = self;
    
    if (0 == indexPath.section && 2 == indexPath.row) {
        AddressController *textView = [[AddressController alloc] init];
        if (weakSelf.customInfo.totalname.length > 0 && weakSelf.customInfo.dvcode.length > 0)
        {
            [textView setItemInfoWith:weakSelf.customInfo.totalname regionStr:@"西湖区" regionCode:weakSelf.customInfo.dvcode areaInfo:weakSelf.customInfo.areainfo];
        }
        
        textView.changeDataBlock = ^(AreaModel *selectedRegionmodel, NSString *addressStr,NSString *areaInfo){
            weakSelf.customInfo.dvcode = selectedRegionmodel.dvcode;
            weakSelf.customInfo.areainfo = areaInfo;
            weakSelf.customInfo.totalname = addressStr;
            self.datas[0][2][kContent] = [NSString stringWithFormat:@"%@%@",addressStr,areaInfo];
            [weakSelf.tableView reloadData];
        };
        [weakSelf.navigationController pushViewController:textView animated:YES];
    }else if (1 == indexPath.section && 0 == indexPath.row){
        [[[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"男",@"女",@"保密", nil] show];
    }else if (1 == indexPath.section && 1 == indexPath.row){
        [self showDatePickerView];
        
    }else if (1 == indexPath.section && (2 == indexPath.row || 3 == indexPath.row)){
        CommonRulerViewController *vc = [[CommonRulerViewController alloc] init];
        if (2 == indexPath.row) {
            [vc initWithTitle:@"身高" startValue:100 currentValue:165 count:120 unit:@"cm"];
        }else{
            [vc initWithTitle:@"体重" startValue:40 currentValue:65 count:150 unit:@"kg"];
        }
        
        vc.selectedResult = ^(CGFloat value){
            
            NSMutableArray *sections = self.datas[self.currentIdx.section];
            NSMutableDictionary *item = sections[self.currentIdx.row];
            item[kContent] = [NSString stringWithFormat:@"%.0f",value];
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];

    }else if (2 == indexPath.section){
        [[[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"无",@"有", nil] show];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) {
        return;
    }
    
    NSMutableArray *sections = self.datas[self.currentIdx.section];
    NSMutableDictionary *item = sections[self.currentIdx.row];
    
    if (1 == self.currentIdx.section) {
        if (1 == buttonIndex) {
            item[kContent] = @"男";
        }else if (2 == buttonIndex){
            item[kContent] = @"女";
        }else if (3 == buttonIndex){
            item[kContent] = @"保密";
        }
    }else{
        if (1 == buttonIndex) {
            item[kContent] = @"无";
        }else if (2 == buttonIndex){
            item[kContent] = @"有";
        }
    }

    [self.tableView reloadData];
}

#pragma mark - 设置footer View

- (void)setupFooter
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 80)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, MTScreenW - 40, 40)];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.backgroundColor = HMColor(33, 193, 181);
    btn.layer.cornerRadius = 8.0f;
    [btn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btn];
    
    self.tableView.tableFooterView = bottomView;
}

#pragma mark - 生日选择视图相关
/**
 *  显示生日选择视图
 */
-(void)showDatePickerView
{
    self.dateSelectView = [[UIControl alloc] initWithFrame:self.view.frame];
    self.dateSelectView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
    [self.dateSelectView addTarget:self action:@selector(datePickerViewHide:) forControlEvents:UIControlEventTouchUpInside];
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, MTScreenH - 180, MTScreenW, 180)];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    NSDate *currentDate = [NSDate date];
    NSString *dateStr = @"1900-01-01 00:00:00";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    formatter.timeZone = timeZone;
    formatter.locale = locale;
    NSDate *minDate = [formatter dateFromString:dateStr];
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    formatter1.dateFormat = @"yyyy-MM-dd";
    formatter1.timeZone = timeZone;
    formatter1.locale = locale;
    
    NSString *birthdayStr = self.datas[self.currentIdx.section][self.currentIdx.row][kContent];
    NSDate * birthdayDate = [formatter1 dateFromString:birthdayStr];
    
    self.datePicker.timeZone = timeZone;
    self.datePicker.locale = locale;
    self.datePicker.minimumDate = minDate;
    self.datePicker.maximumDate = currentDate;
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    if (birthdayDate) {
        self.datePicker.date = birthdayDate;
    }
    
    [self.dateSelectView addSubview:self.datePicker];
    
    UIToolbar *tb = [[UIToolbar alloc] initWithFrame:CGRectMake(0, MTScreenH - 224, MTScreenW, 44)];
    tb.backgroundColor = [UIColor whiteColor];
    tb.translucent = NO;
    
    UIBarButtonItem *fixSpaceItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixSpaceItem1.width = 15;
    UIBarButtonItem *fixSpaceItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixSpaceItem2.width = 15;
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(datePickerViewHide:)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *confirmItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(selectBirthday:)];
    tb.items = @[fixSpaceItem1,cancelItem,spaceItem,confirmItem,fixSpaceItem2];
    
    [self.dateSelectView addSubview:tb];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tb.frame), MTScreenW, 1)];
    line.backgroundColor = HMColor(230, 230, 230);
    [self.dateSelectView addSubview:line];
    
    UIWindow *kwindow = [[UIApplication sharedApplication] keyWindow];
    
    [kwindow addSubview:self.dateSelectView];
}

/**
 *  隐藏生日选择视图
 */
-(void)datePickerViewHide:(id )sender
{
    [self.dateSelectView removeFromSuperview];
}

/**
 *  确定选择生日
 */
-(void)selectBirthday:(UIBarButtonItem *)sender
{
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    formatter.timeZone = timeZone;
    formatter.locale = locale;
    NSString *birthday = [formatter stringFromDate:self.datePicker.date];
    
    NSMutableArray *sections = self.datas[self.currentIdx.section];
    NSMutableDictionary *item = sections[self.currentIdx.row];
    item[kContent] = birthday;
    [self.tableView reloadData];
    
    [self datePickerViewHide:nil];
}
#pragma mark - 事件方法
/**
 *  点击确定按钮后调用
 */
-(void)next:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    NSMutableArray *section0 = self.datas[0];
    NSString *name = section0[0][kContent];
    if (name.length == 0)
    {
        return [NoticeHelper AlertShow:@"请输入姓名" view:nil];
    }
    
    NSString *tel = section0[1][kContent];
    if (tel.length == 0)
    {
        return [NoticeHelper AlertShow:@"请输入手机号" view:nil];
    }
    
    
    if (![self validatePhoneNumOrEmail:tel type:1]) {
        return [NoticeHelper AlertShow:@"输入手机号码格式不正确" view:nil];
    }
    
    NSString *address = section0[2][kContent];
    if (address.length == 0) {
        return [NoticeHelper AlertShow:@"请输入地址" view:nil];
    }
    
    NSString  *email = section0[3][kContent];
    if (email.length == 0) {
        return [NoticeHelper AlertShow:@"请输入电子邮箱" view:nil];
    }
    if (![self validatePhoneNumOrEmail:email type:2]) {
        return [NoticeHelper AlertShow:@"输入邮箱格式不正确" view:nil];
    }
    
    self.customInfo.name = name;
    self.customInfo.tel = tel;
    self.customInfo.email = email;
    
    self.customInfo.sex = self.datas[1][0][kContent];
    self.customInfo.birthday = self.datas[1][1][kContent];
    self.customInfo.height = self.datas[1][2][kContent];
    self.customInfo.weight = self.datas[1][3][kContent];
    
    self.customInfo.womanSpecial = self.datas[2][0][kContent];
    
    self.customInfo.caseHistory = self.datas[3][0][kContent];
    self.customInfo.medicine = self.datas[3][1][kContent];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    if (self.customInfoCallBack)
    {
        self.customInfoCallBack(self.customInfo);
    }
}

#pragma mark - 工具方法
/**
 *  验证手机或邮箱是否合法
 *
 *  @param phoneNumOrEmail 手机号码或邮箱
 *  @param type            1:表示验证手机号码,2:表示验证邮箱
 *
 *  @return  yes:表示通过验证,no表示未通过
 */
-(BOOL)validatePhoneNumOrEmail:(NSString *)phoneNumOrEmail type:(NSInteger)type
{
    //默认为验证手机号
    NSString *regular = @"^1[3578]\\d{9}$";
    if (type == 2) {
        //验证邮箱
        regular = @"^\\s*\\w+(?:\\.{0,1}[\\w-]+)*@[a-zA-Z0-9]+(?:[-.][a-zA-Z0-9]+)*\\.[a-zA-Z]+\\s*$";
    }
    
    NSPredicate *prediccate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regular];
    BOOL result =[prediccate evaluateWithObject:phoneNumOrEmail];
    return result;
    
}

@end
