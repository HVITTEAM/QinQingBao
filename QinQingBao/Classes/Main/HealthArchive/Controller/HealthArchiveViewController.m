//
//  HealthArchiveViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 2016/11/7.
//  Copyright © 2016年 董徐维. All rights reserved.
//


#import "HealthArchiveViewController.h"

#import "HealthArchiveViewController1.h"
#import "ShowCodeViewController.h"

#import "AddressController.h"
#import "TextCell.h"
#import "TextTwoCell.h"
#import "CommonRulerViewController.h"
#import "HeadProcessView.h"
#import "RSKImageCropper.h"
#import "ArchiveData1.h"

#define kContent @"cellContent"
#define kTitle @"cellTitle"
#define kPlaceHolder @"cellPlaceHolder"

@interface HealthArchiveViewController ()<RSKImageCropViewControllerDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong,nonatomic)NSArray *datas;     //UITableView数据源

@property (strong,nonatomic)UIControl* dateSelectView;

@property (strong,nonatomic)UIDatePicker *datePicker;

@property (strong,nonatomic)NSIndexPath *currentIdx;

@property (strong, nonatomic) UIImage *portraitImage;

@end

@implementation HealthArchiveViewController

-(instancetype)init
{
    self.hidesBottomBarWhenPushed = YES;
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"健康档案";

    if (self.isAddArchive) {
        //获取当前用户的缓存的档案数据,新增时候
        self.archiveData = [ArchiveData getArchiveDataFromFile];
        self.portraitImage = [[UIImage alloc] initWithContentsOfFile:self.archiveData.portraitPic];
    }else{
        //查看时候
        [self loadArchivePersonInfo];
    }

    [self setupFooter];
}

