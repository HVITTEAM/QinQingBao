//
//  RefundViewController.m
//  QinQingBao
//
//  Created by shi on 16/2/25.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "RefundViewController.h"
#import "RefundReasonMode.h"
#import "ExtendOrderGoodsModel.h"

@interface RefundViewController ()<UITextFieldDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;      //contentView 的高约束

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *refundReasonToSuperTopCons;  //退款理由textField到contentView顶部距离约束

@property (weak, nonatomic) IBOutlet UIScrollView *rootScrollview;    //滚动用的Scrollview

@property (weak, nonatomic) IBOutlet UITextField *refundTypeField;     //退款类型的textField

@property (weak, nonatomic) IBOutlet UILabel *refundTypeTitleLb;      //退款类型的标题Label

@property (weak, nonatomic) IBOutlet UITextField *refundReasonField;         //退款原因的textField

@property (weak, nonatomic) IBOutlet UITextField *sumField;            //金额的textField

@property (weak, nonatomic) IBOutlet UILabel *sumPromptLb;              //金额的提示label

@property (weak, nonatomic) IBOutlet UITextView *explainTextView;       //退款说明的textView

@property (weak, nonatomic) IBOutlet UILabel *explainPlaceholderLb;     //退款说明的提示label

@property (weak, nonatomic) IBOutlet UIView *photoView;                 //拍照view

@property (weak, nonatomic) IBOutlet UILabel *photoPlaceholderLb;       //拍照的提示label

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;               //提交按钮


@property (strong,nonatomic)UIView *currentView;              //当前编辑的文本 view

@property (strong,nonatomic)NSMutableArray *photosArray;      //存放UIImage对象的数组

@property (strong,nonatomic)NSMutableArray *imgViewsArray;    //存放UIImageView对象的数组

@property (strong,nonatomic)NSMutableArray *reasonsArray;    //存放退款原因的数组

@property (strong,nonatomic)NSMutableArray *typesArray;      //存放退款类型的数组

@property (strong,nonatomic)RefundReasonMode *selectedReasonMode;    //选中的退款原因

@property (strong,nonatomic)NSDictionary *selectedTypeDict;      //选中退款类型   //id:1为退款,id:2为退货
  //@{@"typeid":@"1",@"typeContent":@"仅退款"},
 //@{@"typeid":@"2",@"typeContent":@"退货退款"}

@end

@implementation RefundViewController

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
    
    self.navigationItem.title = @"申请退款";
    
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
    
    //设置contentView 的高约束也就是设置设置了 UIScrollView 的ContentSize
    if (MTScreenH <= 568) {
        //5s 或 4s 则高度设置 5s 屏幕的高
        self.heightConstraint.constant = 568;
    }else{
        //其它则设置为当前屏幕的高
        self.heightConstraint.constant = MTScreenH;
    }
    //设置隐藏或显示退款类型
    if (self.isShowRefundType) {
        self.refundReasonToSuperTopCons.constant = 95;
        self.refundTypeField.hidden = NO;
        self.refundTypeTitleLb.hidden = NO;
    }else{
        self.refundReasonToSuperTopCons.constant = 15;
        self.refundTypeField.hidden = YES;
        self.refundTypeTitleLb.hidden = YES;
    }
    
    //退款类型textField
    self.refundTypeField.delegate = self;
    UIImageView *rightViewType = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 15)];
    rightViewType.contentMode = UIViewContentModeScaleAspectFit;
    rightViewType.image = [UIImage imageNamed:@"arrowdown"];
    self.refundTypeField.rightView = rightViewType;
    self.refundTypeField.rightViewMode = UITextFieldViewModeAlways;
    //设置默认值
    self.selectedTypeDict = self.typesArray[0];   //默认为退款
    self.refundTypeField.text = self.selectedTypeDict[@"typeContent"];
    
    //退款原因textField
    self.refundReasonField.delegate = self;
    UIImageView *rightViewReason = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 15)];
    rightViewReason.contentMode = UIViewContentModeScaleAspectFit;
    rightViewReason.image = [UIImage imageNamed:@"arrowdown"];
    self.refundReasonField.rightView = rightViewReason;
    self.refundReasonField.rightViewMode = UITextFieldViewModeAlways;
    
    //金额textField
    self.sumField.delegate = self;
    self.sumField.text = self.orderInfo.order_amount;
    self.sumPromptLb.text = [NSString stringWithFormat:@"(最多%@元，含发货邮费%@元)",self.orderInfo.order_amount,self.orderInfo.shipping_fee];
    
    //退款说明的textView
    self.explainTextView.layer.borderColor = HMColor(235, 235, 235).CGColor;
    self.explainTextView.layer.borderWidth = 1.0f;
    self.explainTextView.layer.cornerRadius = 7.0f;
    self.explainTextView.layer.masksToBounds = YES;
    self.explainTextView.delegate = self;
    
    //拍照view
    self.photoView.layer.borderColor = HMColor(235, 235, 235).CGColor;
    self.photoView.layer.borderWidth = 1.0f;
    self.photoView.layer.cornerRadius = 7.0f;
    self.photoView.layer.masksToBounds = YES;
    
    //提交按钮
    self.commitBtn.layer.borderColor = HMColor(235, 235, 235).CGColor;
    self.commitBtn.layer.borderWidth = 1.0f;
    self.commitBtn.layer.cornerRadius = 7.0f;
    self.commitBtn.layer.masksToBounds = YES;
    
}

