//
//  CXComposeViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/9/12.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#define contentViewHeight 50

#import "CXComposeViewController.h"
#import "MTTextView.h"

@interface CXComposeViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UIAlertViewDelegate>

{
    MTTextView *titleField;
    
    MTTextView *contentView;
    
    UIView * inputContentView;
    
    CGFloat navigationAndstatusbarHeight;
    
    // 图片数组
    NSMutableArray *imgDataArr;
    
    // 图片上传成功之后返回的id数组
    NSArray *imgIDArr;
}
@end

@implementation CXComposeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadNotificationCell];
    
    [self initNavigation];
    
    [self initView];
    
    imgDataArr = [[NSMutableArray alloc] init];
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    navigationAndstatusbarHeight = self.navigationController.navigationBar.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"发布帖子";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 19)];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"btn_dismissItem"] forState:UIControlStateNormal];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"btn_dismissItem_highlighted"] forState:UIControlStateHighlighted];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 23)];
    [rightButton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:@"发送" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithRGB:@"70a426"] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    [self.navigationItem setLeftBarButtonItem:leftButton];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
}

-(void)initView
{
    // 标题文本框
    titleField = [[MTTextView alloc] initWithFrame:CGRectMake(10, 4, MTScreenW, 40)];
    titleField.font = [UIFont systemFontOfSize:16];
    titleField.textColor = [UIColor colorWithRGB:@"999999"];
    titleField.alwaysBounceVertical = YES; // 垂直方向上拥有有弹簧效果
    titleField.placehoder = @"标题（5-50字）";
    [self.view addSubview:titleField];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleField.frame)+1, MTScreenW, 0.5f)];
    line.backgroundColor = [UIColor colorWithRGB:@"bbbbbb"];
    [self.view addSubview:line];
    
    // 内容文本框
    contentView = [[MTTextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(line.frame)+1, MTScreenW, MTScreenH  -  contentView.y - navigationAndstatusbarHeight - contentViewHeight)];
    contentView.font = [UIFont systemFontOfSize:16];
    contentView.textColor = [UIColor colorWithRGB:@"999999"];
    contentView.alwaysBounceVertical = YES; // 垂直方向上拥有有弹簧效果
    contentView.placehoder = @"内容（必填）";
    contentView.delegate  = self;
    [self.view addSubview:contentView];
    
    
    inputContentView = [[UIView alloc] initWithFrame:CGRectMake(0, MTScreenH - contentViewHeight - navigationAndstatusbarHeight, MTScreenW, contentViewHeight)];
    inputContentView.backgroundColor = HMGlobalBg;
    [self.view addSubview:inputContentView];
    
    UIButton *picBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 14, 60, 30)];
    [picBtn setBackgroundImage:[UIImage imageNamed:@"pic.png"] forState:UIControlStateNormal];
    [picBtn setBackgroundImage:[UIImage imageNamed:@"pic.png"] forState:UIControlStateSelected];
    picBtn.size = picBtn.currentBackgroundImage.size;
    [picBtn addTarget:self action:@selector(getPic) forControlEvents:UIControlEventTouchUpInside];
    [inputContentView addSubview:picBtn];
    
    UIButton *expressionBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(picBtn.frame) + 10, 14, 60, 30)];
    [expressionBtn setBackgroundImage:[UIImage imageNamed:@"expression.png"] forState:UIControlStateNormal];
    [expressionBtn setBackgroundImage:[UIImage imageNamed:@"expression.png"] forState:UIControlStateSelected];
    expressionBtn.size = expressionBtn.currentBackgroundImage.size;
//    [inputContentView addSubview:expressionBtn];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 0.5)];
    topLine.backgroundColor = [UIColor colorWithRGB:@"dddddd"];
    [inputContentView addSubview:topLine];
}

#pragma mark UITextViewDelegate


