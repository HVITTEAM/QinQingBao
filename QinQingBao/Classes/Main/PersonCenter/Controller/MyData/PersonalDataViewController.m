//
//  PersonalDataViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/21.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "PersonalDataViewController.h"
#import "ChangePwdViewController.h"
#import "TextFieldViewController.h"
#import "RSKImageCropper.h"
#import "AddressController.h"
#import "AuthenticateViewController.h"
#import "BBSPersonalModel.h"

@interface PersonalDataViewController ()<RSKImageCropViewControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    
}
@property (nonatomic,retain) UIDatePicker* datePicker;

@property(assign,nonatomic)BOOL tapLoginOutButton;      //是否点击了退出按钮

@property (strong, nonatomic) BBSPersonalModel *personalInfo;

@end

@implementation PersonalDataViewController
{
    NSMutableArray *dataProvider;
    UserInforModel *infoVO;
    NSString *iconUrl;
}

-(instancetype)init
{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"个人资料";
    
    if (!infoVO)
    {
        dataProvider = [[NSMutableArray alloc] initWithObjects:
                        @[
                          @{@"title" : @"",@"placeholder" : @"",@"text" : @"头像", @"value" : @""},
                          @{@"title" : @"修改昵称",@"placeholder" : @"请输入昵称",@"text" : @"昵称", @"value" : @"正在获取"},
                          @{@"title" : @"",@"placeholder" : @"请输入性别",@"text" : @"性别", @"value" : @"正在获取"},
                          @{@"title" : @"",@"placeholder" : @"请输入出生日期",@"text" : @"出生日期", @"value" : @"正在获取"}
                          ],
                        @[
                          @{@"title" : @"",@"placeholder" : @"请输入电话",@"text" : @"电话", @"value" : @"正在获取"},
                          @{@"title" : @"修改邮箱",@"placeholder" : @"请输入Email",@"text" : @"Email", @"value" : @"正在获取"},
                          @{@"title" : @"修改地址",@"placeholder" : @"请输入地址",@"text" : @"地址", @"value" : @"正在获取"}
                          ],
                        @[
                          @{@"title" : @"",@"placeholder" : @"",@"text" : @"申请专家认证", @"value" : @""},
                          @{@"title" : @"",@"placeholder" : @"",@"text" : @"修改密码", @"value" : @""},
                          ],nil];
    }
    
    [self getDataProvider];
    
    [self getUserFannum];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //    清除图片缓存
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    
    [self initTableviewSkin];
}

/**
 *  设置tableView属性
 */
-(void)initTableviewSkin
{
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self setupFooter];
}

