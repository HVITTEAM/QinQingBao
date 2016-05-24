//
//  OrderRefundViewController.m
//  QinQingBao
//
//  Created by shi on 16/5/19.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "OrderRefundViewController.h"
#import "RefundReasonMode.h"
#import "OrderModel.h"

@interface OrderRefundViewController ()<UITextFieldDelegate,UITextViewDelegate,UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *rootScrollview;    //滚动用的Scrollview

@property (weak, nonatomic) IBOutlet UITextField *refundReasonField;         //退款原因的textField

@property (weak, nonatomic) IBOutlet UITextField *sumField;            //金额的textField

@property (weak, nonatomic) IBOutlet UILabel *sumPromptLb;              //金额的提示label

@property (weak, nonatomic) IBOutlet UITextView *explainTextView;       //退款说明的textView

@property (weak, nonatomic) IBOutlet UILabel *explainPlaceholderLb;     //退款说明的提示label

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;               //提交按钮

@property (strong,nonatomic)UIView *currentView;              //当前编辑的文本 view

@property (strong,nonatomic)NSMutableArray *reasonsArray;    //存放退款原因的数组

@property (strong,nonatomic)RefundReasonMode *selectedReasonMode;    //选中的退款原因


@end

@implementation OrderRefundViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initSubViews];
    
    [self loadRefundReasons];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //取消监听键盘事件
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma  mark -- 初始化视图方法 --
-(void)initSubViews
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = @"申请退款";
    
    //退款原因textField
    self.refundReasonField.delegate = self;
    UIImageView *rightViewReason = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 15)];
    rightViewReason.contentMode = UIViewContentModeScaleAspectFit;
    rightViewReason.image = [UIImage imageNamed:@"arrowdown"];
    self.refundReasonField.rightView = rightViewReason;
    self.refundReasonField.rightViewMode = UITextFieldViewModeAlways;
    
    //金额textField
    self.sumField.delegate = self;
    self.sumField.text = self.orderModel.wprice;
    self.sumPromptLb.text = [NSString stringWithFormat:@"(最多%@元)",self.orderModel.wprice];
    
    //退款说明的textView
    self.explainTextView.layer.borderColor = HMColor(235, 235, 235).CGColor;
    self.explainTextView.layer.borderWidth = 1.0f;
    self.explainTextView.layer.cornerRadius = 7.0f;
    self.explainTextView.layer.masksToBounds = YES;
    self.explainTextView.delegate = self;
    
    //提交按钮
    self.commitBtn.layer.borderColor = HMColor(235, 235, 235).CGColor;
    self.commitBtn.layer.borderWidth = 1.0f;
    self.commitBtn.layer.cornerRadius = 7.0f;
    self.commitBtn.layer.masksToBounds = YES;
    
}

#pragma  mark -- getter方法 --

-(NSMutableArray *)reasonsArray
{
    if (!_reasonsArray) {
        _reasonsArray = [[NSMutableArray alloc] init];
    }
    return _reasonsArray;
}

#pragma  mark -- 协议方法 --
#pragma  mark UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.currentView = textField;
    
    if (textField == self.refundReasonField) {
        
        [self showPickerView];
        
        return NO;
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.currentView = nil;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == self.sumField) {
        NSString *legalStr = @"1234567890.";
        NSCharacterSet *illegalCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:legalStr] invertedSet];
        
        NSArray * components = [string componentsSeparatedByCharactersInSet:illegalCharacterSet];
        NSString *filtered  = [components componentsJoinedByString:@""];
        BOOL result = [string isEqualToString:filtered];
        
        if (!result) {
            [NoticeHelper AlertShow:@"请输入正确的金额" view:self.view];
        }
        
        return result;
    }
    
    return YES;

}

#pragma  mark UITextViewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.currentView = textView;
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    self.currentView = nil;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView endEditing:YES];
        return NO;
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    NSString *explainTextStr = textView.text;
    if (explainTextStr == nil || explainTextStr.length == 0) {
        //没有内容时显示提示Label
        self.explainPlaceholderLb.hidden = NO;
        return;
    }
    //有内容时隐藏提示Label
    self.explainPlaceholderLb.hidden = YES;
}



#pragma  mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.reasonsArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //如果是退款理由
    RefundReasonMode *model = self.reasonsArray[row];
    return model.reason_info;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.reasonsArray.count == 0) {
        return;
    }
    //如果是退款理由
    self.selectedReasonMode = self.reasonsArray[row];
    self.refundReasonField.text = self.selectedReasonMode.reason_info;
}

#pragma  mark 事件方法
/**
 *  提交
 */
