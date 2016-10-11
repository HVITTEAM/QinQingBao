//
//  RegistCompleteInfoController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/9/26.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "RegistCompleteInfoController.h"
#import "RSKImageCropper.h"
#import "JPUSHService.h"
#import "BBSUserModel.h"
@interface RegistCompleteInfoController ()<RSKImageCropViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    float timesec;
    
    NSString *btnTitle;
    
    NSTimer *timer;
}
@property (strong, nonatomic) IBOutlet UITextField *telTextfield;
@property (strong, nonatomic) IBOutlet UITextField *codeTextfield;
@property (strong, nonatomic) IBOutlet UIButton *codeBtn;
@property (strong, nonatomic) IBOutlet UIImageView *headImg;
@property (strong, nonatomic) IBOutlet UITextField *nameTextfield;
@property (strong, nonatomic) IBOutlet UIButton *btn;
- (IBAction)codeClickHandler:(id)sender;
//键盘高度
@property(assign,nonatomic)CGFloat keyBoardH;
@property (nonatomic, retain) UIImage *iconImg;
- (IBAction)btnHandler:(id)sender;

@end

@implementation RegistCompleteInfoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
    
    [self initNavgation];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //注册键盘通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //解除键盘通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 解决键盘遮挡文本框
-(void)keyBoardWillShow:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    CGRect keyboardFrame = [[dict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyBoardH = keyboardFrame.size.height;
    CGFloat keyBoardToTop = MTScreenH - self.keyBoardH;
    NSInteger animationCurve =[[dict objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat duration =  [[dict objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect currentTextFrame = [self.view convertRect:self.btn.frame fromView:self.view];
    CGFloat currentTextBottomToTop = CGRectGetMaxY(currentTextFrame);
    
    if (keyBoardToTop - currentTextBottomToTop < 0) {
        [UIView animateWithDuration:duration delay:0 options:animationCurve animations:^{
            
            self.view.bounds = CGRectMake(0, -(keyBoardToTop-currentTextBottomToTop)+30, MTScreenW, MTScreenH);
            
        } completion:nil];
    }
}

-(void)keyBoardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.bounds = CGRectMake(0, 0, MTScreenW, MTScreenH);
    }];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

-(void)initView
{
    self.title = @"完善资料";
    self.view.backgroundColor = [UIColor colorWithRGB:@"F5F5F5"];
    
    self.nameTextfield.layer.borderWidth = 0;
    self.codeTextfield.layer.borderWidth = 0;
    self.telTextfield.layer.borderWidth = 0;
    
    self.nameTextfield.leftViewMode = UITextFieldViewModeAlways;
    self.nameTextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    UIView *View0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 24)];
    UIImageView *img0 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 24, 24)];
    img0.image =[UIImage imageNamed:@"name.png"];
    [View0 addSubview:img0];
    self.nameTextfield.leftView = View0;
    
    self.codeTextfield.leftViewMode = UITextFieldViewModeAlways;
    self.codeTextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    UIView *View1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 24)];
    UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 24, 24)];
    img1.image =[UIImage imageNamed:@"code.png"];
    [View1 addSubview:img1];
    self.codeTextfield.leftView = View1;
    
    self.telTextfield.leftViewMode = UITextFieldViewModeAlways;
    self.telTextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    UIView *View2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 24)];
    UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 24, 24)];
    img2.image =[UIImage imageNamed:@"tel.png"];
    [View2 addSubview:img2];
    self.telTextfield.leftView = View2;
    
    self.headImg.userInteractionEnabled=YES;
    self.headImg.layer.masksToBounds = YES;
    self.headImg.layer.cornerRadius = 45;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage)];
    [self.headImg addGestureRecognizer:singleTap];
    
    self.btn.layer.masksToBounds = YES;
    self.btn.layer.cornerRadius = 8;
    
    self.codeBtn.layer.masksToBounds = YES;
    [self.codeBtn setBackgroundColor:[UIColor whiteColor]];
    [self.codeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    self.codeBtn.layer.borderWidth = 0.5;
    self.codeBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.codeBtn.layer.cornerRadius = 12;
    
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:_icon] placeholderImage:[UIImage imageNamed:@"placeholderImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.iconImg = image;
    }];
    self.nameTextfield.text = _nickname;
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
    [self regist];
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
                                         
                                         //是否隐藏左上角的返回按钮 如果是yes的话，说明是在监控和个人中心界面 否则在下单的时候弹出的界面
                                         [MTNotificationCenter postNotificationName:MTReLogin object:nil];
                                         [self dismissViewControllerAnimated:YES completion:nil];

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
    self.iconImg = croppedImage;
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