- (void)setupFooter
{
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 70)];
    bgview.backgroundColor = [UIColor clearColor];
    
    UIButton *logout = [[UIButton alloc] init];
    logout.frame = CGRectMake(20, 15, MTScreenW - 40, 45);
    logout.titleLabel.font = [UIFont systemFontOfSize:16];
    if ([SharedAppUtil defaultCommonUtil].userVO == nil)
        [logout setTitle:@"登录" forState:UIControlStateNormal];
    else
        [logout setTitle:@"退出当前帐号" forState:UIControlStateNormal];
    [logout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logout setBackgroundColor:HMColor(251, 176, 59)];
    logout.layer.cornerRadius = 6.0f;
    [logout addTarget:self action:@selector(loginOut:) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:logout];
    
    self.tableView.tableFooterView = bgview;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //    return [[SharedAppUtil defaultCommonUtil].userVO.logintype integerValue] > 0 ? 1 : 2;
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 4;
    else if (section == 1)
        return 3;
    else
        return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
        return 70;
    else
        return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *contentCellId = @"contentCell";
    static NSString *portraitCellId = @"portraitCell";
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0 && indexPath.row == 0){
        UITableViewCell *portraitCell = [tableView dequeueReusableCellWithIdentifier:portraitCellId];
        if (portraitCell == nil) {
            portraitCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:portraitCellId];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.width = 50;
            imageView.height = 50;
            imageView.layer.cornerRadius = imageView.height/2;
            imageView.layer.masksToBounds = YES;
            portraitCell.accessoryView = imageView;
        }
        
        NSDictionary *dict = dataProvider[indexPath.section][indexPath.row];
        portraitCell.textLabel.text = [dict objectForKey:@"text"];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Icon,iconUrl]];
        UIImageView *imageView = (UIImageView *)portraitCell.accessoryView;
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
        
        cell = portraitCell;
        
    }else{
        
        UITableViewCell *contentcell = [tableView dequeueReusableCellWithIdentifier:contentCellId];
        if (contentcell == nil) {
            contentcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:contentCellId];
        }
        if (indexPath.section == 2) {
            contentcell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            contentcell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        NSDictionary *dict = dataProvider[indexPath.section][indexPath.row];
        contentcell.textLabel.text = [dict objectForKey:@"text"];
        contentcell.detailTextLabel.text = [dict objectForKey:@"value"];
        
        if ([[dict objectForKey:@"value"] isEqualToString:@"未通过"]) {
            contentcell.detailTextLabel.textColor = HMColor(241, 90, 36);
        }else if ([[dict objectForKey:@"value"] isEqualToString:@"已通过"]){
            contentcell.detailTextLabel.textColor = HMColor(145, 181, 45);
        }else{
            contentcell.detailTextLabel.textColor = [UIColor lightGrayColor];
        }
        
        cell = contentcell;
    }
    
    cell.textLabel.textColor = HMColor(51, 51, 51);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        UIAlertView *alertPic = [[UIAlertView alloc] initWithTitle:@"请选择图片来源" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        alertPic.tag = 101;
        [alertPic show];
        
    }else if (indexPath.section == 0 && indexPath.row == 1){
        [self changeFieldWithIndexPath:indexPath];
        NSLog(@"姓名");
        
    }else if (indexPath.section == 0 && indexPath.row == 2){
        UIAlertView *alertSex = [[UIAlertView alloc] initWithTitle:@"请选择性别" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"男",@"女",@"保密", nil];
        alertSex.tag = 99;
        [alertSex show];
        
    }else if (indexPath.section == 0 && indexPath.row == 3){
        [self setDatePicker];
        
    }else if (indexPath.section == 1 && indexPath.row == 0){
        
        NSLog(@"电话");
        
    }else if (indexPath.section == 1 && indexPath.row == 1){
        [self changeFieldWithIndexPath:indexPath];
        NSLog(@"email");
        
    }else if (indexPath.section == 1 && indexPath.row == 2){
        AddressController *textView = [[AddressController alloc] init];
        [textView setItemInfoWith:[NSString stringWithFormat:@"浙江省%@",infoVO.totalname] regionStr:@"西湖区" regionCode:infoVO.member_areaid areaInfo:infoVO.member_areainfo];
        textView.changeDataBlock = ^(AreaModel *selectedRegionmodel, NSString *addressStr,NSString *areaInfo){
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:@"ios" forKey:@"client"];
            if (infoVO.member_sex != nil && [infoVO.member_sex floatValue] > 0)
                [dict setObject:infoVO.member_sex forKey:@"member_sex"];
            if (infoVO.member_sex != nil && [infoVO.member_sex floatValue] > 0)
                [dict setObject:infoVO.member_truename forKey:@"member_truename"];
            if (infoVO.member_birthday != nil)
                [dict setObject:infoVO.member_birthday forKey:@"member_birthday"];
            if (infoVO.member_email != nil)
                [dict setObject:infoVO.member_email forKey:@"member_email"];
            if ([SharedAppUtil defaultCommonUtil].userVO.key != nil)
                [dict setObject:[SharedAppUtil defaultCommonUtil].userVO.key forKey:@"key"];
            if (areaInfo != nil)
                [dict setObject:areaInfo forKey:@"member_areainfo"];
            if (selectedRegionmodel.dvcode != nil)
                [dict setObject:selectedRegionmodel.dvcode forKey:@"member_areaid"];
            
            [self updataUserInfor:dict];
            
        };
        textView.title = @"居住地址";
        [self.navigationController pushViewController:textView animated:YES];
        
        
    }else if (indexPath.section == 2 && indexPath.row == 0){
        AuthenticateViewController *authenticateVC = [[AuthenticateViewController alloc] init];
        authenticateVC.infoVO = infoVO;
        [self.navigationController pushViewController:authenticateVC animated:YES];
        
    }else if (indexPath.section == 2 && indexPath.row == 1){
        ChangePwdViewController *updateView = [[ChangePwdViewController alloc]init];
        [self.navigationController pushViewController:updateView animated:YES];
    }
}