- (void)textViewDidChange:(UITextView *)textView
{
    if(contentView.markedTextRange != nil)
        return;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:contentView.attributedText];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:4];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, contentView.attributedText.length)];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:16.f]
                             range:NSMakeRange(0, contentView.attributedText.length)];
    
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor colorWithRGB:@"999999"]
                             range:NSMakeRange(0, contentView.attributedText.length)];
    
    textView.attributedText = attributedString;
}

/**
 *  添加图片到textView上
 *
 *  @param img   图片
 */
-(void)setNewContent:(UIImage *)img
{
    NSLog(@"%f---%f",img.size.width,img.size.height);
    
    // 获取图片的宽高比
    CGFloat scale = img.size.width/img.size.height;
    
    if (img.size.width > MTScreenW *0.5)
    {
        img = [img scaleImageToSize:CGSizeMake(MTScreenW *0.5, MTScreenW *0.5 /scale)];
    }
    
    // 获取原有的text
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:contentView.attributedText];
    
    // 插入img之之前换行
    NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc] initWithString:@"\r\n"];
    [attributedString appendAttributedString:textStr];
    
    // img
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil] ;
    textAttachment.image = img;
    
    // 插入img
    NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [attributedString insertAttributedString:imageStr atIndex:attributedString.length];
    
    // 插入img之后换行
    [attributedString appendAttributedString:textStr];
    
    contentView.attributedText = attributedString;
}