/**
 *  获取验证码
 */
- (IBAction)codeClickHandler:(id)sender
{
    if (self.telTextfield.text.length != 11)
        return [NoticeHelper AlertShow:@"请输入正确的手机号！" view:self.view];
    [self.view endEditing:YES];
    [[MTSMSHelper sharedInstance] getCheckcode:self.telTextfield.text];
    [MTSMSHelper sharedInstance].sureSendSMS = ^{
        [NoticeHelper AlertShow:@"验证码发送成功,请查收！" view:self.view];
        [self countdownHandler];
    };
}


#pragma mark 倒计时模块

/**
 *  倒计时
 */
-(void)countdownHandler
{
    timesec = 60.0f;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
}

-(void)timerFireMethod:(NSTimer *)theTimer
{
    if (timesec == 1) {
        [theTimer invalidate];
        timesec = 60;
        [self.codeBtn setTitle:@"获取验证码" forState: UIControlStateNormal];
        [self.codeBtn setTitleColor:HMColor(69, 134, 229) forState:UIControlStateNormal];
        [self.codeBtn setEnabled:YES];
    }else
    {
        timesec--;
        NSString *title = [NSString stringWithFormat:@"%.f秒后重发",timesec];
        [self.codeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [self.codeBtn setEnabled:NO];
        [self.codeBtn setTitle:title forState:UIControlStateNormal];
    }
}

-(void)registWithOpenid:(NSString *)openid login_type:(NSString *)login_type open_token:(NSString *)open_token nickname:(NSString *)nickname icon:(NSString *)icon
{
    _openid = openid;
    _login_type = login_type;
    _open_token = open_token;
    _nickname = nickname;
    _icon = icon;
}

/**
 *  第三方登录成功调用后台接口注册账号
 = */
-(void)regist
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_LoginByother_new parameters: @{@"open_id" : self.openid,
                                                                         @"login_type" : self.login_type,
                                                                         @"open_token" : self.open_token,
                                                                         @"client" : @"ios",
                                                                         @"mobile":self.telTextfield.text,
                                                                         @"code" :self.codeTextfield.text,
                                                                         @"sys" : @"2"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         if ([codeNum isEqualToString:@"11010"])
                                         {
                                             //清楚第三方的授权信息
                                             [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
                                             [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
                                             [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
                                         }
                                         else
                                         {
                                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                             [alertView show];
                                         }
                                     }
                                     else
                                     {
                                         [NoticeHelper AlertShow:@"登录成功！" view:self.view];
                                         NSDictionary *di = [dict objectForKey:@"datas"];
                                         UserModel *vo = [UserModel objectWithKeyValues:di];
                                         vo.logintype = self.login_type;
                                         vo.member_mobile = self.telTextfield.text;
                                         [self loginResultSetData:vo];
                                     }
                                     [HUD removeFromSuperview];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                 }];
    
}

/**
 *  登录成功之后需要设置本地登录数据
 *
 *  @param uservo 用户信息model
 */
-(void)loginResultSetData:(UserModel *)uservo
{
    [SharedAppUtil defaultCommonUtil].userVO = uservo;
    [ArchiverCacheHelper saveObjectToLoacl:uservo key:User_Archiver_Key filePath:User_Archiver_Path];
    [self loginBBS];
    //设置推送标签和别名
    [JPUSHService setTags:nil alias: [NSString stringWithFormat:@"qqb%@",uservo.member_mobile] callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
}

@end