- (ArchiveData *)archiveData
{
    if (!_archiveData) {
        _archiveData = [[ArchiveData alloc] init];
    }
    return _archiveData;
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
        [section0 addObject:createItem(@"",@"头像",@"")];
        [section0 addObject:createItem(self.archiveData.truename,@"姓名",@"必填项")];
        if (!self.isAddArchive) {
            [section0 addObject:createItem(nil,@"档案二维码",nil)];
        }
        
//        NSString *address = [NSString stringWithFormat:@"%@%@",_customInfo.totalname ? _customInfo.totalname:@"",_customInfo.areainfo ? _customInfo.areainfo:@""];

        [section0 addObject:createItem(self.archiveData.mobile,@"联系电话",@"必填项")];
        [section0 addObject:createItem([ArchiveData numberToSex:[self.archiveData.sex integerValue]],@"性别",@"请选择")];
        [section0 addObject:createItem(self.archiveData.birthday,@"出生日期",@"请填写")];
        
        NSMutableArray *section1 = [[NSMutableArray alloc] init];
        [section1 addObject:createItem(self.archiveData.height,@"身高",@"请填写")];
        [section1 addObject:createItem(self.archiveData.weight,@"体重",@"请填写")];
        [section1 addObject:createItem(self.archiveData.waistline,@"腰围",@"请填写")];
        [section1 addObject:createItem(self.archiveData.systolicpressure,@"收缩压(mmhg)",@"请填写")];
        [section1 addObject:createItem(self.archiveData.cholesterol,@"总胆固醇(mg/dl)",@"请填写")];
        
        NSMutableArray *section2 = [[NSMutableArray alloc] init];
        [section2 addObject:createItem(self.archiveData.occupation,@"目前职业",@"请填写")];
        [section2 addObject:createItem([ArchiveData numberToLivingcondition:[self.archiveData.livingcondition integerValue]],@"工作生活状态",@"请填写")];
        [section2 addObject:createItem(self.archiveData.email,@"电子邮箱",@"请填写")];
        [section2 addObject:createItem(self.archiveData.address,@"联系地址",@"请填写")];

        
        self.datas = @[section0,section1,section2];
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
    
    if (indexPath.section == 0 && (indexPath.row == 0 || (indexPath.row == 2 && !self.isAddArchive))){
        static NSString *portraitCellId = @"portraitCell";
        UITableViewCell *portraitCell = [tableView dequeueReusableCellWithIdentifier:portraitCellId];
        if (portraitCell == nil) {
            portraitCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:portraitCellId];
            portraitCell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.layer.masksToBounds = YES;
            portraitCell.accessoryView = imageView;
            
            portraitCell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        }
    
        portraitCell.textLabel.text = rowItem[kTitle];
        UIImageView *imageView = (UIImageView *)portraitCell.accessoryView;
        
        if (indexPath.row == 2) {
            imageView.width = 30;
            imageView.image = [UIImage imageNamed:@"qrcode"];
            
        }else{
            imageView.width = 50;
            imageView.image = self.portraitImage?:[UIImage imageNamed:@"placeholderImage"];
        }
        imageView.height = imageView.width;
        imageView.layer.cornerRadius = imageView.height/2;
        return portraitCell;
        
    }else{
        TextCell *textCell = [TextCell createCellWithTableView:tableView];
        textCell.textLabel.text = rowItem[kTitle];
        textCell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        textCell.field.text = rowItem[kContent];
        textCell.field.placeholder = rowItem[kPlaceHolder];
        textCell.idx = indexPath;
        textCell.contentChangeCallBack = ^(NSIndexPath *idx,NSString *contentStr){
            weakSelf.datas[idx.section][idx.row][kContent] = contentStr;
        };
        
        //是否禁用文本框
        textCell.field.enabled = YES;
        BOOL enable = indexPath.section == 0 && (indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 4);
        if (!self.isAddArchive) {   //查看时候
            enable = indexPath.section == 0 && (indexPath.row == 0 || indexPath.row == 4 || indexPath.row == 5);
        }
        
        enable = enable || indexPath.section == 1;
        enable = enable || (indexPath.section == 2 && (indexPath.row == 1 || indexPath.row == 3));
        if (enable) {
            textCell.field.enabled = NO;
        }
        
        return textCell;
    }
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
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 70;
    }
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView endEditing:YES];
    
    self.currentIdx = indexPath;
    __weak typeof(self)weakSelf = self;
    
    if (indexPath.section == 0 && indexPath.row == 2 && !self.isAddArchive){  //查看时候多一个二维码
       
        ShowCodeViewController *vc = [[ShowCodeViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section == 0 && indexPath.row == 0) {
        UIAlertView *alertPic = [[UIAlertView alloc] initWithTitle:@"请选择图片来源" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        alertPic.tag = 101;
        [alertPic show];
    }else if (indexPath.section == 0 && indexPath.row == 3){
        if (self.isAddArchive) {  //新增时候是性别选择
            [[[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"男",@"女",@"保密", nil] show];
        }
    }else if (indexPath.section == 0 && indexPath.row == 4){
        if (self.isAddArchive) {  //新增时候是显示生日选择
            [self showDatePickerView];
        }else{  //查看时候是性别选择
            [[[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"男",@"女",@"保密", nil] show];
        }
        
    }else if (indexPath.section == 0 && indexPath.row == 5){
        [self showDatePickerView];
    }else if (indexPath.section == 1){
        CommonRulerViewController *vc = [[CommonRulerViewController alloc] init];
        if (0 == indexPath.row) {
            [vc initWithTitle:@"身高" startValue:100 currentValue:170 count:150 unit:@"cm"];
        }else if (1 == indexPath.row){
            [vc initWithTitle:@"体重" startValue:30 currentValue:65 count:170 unit:@"kg"];
        }else if (2 == indexPath.row){
            [vc initWithTitle:@"腰围" startValue:30 currentValue:72 count:170 unit:@"cm"];
        }else if (3 == indexPath.row){
            [vc initWithTitle:@"收缩压" startValue:40 currentValue:120 count:160 unit:@"mmhg"];
        }else if (4 == indexPath.row){
            [vc initWithTitle:@"总胆固醇" startValue:100 currentValue:200 count:200 unit:@"mg/dl"];
        }
        
        vc.selectedResult = ^(CGFloat value){
            
            NSMutableArray *sections = self.datas[self.currentIdx.section];
            NSMutableDictionary *item = sections[self.currentIdx.row];
            item[kContent] = [NSString stringWithFormat:@"%.0f",value];
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section == 2 && indexPath.row == 3) {
        AddressController *textView = [[AddressController alloc] init];
        //        if (weakSelf.customInfo.totalname.length > 0 && weakSelf.customInfo.dvcode.length > 0)
        //        {
        //            [textView setItemInfoWith:weakSelf.customInfo.totalname regionStr:@"西湖区" regionCode:weakSelf.customInfo.dvcode areaInfo:weakSelf.customInfo.areainfo];
        //        }
        textView.changeDataBlock = ^(AreaModel *selectedRegionmodel, NSString *addressStr,NSString *areaInfo){
            //            weakSelf.customInfo.dvcode = selectedRegionmodel.dvcode;
            //            weakSelf.customInfo.areainfo = areaInfo;
            //            weakSelf.customInfo.totalname = addressStr;
            weakSelf.datas[2][3][kContent] = [NSString stringWithFormat:@"%@%@",addressStr,areaInfo];
            [weakSelf.tableView reloadData];
        };
        [weakSelf.navigationController pushViewController:textView animated:YES];
    }else if (indexPath.section == 2 && indexPath.row == 1){
        [[[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"体力劳动为主",@"脑力劳动为主",@"体力/脑力劳动基本均衡", nil] show];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag > 100)
    {
        if(buttonIndex==1)
            [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
        else if(buttonIndex==2)
            [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
        return;
    }
    
    if (0 == buttonIndex) {
        return;
    }
    
    NSMutableArray *sections = self.datas[self.currentIdx.section];
    NSMutableDictionary *item = sections[self.currentIdx.row];
    
    if (0 == self.currentIdx.section) {
        if (1 == buttonIndex) {
            item[kContent] = @"男";
        }else if (2 == buttonIndex){
            item[kContent] = @"女";
        }else if (3 == buttonIndex){
            item[kContent] = @"保密";
        }
    }else{
        if (1 == buttonIndex) {
            item[kContent] = @"体力劳动为主";
        }else if (2 == buttonIndex){
            item[kContent] = @"脑力劳动为主";
        }else if (3 == buttonIndex){
            item[kContent] = @"体力/脑力劳动基本均衡";
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark -- 拍照选择模块
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image];
        imageCropVC.title = @"裁剪照片";
        imageCropVC.delegate = self;
        [self.navigationController pushViewController:imageCropVC animated:YES];
        //关闭相册界面
        [picker dismissViewControllerAnimated:NO completion:nil];
    }
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{

    [picker dismissViewControllerAnimated:NO completion:nil];
}

-(void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType
{
    NSArray *mediatypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if([UIImagePickerController isSourceTypeAvailable:sourceType] &&[mediatypes count]>0)
    {
        NSArray *mediatypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.mediaTypes = mediatypes;
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        NSString *requiredmediatype = (NSString *)kUTTypeImage;
        NSArray *arrmediatypes = [NSArray arrayWithObject:requiredmediatype];
        [picker setMediaTypes:arrmediatypes];
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误信息!" message:@"当前设备不支持拍摄功能" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark - RSKImageCropViewControllerDelegate

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage
{
    NSData *data = UIImageJPEGRepresentation(croppedImage, 0.5);
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.portraitImage = [[UIImage alloc] initWithData:data];
    [self.tableView reloadData];
    self.archiveData.portraitPic = [ArchiveData savePictoDocument:data picName:@"archive_portrait.jpg"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 设置footer View

- (void)setupFooter
{
    HeadProcessView *headView = [[HeadProcessView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 70)];
    headView.backgroundColor = [UIColor clearColor];
    [headView initWithShowIndex:0];
    self.tableView.tableHeaderView = headView;
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 80)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, MTScreenW - 40, 40)];
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithRGB:@"70a426"];
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
    
    NSString *name = self.datas[0][1][kContent];
    if (name.length == 0)
    {
        return [NoticeHelper AlertShow:@"请输入姓名" view:nil];
    }
    
    NSString *tel;
    if (self.isAddArchive) {
        tel = self.datas[0][2][kContent];
    }else{
        tel = self.datas[0][3][kContent];
    }
    
    if (tel.length == 0)
    {
        return [NoticeHelper AlertShow:@"请输入手机号" view:nil];
    }
    
    if (![self validatePhoneNumOrEmail:tel type:1]) {
        return [NoticeHelper AlertShow:@"输入手机号码格式不正确" view:nil];
    }
    
    
    NSString  *email = self.datas[2][2][kContent];
    if (email.length == 0) {
        return [NoticeHelper AlertShow:@"请输入电子邮箱" view:nil];
    }
    if (![self validatePhoneNumOrEmail:email type:2]) {
        return [NoticeHelper AlertShow:@"输入邮箱格式不正确" view:nil];
    }
    
    NSString *address = self.datas[2][3][kContent];
    if (address.length == 0) {
        return [NoticeHelper AlertShow:@"请输入地址" view:nil];
    }

    NSString *sex;
    NSString *birthday;
    if (self.isAddArchive) {
        sex = self.datas[0][3][kContent];
        birthday = self.datas[0][4][kContent];
    }else{
        sex = self.datas[0][4][kContent];
        birthday = self.datas[0][5][kContent];
    }
    
    self.archiveData.truename = name;
    self.archiveData.mobile = tel;
    self.archiveData.sex = [NSString stringWithFormat:@"%d",(int)[ArchiveData sexToNumber:sex]];
    self.archiveData.birthday = birthday;
    
    self.archiveData.height = self.datas[1][0][kContent];
    self.archiveData.weight = self.datas[1][1][kContent];
    self.archiveData.waistline = self.datas[1][2][kContent];
    self.archiveData.systolicpressure = self.datas[1][3][kContent];
    self.archiveData.cholesterol = self.datas[1][4][kContent];
    
    self.archiveData.occupation = self.datas[2][0][kContent];
    self.archiveData.livingcondition = [NSString stringWithFormat:@"%d",(int)[ArchiveData livingconditionToNumber:self.datas[2][1][kContent]]];
    self.archiveData.email = email;
    self.archiveData.address = address;
    
    
    HealthArchiveViewController1 *vc = [[HealthArchiveViewController1 alloc] init];
    vc.archiveData = self.archiveData;
    //新增时候才保存临时的数据在本地
    if (self.isAddArchive) {
        [self.archiveData saveArchiveDataToFile];
        vc.addArchive = YES;
    }else{
        vc.addArchive = NO;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
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

#pragma mark - 网络相关
- (void)loadArchivePersonInfo
{
    //判断是否登录
    if (![SharedAppUtil checkLoginStates])
        return;
    
    NSDictionary *params = @{
                             @"client":@"ios",
                             @"key":[SharedAppUtil defaultCommonUtil].userVO.key,
                             @"fmno":self.selectedListModel.fmno
                             };
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Get_bingding_fm parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        [hud removeFromSuperview];
        
        if ([dict[@"code"] integerValue] != 0) {
            [NoticeHelper AlertShow:@"errorMsg" view:self.view];
        }
        
        NSLog(@"%@",dict);
        
        
        ArchiveData1 *archive = [ArchiveData1 objectWithKeyValues:dict[@"datas"]];
        
        self.archiveData.fmno = self.selectedListModel.fmno;
        
        self.archiveData.truename = archive.basics.truename;
        self.archiveData.sex = archive.basics.sex;
        self.archiveData.birthday = archive.basics.birthday;
        self.archiveData.height = archive.basics.height;
        self.archiveData.weight = archive.basics.weight;
        self.archiveData.waistline = archive.basics.waistline;
        self.archiveData.systolicpressure = archive.basics.systolicpressure;
        self.archiveData.cholesterol = archive.basics.cholesterol;
        self.archiveData.mobile = archive.basics.mobile;
        self.archiveData.email = archive.basics.email;
        self.archiveData.address = archive.basics.address;
        self.archiveData.occupation = archive.basics.occupation;
        self.archiveData.livingcondition = archive.basics.livingcondition;
        self.archiveData.units = archive.basics.units;
        self.archiveData.bremark = archive.basics.bremark;
        
        self.archiveData.physicalcondition = archive.diseasehistory.physicalcondition;
        self.archiveData.events = archive.diseasehistory.events;
        self.archiveData.takingdrugs = archive.diseasehistory.takingdrugs;
        self.archiveData.diabetes = archive.diseasehistory.diabetes;
        self.archiveData.medicalhistory = archive.diseasehistory.medicalhistory;
        self.archiveData.hereditarycardiovascular = archive.diseasehistory.hereditarycardiovascular;
        self.archiveData.geneticdisease = archive.diseasehistory.geneticdisease;
        self.archiveData.dremark = archive.diseasehistory.dremark;
        
        self.archiveData.smoke = archive.habits.smoke;
        self.archiveData.drink = archive.habits.drink;
    
#warning 这个还没搞
//        self.archiveData.diet = archive.habits.diet;
        
        self.archiveData.sleeptime = archive.habits.sleeptime;
        self.archiveData.getuptime = archive.habits.getuptime;
        self.archiveData.sports = archive.habits.sports;
        self.archiveData.badhabits = archive.habits.badhabits;
        self.archiveData.hremark = archive.habits.hremark;
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud removeFromSuperview];
        [NoticeHelper AlertShow:@"请求出错了" view:nil];
    }];
    
}

@end