- (IBAction)commitHandle:(id)sender
{
    if (self.refundReasonField.text == nil || self.refundReasonField.text.length == 0) {
        [NoticeHelper AlertShow:@"请选择退款原因" view:self.view];
        return;
    }
    
    if (self.sumField.text == nil || self.sumField.text.length == 0) {
        [NoticeHelper AlertShow:@"请输入退款金额" view:self.view];
        return;
    }
    
    //判断输入金额是否正确
    NSString *expression = @"^\\d+\\.?\\d{0,2}$";
    
    NSPredicate *prediccate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",expression];
    BOOL result = [prediccate evaluateWithObject:self.sumField.text];
    if (!result) {
        [NoticeHelper AlertShow:@"请输入正确的金额" view:self.view];
        return;
    }else{
        
        if ([self.sumField.text floatValue] > [self.orderModel.wprice floatValue]) {
            [NoticeHelper AlertShow:@"退款金额不能大于实付金额" view:self.view];
            return;
        }
    }
    
    if (self.explainTextView.text == nil || self.explainTextView.text.length == 0) {
        [NoticeHelper AlertShow:@"请输退款说明" view:self.view];
        return;
    }
    
    [self refundAll];

}

#pragma mark 键盘相关方法
/**
 *  键盘处理方法，键盘将出现时调用
 */
-(void)keyboardWillShow:(NSNotification *)notification
{
    //获取键盘属性字典
    NSDictionary *keyboardDict = [notification userInfo];
    //获取键盘动画时间
    CGFloat duration = [[keyboardDict objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //获取动画曲线
    NSInteger curve = [[keyboardDict objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    //获取键盘frame值
    CGRect keyboardFrame = [[keyboardDict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat keyboardY = keyboardFrame.origin.y;
    
    CGFloat maxYForTextView = CGRectGetMaxY(self.currentView.frame);
    
    if (maxYForTextView > keyboardY - 30) {
        self.rootScrollview.contentInset = UIEdgeInsetsMake(0, 0,keyboardFrame.size.height , 0);
        [UIView animateWithDuration:duration delay:0 options:curve animations:^{
            
            self.rootScrollview.contentOffset = CGPointMake(0, maxYForTextView - keyboardY + 30);
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

/**
 *  键盘处理方法，键盘将隐藏时调用
 */
-(void)keyboardWillHide:(NSNotification *)notification
{
    //获取键盘属性字典
    NSDictionary *keyboardDict = [notification userInfo];
    //获取键盘动画时间
    CGFloat duration = [[keyboardDict objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //获取动画曲线
    NSInteger curve = [[keyboardDict objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    //复原View属性
    [UIView animateWithDuration:duration delay:0 options:curve animations:^{
        
        self.rootScrollview.contentOffset = CGPointMake(0, 0);
        
    } completion:^(BOOL finished) {
        self.rootScrollview.contentInset = UIEdgeInsetsMake(0, 0, 0 , 0);
    }];
}

/**
 *  点击空白处，隐藏键盘
 */
- (IBAction)backGroudViewTaped:(id)sender
{
    [self.view endEditing:YES];
}

#pragma  mark -- 选择相关(UIPickView) --
/**
 *  显示选择View
 */
-(void)showPickerView
{
    [self.view endEditing:YES];
    UIControl *bkView = [[UIControl alloc] initWithFrame:self.view.bounds];
    bkView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [bkView addTarget:self action:@selector(hidePickerView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bkView];
    
    UIPickerView *reasonPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, MTScreenH - 170, MTScreenW, 170)];
    reasonPickerView.delegate = self;
    reasonPickerView.dataSource = self;
    reasonPickerView.backgroundColor = [UIColor whiteColor];
    [bkView addSubview:reasonPickerView];
}

/**
 *  隐藏选择View
 */
-(void)hidePickerView:(UIView *)bkView
{
    UIView *pickerView = bkView.subviews[0];
    [UIView animateWithDuration:0.3 animations:^{
        pickerView.transform = CGAffineTransformTranslate(pickerView.transform, 0, 170);
    } completion:^(BOOL finished) {
        [bkView removeFromSuperview];
    }];
}

#pragma  mark -- 网络相关 --
/**
 *  向服务器获取退款理由
 */
-(void)loadRefundReasons
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [CommonRemoteHelper RemoteWithUrl:URL_Reason_list parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
        if ([dict[@"code"] integerValue] == 0) {
            
            self.reasonsArray = [RefundReasonMode objectArrayWithKeyValuesArray:dict[@"datas"]];
            //设置默认退款理由
            self.selectedReasonMode = self.reasonsArray[0];
            self.refundReasonField.text = self.selectedReasonMode.reason_info;
        }else {
            [NoticeHelper AlertShow:dict[@"errorMsg"] view:self.view];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [NoticeHelper AlertShow:@"请求失败，请检查网络" view:self.view];
    }];
}


/**
 *  全部退款
 */
-(void)refundAll
{
    NSMutableDictionary *params = [@{
                                     @"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                     @"client" : @"ios",
                                     @"wid" : self.orderModel.wid,
                                     @"buyer_message":self.explainTextView.text
                                     }mutableCopy];
    //发起请求
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_work_add_refund_all parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        if ([dict[@"code"] integerValue] == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [NoticeHelper AlertShow:dict[@"errorMsg"] view:self.view];
        }
        [HUD removeFromSuperview];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD removeFromSuperview];
        [NoticeHelper AlertShow:@"请求发送失败,请检查网络是否正常" view:self.view];

    }];
}

@end
