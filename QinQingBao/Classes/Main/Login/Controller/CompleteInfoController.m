//
//  CompleteInfoController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/9/26.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CompleteInfoController.h"
#import "RSKImageCropper.h"

@interface CompleteInfoController ()<RSKImageCropViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *headImg;
@property (strong, nonatomic) IBOutlet UITextField *nameTextfield;
@property (strong, nonatomic) IBOutlet UIButton *btn;
- (IBAction)btnHandler:(id)sender;

@end

@implementation CompleteInfoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
    
    [self initNavgation];
}

-(void)initView
{
    self.title = @"完善资料";

    self.nameTextfield.leftViewMode = UITextFieldViewModeAlways;
    self.nameTextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.nameTextfield.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"name.png"]];
    self.headImg.userInteractionEnabled=YES;
    self.headImg.layer.masksToBounds = YES;
    self.headImg.layer.cornerRadius = self.headImg.width/2;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage)];
    [self.headImg addGestureRecognizer:singleTap];
    
    self.btn.layer.masksToBounds = YES;
    self.btn.layer.cornerRadius = 8;

}

-(void)initNavgation
{
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateHighlighted];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [self.navigationItem setLeftBarButtonItem:leftButton];
}


// 个人头像点击事件
-(void)onClickImage
{
    [self getPic];
}

- (IBAction)btnHandler:(id)sender
{
    NSString *str = [self.nameTextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if (str.length > 15 || str.length < 2)
    {
        return [NoticeHelper AlertShow:@"昵称不能少于2个字，不能大于15个字" view:nil];
    }
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [CommonRemoteHelper RemoteWithUrl:URL_DiscuzRegisterFromCx parameters: @{@"key" :[SharedAppUtil defaultCommonUtil].userVO.key,
                                                                            @"client" : @"ios",
                                                                            @"truename" : str}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     [HUD removeFromSuperview];

                                     NSLog(@"%@",dict);
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum integerValue] > 0)
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         [self dismissViewControllerAnimated:YES completion:nil];
                                         [self loginBBS];
                                     }
                                     
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                 }];
}

// 登录bbs
-(void)loginBBS
{
    [CommonRemoteHelper RemoteWithUrl:URL_Get_loginToOtherSys parameters: @{@"key" :[SharedAppUtil defaultCommonUtil].userVO.key,
                                                                            @"client" : @"ios",
                                                                            @"targetsys" : @"4"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     NSLog(@"%@",dict);
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum integerValue] > 0)//如果返回的是NSString 说明有错误
                                     {
                                         // 当目标系统不存在该用户的时候：  "errorMsg": "请激活论坛用户，输入用户名",
                                         if ([codeNum integerValue] == 18001)
                                         {
                                            
                                         }
                                         else
                                         {
                                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                             [alertView show];
                                         }
                                     }
                                     else
                                     {
                                         NSDictionary *datas = [dict objectForKey:@"datas"];
                                         
                                         BBSUserModel *bbsmodel = [[BBSUserModel alloc] init];
                                         bbsmodel.BBS_Key = [datas objectForKey:@"key"];
                                         bbsmodel.BBS_Member_id = [datas objectForKey:@"member_id"];
                                         bbsmodel.BBS_Member_mobile = [datas objectForKey:@"member_mobile"];
                                         bbsmodel.BBS_Sys = [datas objectForKey:@"sys"];
                                         
                                         [SharedAppUtil defaultCommonUtil].bbsVO = bbsmodel;
                                         [ArchiverCacheHelper saveObjectToLoacl:bbsmodel key:BBSUser_Archiver_Key filePath:BBSUser_Archiver_Path];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                 }];
}


-(void)getPic
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

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
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

#pragma mark - RSKImageCropViewControllerDelegate

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage
{
    self.headImg.image = croppedImage;
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