#pragma  mark -- getter方法 --
-(NSMutableArray *)photosArray
{
    if (!_photosArray) {
        _photosArray = [[NSMutableArray alloc] init];
    }
    return _photosArray;
}

-(NSMutableArray *)imgViewsArray
{
    if (!_imgViewsArray) {
        _imgViewsArray = [[NSMutableArray alloc] init];
    }
    return _imgViewsArray;
}

-(NSMutableArray *)reasonsArray
{
    if (!_reasonsArray) {
        _reasonsArray = [[NSMutableArray alloc] init];
    }
    return _reasonsArray;
}

/**
 *  设置类型数组
 */
-(NSMutableArray *)typesArray
{
    if (!_typesArray) {
        _typesArray = [@[
                         @{@"typeid":@"1",@"typeContent":@"仅退款"},
                         @{@"typeid":@"2",@"typeContent":@"退货退款"}
                           ]mutableCopy];
    }
    return _typesArray;
}

#pragma  mark -- 协议方法 --
#pragma  mark UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.currentView = textField;
    
    if (textField == self.refundTypeField || textField == self.refundReasonField) {
        
        [self showPickerView];

        return NO;
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.currentView = nil;
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
    if (self.currentView == self.refundTypeField) {
        return self.typesArray.count;
    }
    return self.reasonsArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.currentView == self.refundTypeField) {
       NSDictionary *typedict = self.typesArray[row];
       return typedict[@"typeContent"];
    }
    //如果是退款理由
    RefundReasonMode *model = self.reasonsArray[row];
    return model.reason_info;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.currentView == self.refundTypeField) {
        self.selectedTypeDict = self.typesArray[row];
        self.refundTypeField.text = self.selectedTypeDict[@"typeContent"];
        return;
    }
    //如果是退款理由
    self.selectedReasonMode = self.reasonsArray[row];
    self.refundReasonField.text = self.selectedReasonMode.reason_info;
}

#pragma  mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            [self selectPhotosFromAlbum];
            break;
        case 2:
            [self takePhotos];
            break;
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *imageNoZip = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *data;
    data = UIImageJPEGRepresentation(imageNoZip, 0.000005);//压缩图片
    [self.photosArray addObject:data];
    [self showPhotosToPhotoView];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  从相册中选取
 */
-(void)selectPhotosFromAlbum
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

/**
 *  拍照
 */
