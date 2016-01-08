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
#import "UpdateAddressController.h"
#import "RSKImageCropper.h"


@interface PersonalDataViewController ()<RSKImageCropViewControllerDelegate>

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
                        @{@"title" : @"",@"placeholder" : @"",@"text" : @"头像", @"value" : @""},
                        @{@"title" : @"修改姓名",@"placeholder" : @"请输入姓名",  @"text" : @"姓名",@"value" : @"正在获取"},
                        @{@"title" : @"",@"placeholder" : @"",@"text" : @"性别",@"value" : @"正在获取"},
                        @{@"title" : @"修改电话",@"placeholder" : @"请输入电话号码", @"text" : @"电话",@"value" : @"正在获取"},
                        @{@"title" : @"修改生日",@"placeholder" : @"请输入出生日期",@"text" : @"生日",@"value" : @"正在获取"},
                        @{@"title" : @"修改地址",@"placeholder" : @"请输入地址",@"text" : @"住址",@"value" : @"正在获取"},
                        nil];
        
        [self.tableView reloadData];
    }
    
    [self getDataProvider];
}

-(void)viewWillAppear:(BOOL)animated
{
    //    清除图片缓存
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    
    [super viewWillAppear:animated];
    
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, MTScreenH - 100, MTScreenW, 50)];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:13];
    lab.textColor = [UIColor orangeColor];
    lab.numberOfLines = 0;
    lab.text = @"请填写个人真实信息，方便我们与您家人进\n行信息确认，确保信息的安全性!";
    CGSize size = [lab.text sizeWithAttributes:@{NSFontAttributeName:lab.font}];
    lab.width = size.width;
    lab.height = size.height;
    lab.x = self.view.width/2 - lab.width/2;
    lab.y = 0;
    [view addSubview:lab];
    
    [self.tableView addSubview:view];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    return 6;
    else
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    return 60;
    else
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *content = @"contentCell";
    
    UITableViewCell *contentcell = [tableView dequeueReusableCellWithIdentifier:content];
    
    if (indexPath.section == 0)
    {
        if(contentcell == nil)
        {
            contentcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:content];
            contentcell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
            contentcell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        }
        contentcell.accessoryType = UITableViewCellAccessoryNone;
        NSDictionary *dict = [dataProvider objectAtIndex:indexPath.row];
        contentcell.textLabel.text = [dict objectForKey:@"text"];
        contentcell.detailTextLabel.text = [dict objectForKey:@"value"];
        if(indexPath.row == 0)http:
        {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Icon,iconUrl]];
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
            imageView.width = imageView.height = 50;
            imageView.layer.cornerRadius = imageView.height/2;
            imageView.layer.masksToBounds = YES;
            contentcell.accessoryView = imageView;
        }
        else if(indexPath.row == 3 || indexPath.row == 4)
        contentcell.accessoryType = UITableViewCellAccessoryNone;
        else
        contentcell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    else
    {
        if(contentcell == nil)
        {
            contentcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:content];
            contentcell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
            contentcell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        }
        contentcell.textLabel.text = @"修改密码";
        contentcell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    return  contentcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        ChangePwdViewController *updateView = [[ChangePwdViewController alloc]init];
        [self.navigationController pushViewController:updateView animated:YES];
    }
    else if(indexPath.row == 0)
    {
        UIAlertView *alertPic = [[UIAlertView alloc] initWithTitle:@"请选择图片来源" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        alertPic.tag = 101;
        [alertPic show];
    }
    else if(indexPath.row == 2)
    {
        UIAlertView *alertSex = [[UIAlertView alloc] initWithTitle:@"请选择性别" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"男",@"女",@"保密", nil];
        alertSex.tag = 99;
        [alertSex show];
    }
    else if(indexPath.row == 3)
    {
        return;
    }
    else if(indexPath.row == 4)
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self setDatePickerIos8];
        else
        [self setDatePickerIos7];
    }
    else if(indexPath.row == 5)
    {
        
        NSDictionary *dict = [dataProvider objectAtIndex:indexPath.row];
        UpdateAddressController *textView = [[UpdateAddressController alloc] init];
        textView.dict = dict;
        textView.inforVO = infoVO;
        __weak __typeof(self)weakSelf = self;
        textView.refleshDta = ^{
            [weakSelf getDataProvider];
        };
        [self.navigationController pushViewController:textView animated:YES];
    }
    
    else
    {
        NSDictionary *dict = [dataProvider objectAtIndex:indexPath.row];
        TextFieldViewController *textView = [[TextFieldViewController alloc] init];
        textView.dict = dict;
        textView.inforVO = infoVO;
        __weak __typeof(self)weakSelf = self;
        textView.refleshDta = ^{
            [weakSelf getDataProvider];
        };
        [self.navigationController pushViewController:textView animated:YES];
    }
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
        if (infoVO.member_truename != nil)
        [dict setObject:infoVO.member_truename forKey:@"member_truename"];
        if (infoVO.member_birthday != nil)
        [dict setObject:infoVO.member_birthday forKey:@"member_birthday"];
        if (infoVO.member_areainfo != nil)
        [dict setObject:infoVO.member_areainfo forKey:@"member_areainfo"];
        if (infoVO.member_areaid != nil)
        [dict setObject:infoVO.member_areaid forKey:@"member_areaid"];
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
                                         //                                         [NoticeHelper AlertShow:@"获取失败!" view:self.view];
                                     }
                                     else
                                     {
                                         NSDictionary *di = [dict objectForKey:@"datas"];
                                         if ([di count] != 0)
                                         {
                                             infoVO = [UserInforModel objectWithKeyValues:di];
                                             iconUrl = [di objectForKey:@"member_avatar"];
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
    dataProvider = [[NSMutableArray alloc] initWithObjects:
                    @{@"title" : @"",@"placeholder" : @"",@"text" : @"头像", @"value" : infoVO.member_avatar.length > 0 ? @"" : @"未上传"},
                    @{@"title" : @"修改姓名",@"placeholder" : @"请输入姓名",  @"text" : @"姓名",@"value" : infoVO.member_truename.length > 0 ? infoVO.member_truename : @"未填写"},
                    @{@"title" : @"",@"placeholder" : @"",@"text" : @"性别",@"value" : infoVO.member_sex.length > 0 ? sexStr : @"未填写"},
                    @{@"title" : @"修改电话",@"placeholder" : @"请输入电话号码", @"text" : @"电话",@"value" : infoVO.member_mobile.length > 0 ? infoVO.member_mobile : @"未填写"},
                    @{@"title" : @"修改生日",@"placeholder" : @"请输入出生日期",@"text" : @"生日",@"value" : infoVO.member_birthday.length > 0 ? infoVO.member_birthday : @"未填写"},
                    @{@"title" : @"修改地址",@"placeholder" : @"请输入地址",@"text" : @"住址",@"value" : infoVO.totalname.length > 0 ? [NSString stringWithFormat:@"%@%@",infoVO.totalname,infoVO.member_areainfo] : @"未填写"},
                    nil];
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
                                           @"client" : @"ios"}
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

#pragma mark --- DatePicker
-(void)setDatePickerIos8
{
    UIAlertController* alertVc=[UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n"
                                                                   message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    self.datePicker = [[UIDatePicker alloc]init];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    self.datePicker.locale = locale;
    UIAlertAction* ok=[UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        NSDate* date=[self.datePicker date];
        NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString * curentDatest = [formatter stringFromDate:date];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:curentDatest forKey:@"member_birthday"];
        [dict setObject:@"ios" forKey:@"client"];
        if (infoVO.member_sex != nil)
        [dict setObject:infoVO.member_sex forKey:@"member_sex"];
        if (infoVO.member_truename != nil)
        [dict setObject:infoVO.member_truename forKey:@"member_truename"];
        if (infoVO.member_areainfo != nil)
        [dict setObject:infoVO.member_areainfo forKey:@"member_areainfo"];
        if (infoVO.member_areaid != nil)
        [dict setObject:infoVO.member_areaid forKey:@"member_areaid"];
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

-(void)setDatePickerIos7
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle: @"\n\n\n\n\n\n\n\n\n\n\n"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"确认"
                                  otherButtonTitles:nil];
    
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [actionSheet addSubview:self.datePicker];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        NSDate* date=[self.datePicker date];
        NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString * curentDatest=[formatter stringFromDate:date];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        [dict setObject:curentDatest forKey:@"member_birthday"];
        [dict setObject:@"ios" forKey:@"client"];
        if (infoVO.member_sex != nil)
        [dict setObject:infoVO.member_sex forKey:@"member_sex"];
        if (infoVO.member_truename != nil)
        [dict setObject:infoVO.member_truename forKey:@"member_truename"];
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
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self upploadAvatar:data];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