- (void)changeFieldWithIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = dataProvider[indexPath.section][indexPath.row];
    TextFieldViewController *textView = [[TextFieldViewController alloc] init];
    textView.dict = dict;
    textView.inforVO = infoVO;
    __weak __typeof(self)weakSelf = self;
    textView.refleshDta = ^{
        [weakSelf getDataProvider];
    };
    [self.navigationController pushViewController:textView animated:YES];
}

#pragma mark -- 拍照选择模块
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag > 100)
    {
        if(buttonIndex==1)
            [self shootPiicturePrVideo];
        else if(buttonIndex==2)
            [self selectExistingPictureOrVideo];
        
    }
    else
    {
        if (buttonIndex == 0)
            return;
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"ios" forKey:@"client"];
        [dict setObject:[NSNumber numberWithInteger:buttonIndex] forKey:@"member_sex"];
        if (infoVO.member_sex != nil && [infoVO.member_sex floatValue] > 0)
            [dict setObject:infoVO.member_truename forKey:@"member_truename"];
        if (infoVO.member_birthday != nil)
            [dict setObject:infoVO.member_birthday forKey:@"member_birthday"];
        if (infoVO.member_areainfo != nil)
            [dict setObject:infoVO.member_areainfo forKey:@"member_areainfo"];
        if (infoVO.member_areaid != nil)
            [dict setObject:infoVO.member_areaid forKey:@"member_areaid"];
        if (infoVO.member_email != nil)
            [dict setObject:infoVO.member_email forKey:@"member_email"];
        if ([SharedAppUtil defaultCommonUtil].userVO.key != nil)
            [dict setObject:[SharedAppUtil defaultCommonUtil].userVO.key forKey:@"key"];
        
        [self updataUserInfor:dict];
    }
}


/**从相机*/
-(void)shootPiicturePrVideo
{
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}

///**从相册*/
-(void)selectExistingPictureOrVideo
{
    [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma 拍照模块
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    //输出格式为：2010-10-27 10:22:13
    NSLog(@"%@",currentDateStr);
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        //        NSData *data = UIImageJPEGRepresentation(image, 0.000000001);
        //        UIImage *slt = [image scaleImageToSize:CGSizeMake(70,70)];
        //        NSData *data = UIImageJPEGRepresentation(slt, 1);
        RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image];
        imageCropVC.title = @"裁剪照片";
        imageCropVC.delegate = self;
        [self.navigationController pushViewController:imageCropVC animated:YES];
        //关闭相册界面
        [picker dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"您取消了选择图片");
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



#pragma mark -- 与后台数据交互模块
/**
 *  获取数据
 */
-(void)getDataProvider
{
    [CommonRemoteHelper RemoteWithUrl:URL_GetUserInfor parameters: @{@"id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                                                                     @"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                     @"client" : @"ios"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         NSDictionary *di = [dict objectForKey:@"datas"];
                                         if ([di count] != 0)
                                         {
                                             infoVO = [UserInforModel objectWithKeyValues:di];
                                             iconUrl = infoVO.member_avatar;
                                         }
                                         else
                                             [NoticeHelper AlertShow:@"个人资料为空!" view:self.view];
                                         [self setDataProvider];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.view endEditing:YES];
                                 }];
}

/**
 *  设置数据源
 */
