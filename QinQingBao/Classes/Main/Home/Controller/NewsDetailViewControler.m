//
//  NewsDetailViewControler.m
//  QinQingBao
//
//  Created by 董徐维 on 16/5/6.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "NewsDetailViewControler.h"

@interface NewsDetailViewControler ()<UITextViewDelegate,UITextFieldDelegate>
{
    UIView * _inputTextView;
    UITextField *textfield;
}

@end

@implementation NewsDetailViewControler

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
    
    [self loadNotificationCell];
    
    [self initView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];
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

-(void)initView
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share.png"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"资讯详情";
    
    self.webView.height = MTScreenH - 70;
    
    _inputTextView = [[UIView alloc] initWithFrame:CGRectMake(0, MTScreenH - 60, MTScreenW, 60)];
    _inputTextView.backgroundColor = HMColor(239, 239, 239);
    [self.view addSubview:_inputTextView];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 0.5)];
    topLine.backgroundColor = [UIColor colorWithRGB:@"dddddd"];
    [_inputTextView addSubview:topLine];
    
    textfield = [[UITextField alloc] initWithFrame:CGRectMake(20, 12.5, MTScreenW - 40, 35)];
    textfield.layer.borderWidth = 0.5;
    textfield.returnKeyType =UIReturnKeySend;
    textfield.backgroundColor = [UIColor whiteColor];
    textfield.layer.borderColor = [[UIColor colorWithRGB:@"dddddd"] CGColor];
    textfield.delegate = self;
    textfield.placeholder  = @"  我来说两句.....";
    [_inputTextView addSubview:textfield];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self addComment];
    return YES;
}


/**
 *  发表评论
 */
-(void)addComment
{
    if (![SharedAppUtil defaultCommonUtil].userVO)
    {
        return [MTNotificationCenter postNotificationName:MTNeedLogin object:nil userInfo:nil];
    }
    if (textfield.text.length < 1)
        return [NoticeHelper AlertShow:@"评论内容不能为空" view:nil];
    NSLog(@"%@",textfield.text);
    [CommonRemoteHelper RemoteWithUrl:URL_add_comment parameters:@{@"mem_id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                                                                   @"article_id" : self.articleItem.id,
                                                                   @"comment_content" : textfield.text}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         textfield.text = @"";
                                         [textfield resignFirstResponder];
                                         return [NoticeHelper AlertShow:@"评论成功" view:nil];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [NoticeHelper AlertShow:@"提交失败!" view:self.view];
                                 }];
}


- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    // 根据老的 frame 设定新的 frame
    CGRect newTextViewFrame = _inputTextView.frame; // by michael
    newTextViewFrame.origin.y = keyboardRect.origin.y - _inputTextView.frame.size.height;
    
    // 键盘的动画时间，设定与其完全保持一致
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // 键盘的动画是变速的，设定与其完全保持一致
    NSValue *animationCurveObject = [userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSUInteger animationCurve;
    [animationCurveObject getValue:&animationCurve];
    
    // 开始及执行动画
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve];
    _inputTextView.frame = newTextViewFrame;
    [UIView commitAnimations];
}
//键盘消失时的处理，文本输入框回到页面底部。
- (void)keyboardWillHide:(NSNotification *)notification
{
    
    NSDictionary* userInfo = [notification userInfo];
    
    // 键盘的动画时间，设定与其完全保持一致
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // 键盘的动画是变速的，设定与其完全保持一致
    NSValue *animationCurveObject =[userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSUInteger animationCurve;
    [animationCurveObject getValue:&animationCurve];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve];
    CGRect newTextViewFrame = _inputTextView.frame;
    newTextViewFrame.origin.y = MTScreenH - _inputTextView.frame.size.height;
    _inputTextView.frame = newTextViewFrame;
    [UIView commitAnimations];
}

/**
 *  分享文章
 */
-(void)share
{
    NSString * url = [NSString stringWithFormat:@"%@/admin/manager/index.php/family/article_detail/%@",URL_Local,self.articleItem.id];
    NSString *str = [NSString stringWithFormat:@"%@%@",URL_ImgArticle,self.articleItem.logo_url];
    NSArray* imageArray = @[str];
    
    if (imageArray) {
        //1、创建分享参数（必要）
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:self.articleItem.abstract
                                         images:imageArray
                                            url:[NSURL URLWithString:url]
                                          title:self.articleItem.title
                                           type:SSDKContentTypeAuto];
        
        // 定制微信好友的分享内容
        [shareParams SSDKSetupWeChatParamsByText:self.articleItem.abstract title:self.articleItem.title url:[NSURL URLWithString:url] thumbImage:nil image:[UIImage imageNamed:str] musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];// 微信好友子平台
        
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:@[
                                         @(SSDKPlatformTypeQQ),
                                         @(SSDKPlatformSubTypeWechatSession),
                                         @(SSDKPlatformSubTypeWechatTimeline),
                                         ]                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
}


@end