-(void)takePhotos
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    picker.delegate = self;
    
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
        picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }else{
        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma  mark -- 事件方法 --
/**
 *  获取照片
 */
- (IBAction)fetchPhotos:(id)sender
{
    if (self.photosArray.count == 3) {
        [[[UIAlertView alloc] initWithTitle:@"最多只能上传三张图片" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return;
    }
    [[[UIAlertView alloc] initWithTitle:@"选择图片来源" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"从相册选择",@"拍照", nil] show];
}

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
    
    if (self.explainTextView.text == nil || self.explainTextView.text.length == 0) {
        [NoticeHelper AlertShow:@"请输退款说明" view:self.view];
        return;
    }
    if ([self.orderInfo.order_state isEqualToString:@"20"])
    {
        [self refundAll];
    }
    else if ([self.orderInfo.order_state isEqualToString:@"30"]){
        if (self.refundTypeField.text == nil || self.refundTypeField.text.length == 0) {
            [NoticeHelper AlertShow:@"请选择退款类型" view:self.view];
            return;
        }
        [self refundPart];
    }
    if ([self.orderInfo.order_state isEqualToString:@"30"]) {
        
        if (self.refundTypeField.text == nil || self.refundTypeField.text.length == 0) {
            [NoticeHelper AlertShow:@"请选择退款类型" view:self.view];
            return;
        }
    }
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

#pragma  mark -- 内部方法照片相关 --
/**
 *  设置photoView，把获得的照片显示到界面上
 */
-(void)showPhotosToPhotoView
{
    if (self.photosArray.count <= 0) {
        //如果没有要显示的图片就显示提示文字
        self.photoPlaceholderLb.hidden = NO;
        return;
    }
    
    self.photoPlaceholderLb.hidden = YES;
    CGFloat photoViewH = self.photoView.frame.size.height;
    CGFloat photoViewW = self.photoView.frame.size.width;
    //图片view的宽高
    CGFloat imgViewH = photoViewH - 10;
    CGFloat imgViewW = imgViewH;
    //间距
    CGFloat margin = 10;
    
    //计算还差多少个imageView,并创建它们
    for (int i = 0; i < self.photosArray.count - self.imgViewsArray.count; ++i) {
        UIImageView *imgView = [[UIImageView alloc] init];
        [self.photoView addSubview:imgView];

        //添加手势
        imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deletePhoto:)];
        recognizer.numberOfTapsRequired = 1;
        recognizer.numberOfTouchesRequired = 1;
        [imgView addGestureRecognizer:recognizer];

        //添加小圆点
        UIImageView *delete = [[UIImageView alloc] initWithFrame:CGRectMake(imgViewW -10, -5, 15, 15)];
        delete.image = [UIImage imageNamed:@"main_badge"];
        [imgView addSubview:delete];

        //放到数组中
        [self.imgViewsArray addObject:imgView];
    }
    
    //设置位置,并设置图片
    for (int i = 0; i < self.imgViewsArray.count; ++i) {
        UIImageView *imgView = self.imgViewsArray[i];
        UIImage *theImage = [[UIImage alloc] initWithData:self.photosArray[i]];
        imgView.image = theImage;
        [UIView animateWithDuration:0.3 animations:^{
            imgView.frame = CGRectMake(photoViewW - (i+1) * (imgViewW + margin), (photoViewH - imgViewH)/2, imgViewW, imgViewH);
        }];
    }
}

/**
 *  删除照片
 */
-(void)deletePhoto:(UITapGestureRecognizer *)recognizer
{
    //获得要删除的imageView并从界面中删除
    UIImageView *v = (UIImageView *)[recognizer view];
    [v removeFromSuperview];
    
    //删除UIImageView数组中的view和UIImage数组中的image对象
    NSInteger delIndex = [self.imgViewsArray indexOfObject:v];
    [self.photosArray removeObjectAtIndex:delIndex];
    [self.imgViewsArray removeObjectAtIndex:delIndex];
    
    //对剩下的imageView重新设置位置
    [self showPhotosToPhotoView];
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
    [params setValue:self.orderInfo.order_state forKey:@"state_value"];
    
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
                                     @"order_id" : self.orderInfo.order_id,
                                     @"buyer_message":self.explainTextView.text
                                    }mutableCopy];

    //创建图片数组
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.photosArray.count; ++i ) {
        
        NSString *name = [NSString stringWithFormat:@"refund_pic%d",i+1];
        NSString *filename = [NSString stringWithFormat:@"img%d",i+1];
        
        NSDictionary *imageDict = @{
                                    @"fileData":self.photosArray[i],
                                    @"name":name,
                                    @"fileName":filename,
                                    @"mimeType":@"image/png",
                                    };
        [imageArray addObject:imageDict];
    }
    //发起请求
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper UploadPicWithUrl:URL_Refund_all parameters:params  images:imageArray success:^(NSDictionary *dict, id responseObject) {
        [HUD removeFromSuperview];

        if ([dict[@"code"] integerValue] == 0) {
           [self.navigationController popViewControllerAnimated:YES];
        }else if ([dict[@"code"] integerValue] == 11010){
            [NoticeHelper AlertShow:dict[@"errorMsg"] view:self.view];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD removeFromSuperview];
        [NoticeHelper AlertShow:@"请求失败" view:self.view];
    }];
}

/**
 *  部分退款
 */
-(void)refundPart
{
    NSMutableDictionary *params = [@{ @"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                     @"client" : @"ios",
                                     @"order_id" : self.orderInfo.order_id,
                                     @"buyer_message":self.explainTextView.text,
                                     @"goods_id":self.orderGoodsModel.rec_id,
                                     @"refund_amount":self.sumField.text,
                                     @"reason_id":self.selectedReasonMode.reason_id,
                                     @"refund_type":self.selectedTypeDict[@"typeid"],
                                     @"goods_num" : @1}mutableCopy];
    
    if ([self.selectedTypeDict[@"typeid"] isEqualToString:@"1"]) {
        //取消goods_num这个 key-value
        [params setValue:nil forKey:@"goods_num"];
    }else{
        //设置goods_num这个 key-value
        [params setValue:@"1" forKey:@"goods_num"];
    }
    
    //创建图片数组
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.photosArray.count; ++i ) {
        
        NSString *name = [NSString stringWithFormat:@"refund_pic%d",i+1];
        NSString *filename = [NSString stringWithFormat:@"img%d",i+1];
        
        NSDictionary *imageDict = @{
                                    @"fileData":self.photosArray[i],
                                    @"name":name,
                                    @"fileName":filename,
                                    @"mimeType":@"image/png",
                                    };
        [imageArray addObject:imageDict];
    }
    //发起请求
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper UploadPicWithUrl:URL_Add_refund parameters:params  images:imageArray success:^(NSDictionary *dict, id responseObject) {
        
        NSLog(@"%@",dict);
        [HUD removeFromSuperview];

        if (dict && [dict[@"code"] integerValue] == 0) {
            //TODO 转到退款详情
            [self.navigationController popViewControllerAnimated:YES];
            
        }else {
            [NoticeHelper AlertShow:dict[@"errorMsg"] view:self.view];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD removeFromSuperview];
        [NoticeHelper AlertShow:@"请求失败" view:self.view];
    }];
}

@end