-(void)setDataProvider
{
    NSString *sexStr = [infoVO.member_sex  isEqual: @"1"] ? @"男" : [infoVO.member_sex  isEqual: @"2"] ? @"女" : @"保密";
    
    NSString *expert_status = nil;
    if (self.personalInfo.expert_status.length <= 0 || [self.personalInfo.expert_status isEqualToString:@"0"]) {
        expert_status = @"未申请";
    }else if ([self.personalInfo.expert_status isEqualToString:@"1"]){
        expert_status = @"已申请";
    }else if ([self.personalInfo.expert_status isEqualToString:@"2"]){
        expert_status = @"已通过";
    }else{
        expert_status = @"未通过";
    }

    dataProvider = [[NSMutableArray alloc] initWithObjects:
                    @[
                      @{@"title" : @"",@"placeholder" : @"",@"text" : @"头像", @"value" : infoVO.member_avatar.length > 0 ? @"" : @"未上传"},
                      @{@"title" : @"修改昵称",@"placeholder" : @"请输入昵称",@"text" : @"昵称", @"value" :  infoVO.member_truename.length > 0 ? infoVO.member_truename : @"未填写"},
                      @{@"title" : @"",@"placeholder" : @"请输入性别",@"text" : @"性别", @"value" : infoVO.member_sex.length > 0 ? sexStr : @"未填写"},
                      @{@"title" : @"",@"placeholder" : @"请输入出生日期",@"text" : @"出生日期", @"value" : infoVO.member_birthday.length > 0 ? infoVO.member_birthday : @"未填写"}
                      ],
                    @[
                      @{@"title" : @"",@"placeholder" : @"请输入电话",@"text" : @"电话", @"value" : infoVO.member_mobile.length > 0 ? infoVO.member_mobile : @"未填写"},
                      @{@"title" : @"修改邮箱",@"placeholder" : @"请输入Email",@"text" : @"Email", @"value" : infoVO.member_email.length > 0 ? infoVO.member_email : @"未填写"},
                      @{@"title" : @"修改地址",@"placeholder" : @"请输入地址",@"text" : @"地址", @"value" : infoVO.totalname.length > 0 ? [NSString stringWithFormat:@"%@%@",infoVO.totalname,infoVO.member_areainfo] : @"未填写"}
                      ],
                    @[
                      @{@"title" : @"",@"placeholder" : @"",@"text" : @"申请专家认证", @"value" : expert_status},
                      @{@"title" : @"",@"placeholder" : @"",@"text" : @"修改密码", @"value" : @""},
                      ],nil];
    
    [self.tableView reloadData];
}

/**
 *  修改信息
 */
-(void)updataUserInfor:(NSDictionary*)dict
{
    [CommonRemoteHelper RemoteWithUrl:URL_EditUserInfor parameters:dict
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"修改失败" message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         NSLog(@"修改资料成功");
                                         [self getDataProvider];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.view endEditing:YES];
                                 }];
}

/**
 *  上传头像
 */
-(void)upploadAvatar:(NSData*)imgdata
{
    [CommonRemoteHelper UploadPicWithUrl:URL_UploadAvatar
                              parameters:@{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                           @"client" : @"ios",
                                           @"sys":@"2"}
                                    type:CommonRemoteTypePost  dataObj:imgdata
                                 success:^(NSDictionary *dict, id responseObject) {
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         NSLog(@"图片上传出错");
                                     }
                                     else
                                     {
                                         NSLog(@"图片上传成功");
                                         [self getDataProvider];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.view endEditing:YES];
                                 }];
}

/**
 *  获取BBS账号信息
 */
-(void)getUserFannum
{
    if (![SharedAppUtil defaultCommonUtil].userVO)
        return;
    if (![SharedAppUtil defaultCommonUtil].bbsVO)
        return;
    [CommonRemoteHelper RemoteWithUrl:URL_Get_personaldetail parameters: @{@"uid" : [SharedAppUtil defaultCommonUtil].bbsVO.BBS_Member_id,
                                                                           @"client" : @"ios",
                                                                           @"key" :[SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum integerValue] > 0)
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         self.personalInfo = [BBSPersonalModel objectWithKeyValues:[dict objectForKey:@"datas"]];
                                         
                                         [self setDataProvider];
                                         
                                         [self.tableView reloadData];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                 }];
}


