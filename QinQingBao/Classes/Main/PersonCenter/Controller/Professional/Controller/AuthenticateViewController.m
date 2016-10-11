//
//  AuthenticateViewController.m
//  QinQingBao
//
//  Created by shi on 16/10/10.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "AuthenticateViewController.h"
#import "InputFieldViewController.h"
#import "AbilityCell.h"
#import "AuthenticateResultController.h"
#import "ExpertModel.h"
#import "JobSelectView.h"
#import "RSKImageCropViewController.h"

@interface AuthenticateViewController ()<UIAlertViewDelegate,RSKImageCropViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) NSArray *dataProvider;

@property (strong, nonatomic) NSArray *expertDatas;
//当前操作的cell的NSIndexPath
@property (strong, nonatomic) NSIndexPath *currentIdx;
//选中的性别
@property (strong, nonatomic) NSNumber *selectedSex;
//选中的专家数据
@property (strong, nonatomic) ExpertModel *selectedExpertModel;
//选中的图片数据
@property (strong, nonatomic) NSData *selectedPicData;

@end

@implementation AuthenticateViewController

- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"申请专家认证";

    NSMutableDictionary *dict1 = [@{@"title" : @"",@"placeholder" : @"",@"text" : @"头像",@"value" : @"自己真实照片"}mutableCopy];
    NSMutableDictionary *dict2 = [@{@"title" : @"修改姓名",@"placeholder" : @"请输入姓名",@"text" : @"姓名", @"value" : @""}mutableCopy];
    NSMutableDictionary *dict3 = [@{@"title" : @"选择性别",@"placeholder" : @"请选择",@"text" : @"性别", @"value" : @""}mutableCopy];
    NSMutableDictionary *dict4 = [@{@"title" : @"修改身份证号",@"placeholder" : @"请输入身份证号",@"text" : @"身份证号", @"value" : @""}mutableCopy];
    NSMutableDictionary *dict5 = [@{@"title" : @"修改所属单位",@"placeholder" : @"请输入所属单位",@"text" : @"所属单位", @"value" : @""}mutableCopy];
    NSMutableDictionary *dict6 = [@{@"title" : @"选择职称",@"placeholder" : @"请输入职称",@"text" : @"职称", @"value" : @""}mutableCopy];
    NSMutableDictionary *dict7 = [@{@"title" : @"",@"placeholder" : @"请填写",@"text" : @"擅长领域", @"value" : @""}mutableCopy];
    
    
    
    self.dataProvider = [[NSMutableArray alloc] initWithObjects:
                          [@[dict1]mutableCopy],
                          [@[dict2,dict3,dict4]mutableCopy],
                          [@[dict5,dict6,dict7]mutableCopy],nil];
    
    [self setupFooter];
    
    [self loadExpertListDatas];
}

- (void)setupFooter
{
    //提交按钮
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 70)];
    bgview.backgroundColor = [UIColor clearColor];
    
    UIButton *logout = [[UIButton alloc] init];
    logout.frame = CGRectMake(20, 20, MTScreenW - 40, 45);
    logout.titleLabel.font = [UIFont systemFontOfSize:16];
    [logout setTitle:@"提交" forState:UIControlStateNormal];
    [logout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logout setBackgroundColor:HMColor(145, 181, 45)];
    logout.layer.cornerRadius = 6.0f;
    [logout addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:logout];
    
    self.tableView.tableFooterView = bgview;
}

- (NSArray *)expertDatas
{
    if (!_expertDatas) {
        _expertDatas = [[NSArray alloc] init];
    }
    
    return _expertDatas;
}