#pragma mrak UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag > 100)
    {
        if(buttonIndex==1)
            [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
        else if(buttonIndex==2)
            [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
        
    }
}

-(void)getPic
{
//    [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
    UIAlertView *alertPic = [[UIAlertView alloc] initWithTitle:@"请选择图片来源" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    alertPic.tag = 101;
    [alertPic show];
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
        
        //        NSData *imgdata1 = UIImageJPEGRepresentation(image, 1);
        NSData *imgdata = [UIImage compressImg:image];
        
        // 讲图片数据添加到数组中
        [imgDataArr addObject:imgdata];
        [self setNewContent:image];
        
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

#pragma mark - 与后台交互模块

-(void)send
{
    [self.view endEditing:YES];
    NSString *titlestr = [titleField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *contentstr = [contentView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (titlestr.length < 5 || titlestr.length > 50)
    {
        return [NoticeHelper AlertShow:@"帖子标题长度在5-50个字之间" view:nil];
    }
    else if(contentstr.length == 0)
    {
        return [NoticeHelper AlertShow:@"帖子内容不能为空" view:nil];
    }
    
    // 如果有图片就先上传图片
    if (imgDataArr.count > 0)
    {
        [self uploadImg];
    }
    else
    {
        [self uploadPosts];
    }
}

/**
 *  将属性字符串转换成一般性字符串
 *
 */
-(NSString *)attributedToString
{
    NSAttributedString * att = contentView.attributedText;
    
    NSMutableAttributedString * resutlAtt = [[NSMutableAttributedString alloc]initWithAttributedString:att];
    
    __block  NSInteger imgIdx = 0;
    
    //枚举出所有的属性字符串
    [att enumerateAttributesInRange:NSMakeRange(0, att.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        //NSTextAttachment value类型
        NSTextAttachment * textAtt = [attrs objectForKey:@"NSAttachment"];//从字典中取得那一个图片
        if (textAtt)
        {
            NSString *text = [NSString stringWithFormat:@"[attachimg]%@[/attachimg]",imgIDArr[imgIdx]];
            [resutlAtt replaceCharactersInRange:range withString:text];
            imgIdx ++;
        }
    }];
    
    return [resutlAtt.string stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
}

-(void)uploadImg
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    paramDict = [@{@"uid" : [SharedAppUtil defaultCommonUtil].bbsVO.BBS_Member_id,
                   @"client" : @"ios",
                   @"key" : [SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key,
                   @"sys" : @"4",
                   @"fid" : [NSString stringWithFormat:@"%li",(long)self.fid]} mutableCopy];
    //创建上传的图片数组
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    
    for (NSData *data in imgDataArr)
    {
        NSString *key = [NSString stringWithFormat:@"Filedata[%lu]",(unsigned long)[imgDataArr indexOfObject:data]];
        
        NSDictionary *imageDict = @{
                                    @"fileData":data,
                                    @"name":key,
                                    @"fileName":@"img.jpg",
                                    @"mimeType":@"image/png",
                                    };
        
        [imageArray addObject:imageDict];
    }
    
    [CommonRemoteHelper UploadPicWithUrl:URL_Get_upload_image_multy parameters:paramDict  images:imageArray success:^(NSDictionary *dict, id responseObject) {
        [HUD removeFromSuperview];
        
        id codeNum = [dict objectForKey:@"code"];
        if([codeNum integerValue] > 0)//如果返回的是NSString 说明有错误
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        else
        {
            CX_Log(@"图片上传成功");
            NSDictionary *dataDict = [dict objectForKey:@"datas"];
            
            imgIDArr = [[[dataDict objectForKey:@"aids"] reverseObjectEnumerator] allObjects];
            [self uploadPosts];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD removeFromSuperview];
        [NoticeHelper AlertShow:@"请求失败" view:self.view];
    }];
}

-(void)uploadPosts
{
    NSString *messagestr  = [self attributedToString];
    
    // 拼接上传图片id的字符串
    NSString *idStr  = @"";
    for (NSString *str in imgIDArr)
    {
        if ([imgIDArr indexOfObject:str] == 0)
            idStr = [NSString stringWithFormat:@"%@%@",idStr,str];
        else
            idStr = [NSString stringWithFormat:@"%@,%@",idStr,str];
    }
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [CommonRemoteHelper RemoteWithUrl:URL_Get_newthread_post parameters: @{@"uid" : [SharedAppUtil defaultCommonUtil].bbsVO.BBS_Member_id,
                                                                           @"client" : @"ios",
                                                                           @"key" : [SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key,
                                                                           @"subject" : titleField.text,
                                                                           @"message" : messagestr,
                                                                           @"fid" : [NSString stringWithFormat:@"%li",(long)self.fid],
                                                                           @"attachimg" : idStr}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     [HUD removeFromSuperview];
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum integerValue] > 0)//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         [NoticeHelper AlertShow:@"帖子发表成功" view:nil];
                                         [self dismissViewControllerAnimated:YES completion:nil];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                 }];
}

#pragma mark - 键盘处理事件

-(void)loadNotificationCell
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    // 根据老的 frame 设定新的 frame
    CGRect newTableViewFrame = CGRectMake(10, 45.5, MTScreenW, MTScreenH  -  contentView.y - navigationAndstatusbarHeight - contentViewHeight);
    newTableViewFrame.size.height = newTableViewFrame.size.height - keyboardRect.size.height;
    
    // 根据老的 frame 设定新的 frame
    CGRect newTextViewFrame = inputContentView.frame;
    newTextViewFrame.origin.y = keyboardRect.origin.y - inputContentView.frame.size.height;
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    NSValue *animationCurveObject = [userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSUInteger animationCurve;
    [animationCurveObject getValue:&animationCurve];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve];
    contentView.frame = newTableViewFrame;
    inputContentView.frame = newTextViewFrame;
    
    
    [UIView commitAnimations];
}

//键盘消失时的处理，文本输入框回到页面底部。
- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary* userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    NSValue *animationCurveObject =[userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSUInteger animationCurve;
    [animationCurveObject getValue:&animationCurve];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve];
    
    CGRect newTableViewFrame = contentView.frame;
    newTableViewFrame.size.height =   MTScreenH  -  contentView.y - navigationAndstatusbarHeight - contentViewHeight;
    contentView.frame = newTableViewFrame;
    
    CGRect newTextViewFrame = inputContentView.frame;
    newTextViewFrame.origin.y = MTScreenH - contentViewHeight - navigationAndstatusbarHeight;
    inputContentView.frame = newTextViewFrame;
    
    [UIView commitAnimations];
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