#pragma mark --- DatePicker
-(void)setDatePicker
{
    UIAlertController* alertVc=[UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n"
                                                                   message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    self.datePicker = [[UIDatePicker alloc]init];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    self.datePicker.locale = locale;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:0];
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    [comps setYear:-90];
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    
    [self.datePicker setMaximumDate:maxDate];
    [self.datePicker setMinimumDate:minDate];
    
    if (infoVO &&  infoVO.member_birthday &&![infoVO.member_birthday isEqualToString:@"0000-00-00"])
    {
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [inputFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate* inputDate = [inputFormatter dateFromString:infoVO.member_birthday];
        [self.datePicker setDate:inputDate animated:YES];
    }
    
    UIAlertAction* ok=[UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        NSDate* date=[self.datePicker date];
        NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString * curentDatest = [formatter stringFromDate:date];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:curentDatest forKey:@"member_birthday"];
        [dict setObject:@"ios" forKey:@"client"];
        if (infoVO.member_sex != nil && [infoVO.member_sex floatValue] > 0)
            [dict setObject:infoVO.member_sex forKey:@"member_sex"];
        if (infoVO.member_truename != nil)
            [dict setObject:infoVO.member_truename forKey:@"member_truename"];
        if (infoVO.member_areainfo != nil)
            [dict setObject:infoVO.member_areainfo forKey:@"member_areainfo"];
        if (infoVO.member_areaid != nil)
            [dict setObject:infoVO.member_areaid forKey:@"member_areaid"];
        if (infoVO.member_email != nil)
            [dict setObject:infoVO.member_email forKey:@"member_email"];
        if ([SharedAppUtil defaultCommonUtil].userVO.key != nil)
            [dict setObject:[SharedAppUtil defaultCommonUtil].userVO.key forKey:@"key"];
        
        [self updataUserInfor:dict];
    }];
    UIAlertAction* no=[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
    [alertVc.view addSubview:self.datePicker];
    [alertVc addAction:ok];
    [alertVc addAction:no];
    [self presentViewController:alertVc animated:YES completion:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.tapLoginOutButton) {
        if(buttonIndex == 0)
        {
            MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            [CommonRemoteHelper RemoteWithUrl:URL_Logout_New parameters: @{@"id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                                                                           @"client" : @"ios",
                                                                           @"key" : [SharedAppUtil defaultCommonUtil].userVO.key}
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
                                                 //清楚第三方的授权信息
                                                 [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
                                                 [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
                                                 [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
                                                 
                                                 [MTNotificationCenter postNotificationName:MTLoginout object:nil userInfo:nil];
                                                 [self.navigationController popViewControllerAnimated:YES];
                                             }
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             NSLog(@"发生错误！%@",error);
                                             [HUD removeFromSuperview];
                                             [self.view endEditing:YES];
                                         }];
        }else{
            self.tapLoginOutButton = NO;
        }
        
        return;
    }
    
    
    if(buttonIndex == 0)
    {
        NSDate* date=[self.datePicker date];
        NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString * curentDatest=[formatter stringFromDate:date];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        [dict setObject:curentDatest forKey:@"member_birthday"];
        [dict setObject:@"ios" forKey:@"client"];
        if (infoVO.member_sex != nil && [infoVO.member_sex floatValue] > 0)
            [dict setObject:infoVO.member_sex forKey:@"member_sex"];
        if (infoVO.member_truename != nil)
            [dict setObject:infoVO.member_truename forKey:@"member_truename"];
        if (infoVO.member_email != nil)
            [dict setObject:infoVO.member_email forKey:@"member_email"];
        if (infoVO.member_areainfo != nil)
            [dict setObject:infoVO.member_areainfo forKey:@"member_areainfo"];
        if (infoVO.member_areaid != nil)
            [dict setObject:infoVO.member_areaid forKey:@"member_areaid"];
        if ([SharedAppUtil defaultCommonUtil].userVO.key != nil)
            [dict setObject:[SharedAppUtil defaultCommonUtil].userVO.key forKey:@"key"];
        [self updataUserInfor:dict];
        
    }
    
}

#pragma mark - RSKImageCropViewControllerDelegate

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage
{
    UIImage *slt = [croppedImage scaleImageToSize:CGSizeMake(70,70)];
    NSData *data = UIImageJPEGRepresentation(slt, 1);
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self upploadAvatar:data];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma  mark - 退出当前账号
-(void)loginOut:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"登录"])
    {
        return [MTNotificationCenter postNotificationName:MTNeedLogin object:nil];
    }
    
    self.tapLoginOutButton = YES;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"确定退出当前账号？"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:@"确定"
                                                    otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

-(void)dealloc
{
    NSLog(@"销毁");
}

@end