#pragma mark - 协议方法
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataProvider.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = self.dataProvider[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    static NSString *portraitCellId = @"portraitCell";
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        UITableViewCell *portraitCell = [tableView dequeueReusableCellWithIdentifier:portraitCellId];
        if (!portraitCell) {
            portraitCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:portraitCellId];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.width = 50;
            imageView.height = 50;
            imageView.layer.cornerRadius = imageView.height/2;
            imageView.backgroundColor = HMColor(230, 230, 230);
            imageView.layer.masksToBounds = YES;
            portraitCell.accessoryView = imageView;
            portraitCell.detailTextLabel.numberOfLines = 0;
        }
        
        NSDictionary *dict = self.dataProvider[indexPath.section][indexPath.row];
        portraitCell.textLabel.text = [dict objectForKey:@"text"];
        portraitCell.detailTextLabel.text = [NSString stringWithFormat:@"\n%@",[dict objectForKey:@"value"]];
        UIImageView *img = (UIImageView *)portraitCell.accessoryView;
        img.image = [UIImage imageWithData:self.selectedPicData];

        cell = portraitCell;
        
    }else if (indexPath.section == 2 && indexPath.row == 2){
        AbilityCell *abilityCell = [AbilityCell createCellWithTableView:tableView];
        NSMutableDictionary *dict = self.dataProvider[indexPath.section][indexPath.row];
        abilityCell.dict = dict;
        abilityCell.textDidChangeCallBack = ^(NSString *content){
            weakSelf.dataProvider[indexPath.section][indexPath.row][@"value"] = content;
        };
        
        cell = abilityCell;
    }else{
        UITableViewCell *otherCell = [tableView dequeueReusableCellWithIdentifier:@"other"];
        if (!otherCell) {
            otherCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"other"];
        }
        
        NSDictionary *dict = self.dataProvider[indexPath.section][indexPath.row];
        otherCell.textLabel.text = [dict objectForKey:@"text"];
        
        NSString *valueStr = dict[@"value"];
        otherCell.detailTextLabel.text = valueStr.length>0?valueStr:dict[@"placeholder"];
        
        cell = otherCell;
    }
    
    cell.textLabel.textColor = HMColor(51, 51, 51);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 70;
    }else if (indexPath.section == 2 && indexPath.row == 2){
        return 120;
    }else{
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    self.currentIdx = indexPath;
    
    if (indexPath.section == 0) {
        
        UIAlertView *alertPic = [[UIAlertView alloc] initWithTitle:@"请选择图片来源" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        alertPic.tag = 101;
        [alertPic show];
        
    }else if (indexPath.section == 1 && indexPath.row == 1) {
        
        UIAlertView *alertSex = [[UIAlertView alloc] initWithTitle:@"请选择性别" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"男",@"女",@"保密", nil];
        alertSex.tag = 99;
        [alertSex show];
        
        
    }else if (indexPath.section == 2 && indexPath.row == 1){
        JobSelectView *selectV = [JobSelectView showJobSelectViewWithdatas:self.expertDatas];
        NSMutableDictionary *dict = self.dataProvider[indexPath.section][indexPath.row];
        selectV.selectCompleteCallBack = ^(ExpertModel *item){
            weakSelf.selectedExpertModel = item;
            dict[@"value"] = item.grouptitle;
            [weakSelf.tableView reloadData];
        };
        
    }else{
        
        InputFieldViewController *inputVC = [[InputFieldViewController alloc] init];
        inputVC.dict = self.dataProvider[indexPath.section][indexPath.row];
        inputVC.idx = indexPath;
        inputVC.completeCallBack = ^(NSMutableDictionary *dict, NSIndexPath *idx){
            weakSelf.dataProvider[idx.section][idx.row] = dict;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[idx] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:inputVC animated:YES];
    }

}


#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    
    if (alertView.tag > 100)
    {
        if(buttonIndex==1)
            [self shootPiicturePrVideo];
        else if(buttonIndex==2)
            [self selectExistingPictureOrVideo];
        
    }else if(self.currentIdx){
        NSMutableDictionary *dict = self.dataProvider[self.currentIdx.section][self.currentIdx.row];
        self.selectedSex = @(buttonIndex);
        switch (buttonIndex) {
            case 1:
                dict[@"value"] = @"男";
                break;
            case 2:
                dict[@"value"] = @"女";
                break;
            default:
                dict[@"value"] = @"保密";
                break;
        }
        
        [self.tableView reloadData];
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
    self.selectedPicData = data;
    [self.navigationController popViewControllerAnimated:YES];
    [self.tableView reloadData];
}


#pragma mark - 拍照模块
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

#pragma mark
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

#pragma mark - 网络相关
/**
 *  提交申请
 */
- (void)commitAction
{
    //判断是否登录
    if (![SharedAppUtil checkLoginStates]) {
        return;
    }
    
    //判断字段是否为空
    for (int i = 0; i < self.dataProvider.count; i++) {
        NSMutableArray *temps =  self.dataProvider[i];
        for (int j = 0; j < temps.count ; j++) {
           NSString *valuesStr =  temps[j][@"value"];
            if (valuesStr.length <=0) {
                [NoticeHelper AlertShow:[NSString stringWithFormat:@"%@不能为空",temps[j][@"text"]] view:nil];
                return;
            }
        }
    }
    
    //判断头像是否为空
    if (self.selectedPicData.length <= 0) {
        [NoticeHelper AlertShow:@"头像不能为空" view:nil];
        return;
    }
    
    NSMutableDictionary *params = [@{
                                     @"uid":[SharedAppUtil defaultCommonUtil].bbsVO.BBS_Member_id,
                                     @"client":@"ios",
                                     @"key":[SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key
                                     }mutableCopy];
    params[@"gid"] = self.selectedExpertModel.groupid;
    params[@"truename"] = self.dataProvider[1][0][@"value"];
    params[@"sex"] = self.selectedSex;
    params[@"identity_card"] = self.dataProvider[1][2][@"value"];
    params[@"company"] = self.dataProvider[2][0][@"value"];
    params[@"skilled_field"] = self.dataProvider[2][2][@"value"];
    params[@"sys"] = @4;
    
    //创建图片数据
    NSDictionary *picInfoDict = @{
                                  @"fileData" : self.selectedPicData,
                                  @"name" : @"Filedata",
                                  @"fileName" : @"expertImg.png",
                                  @"mimeType" : @"image/png"
                                };
   
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper UploadPicWithUrl:URL_expert_apply parameters:params images:@[picInfoDict] success:^(NSDictionary *dict, id responseObject) {
        [HUD removeFromSuperview];
        AuthenticateResultController *resultVC = [[AuthenticateResultController alloc] init];
        if([[dict objectForKey:@"code"] integerValue] > 0){
            resultVC.isSuccess = NO;
            resultVC.msg = @"抱歉,您的认证未通过!";
            resultVC.reason = dict[@"errorMsg"];
            
        }else{
            resultVC.isSuccess = YES;
            resultVC.msg = dict[@"datas"][@"message"];
        }
        
        [self.navigationController pushViewController:resultVC animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD removeFromSuperview];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请求发送失败,请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }];
}

/**
 *  获取专家列表
 */
- (void)loadExpertListDatas
{
    [CommonRemoteHelper RemoteWithUrl:URL_Get_expert_list parameters:nil type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {

        if([[dict objectForKey:@"code"] integerValue] > 0){
            CX_Log(@"获取专家列表出错");
            
        }else{
            self.expertDatas = [ExpertModel objectArrayWithKeyValuesArray:dict[@"datas"]];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];

}

@end
