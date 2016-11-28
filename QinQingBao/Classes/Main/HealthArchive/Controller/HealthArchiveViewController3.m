//
//  HealthArchiveViewController3.m
//  QinQingBao
//
//  Created by 董徐维 on 2016/11/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "HealthArchiveViewController3.h"
#import "HeadProcessView.h"
#import "ReportCollectionViewCell.h"

@interface HealthArchiveViewController3 ()<UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIImage *takePhotoimg;
}

@property (nonatomic, retain) UICollectionView *colectView;

//@property (strong, nonatomic) NSMutableArray *delImages;

@end

@implementation HealthArchiveViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self setupFooter];
    
    _dataProvider = [[NSMutableArray alloc] init];
//    _delImages = [[NSMutableArray alloc] init];
    
    if (self.isAddArchive) {
        //加载缓存的图片
        for (int i = 0; i < self.archiveData.reportPhotos.count; i++) {
            NSString *path = self.archiveData.reportPhotos[i];
            NSData *data = [[NSData alloc] initWithContentsOfFile:path];
            UIImage *img = [[UIImage alloc] initWithData:data scale:1.0f];
            if (img) {
                [_dataProvider addObject:img];
            }else{
                [self.archiveData.reportPhotos removeObjectAtIndex:i];
            }
        }
    }else{
        //加载服务器上的图片地址
        [_dataProvider addObjectsFromArray:self.archiveData.medical_report];
    }
    
    //新增或者档案创建者才能修改
    if (self.isAddArchive || self.isCreator) {
        //增加新增图片按钮
        takePhotoimg = [UIImage imageNamed:@"uploadimg.png"];
        [_dataProvider addObject:takePhotoimg];
    }
}

-(void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"健康档案";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, MTScreenW, 20)];
    lab.text = @"医诊报告";
    lab.textAlignment = NSTextAlignmentLeft;
    lab.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:lab];
    
    UILabel *subLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, MTScreenW, 20)];
    subLab.text = @"医诊报告";
    subLab.textAlignment = NSTextAlignmentLeft;
    subLab.font = [UIFont systemFontOfSize:10];
    subLab.textColor = [UIColor colorWithRGB:@"999999"];
    [self.view addSubview:subLab];
    
    [self initCollectionView];
    
}

#pragma mark - 设置footer View

- (void)setupFooter
{
    HeadProcessView *headView = [[HeadProcessView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 70)];
    headView.backgroundColor = [UIColor clearColor];
    [headView initWithShowIndex:3];
    [self.view addSubview:headView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MTScreenH - 140, MTScreenW, 80)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, MTScreenW - 40, 40)];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithRGB:@"70a426"];
    btn.layer.cornerRadius = 8.0f;
    [btn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btn];
    [self.view addSubview:bottomView];
}

-(void)initCollectionView
{
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    self.colectView = [[UICollectionView alloc] initWithFrame:CGRectMake(16, 140, MTScreenW - 32, (MTScreenW - 16*4)/3*2 +20 )collectionViewLayout:flowLayout];
    self.colectView.backgroundColor = [UIColor whiteColor];
    self.colectView.collectionViewLayout = flowLayout;
    self.colectView.scrollEnabled = NO;
    [self.colectView registerNib:[UINib nibWithNibName:@"ReportCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MTReportCollectionViewCell"];
    self.colectView.delegate = self;
    self.colectView.dataSource = self;
    [self.view addSubview:self.colectView];
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.dataProvider.count > 3)
    {
        if (section == 0)
            return 3;
        else
            return self.dataProvider.count - 3;
    }
    else
        return self.dataProvider.count;
}


//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataProvider.count > 3 ? 2 : 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    __weak typeof(self) weakSelf = self;
    //重用cell
    ReportCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MTReportCollectionViewCell" forIndexPath:indexPath];
    
    //赋值
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    
    NSInteger index = indexPath.section*3 + indexPath.row;
    id pic = self.dataProvider[index];
    if ([pic isKindOfClass:[UIImage class]]) {
        imageView.image = pic;
    }else{
        [imageView sd_setImageWithURL:[[NSURL alloc] initWithString:pic?:@""] placeholderImage:[UIImage imageNamed:@"placeholderImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            if (image) {
//                [weakSelf.dataProvider replaceObjectAtIndex:index withObject:image];
//            }
        }];
    }

    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((MTScreenW - 16*4)/3, (MTScreenW - 16*4)/3);
}

/**
 *  设置横向间距 设置最小列间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

/**
 *  设置竖向间距 设置最小行间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 16;
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 0, 0);//分别为上、左、下、右
    
}

#pragma mark --UICollectionViewDelegate，

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    NSInteger index = indexPath.section*3 + indexPath.row;
    
    //只有新增或档案创建者才能修改
    if ((self.isAddArchive || self.isCreator) && self.dataProvider.count < 7 && (indexPath.section * 3 + indexPath.row == self.dataProvider.count - 1))
    {
        UIAlertView *alertPic = [[UIAlertView alloc] initWithTitle:@"请选择图片来源" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        [alertPic show];
    }
    else
    {
//        CX_Log(@"showpic");
//        SWYPhotoBrowserViewController *photoBrowser = [[SWYPhotoBrowserViewController alloc] initPhotoBrowserWithImages:self.dataProvider currentIndex:index];
//        photoBrowser.showTopBar = YES;
//        [self.navigationController presentViewController:photoBrowser animated:YES completion:nil];
        
        id img = self.dataProvider[index];
        SWYPhotoBrowserViewController *photoBrowser = nil;
        if ([img isKindOfClass:[UIImage class]]) {
            photoBrowser = [[SWYPhotoBrowserViewController alloc] initPhotoBrowserWithImages:@[img] currentIndex:0];
        }else{
            photoBrowser = [[SWYPhotoBrowserViewController alloc] initPhotoBrowserWithImageURls:@[img] currentIndex:0 placeholderImageNmae:nil];
        }
        
        photoBrowser.delImageForIndex = ^(NSInteger idxOfDel){
            //这里不能用idxOfDel,因为idxOfDel是被删除图片在图片浏览器内部图片数组中的索引.这里与self.dataProvider中图片位置是对不上的.只有传到图片浏览器中的图片数组与self.dataProvider一致时才能对上.
            
            if (weakSelf.isAddArchive) {
                [weakSelf.dataProvider removeObjectAtIndex:index];
                //删除缓存的图片
                NSString *imagePath = weakSelf.archiveData.reportPhotos[index];
                [ArchiveData deletePicFromDocumentWithPicPath:imagePath];
                [weakSelf.archiveData.reportPhotos removeObjectAtIndex:index];
                [weakSelf.archiveData saveArchiveDataToFile];
                [weakSelf.colectView reloadData];
            }else{
                [self delMedicalReportPicWithOrderNum:index];
            }
//            [weakSelf.delImages addObject:@(index)];
            
        };
        
        //只有新增或档案创建者才能修改
        if (!self.isAddArchive && !self.isCreator) {
            photoBrowser.showTopBar = NO;
        }else{
            photoBrowser.showTopBar = YES;
        }
    
        [self.navigationController presentViewController:photoBrowser animated:YES completion:nil];
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
        return;
    
    if(buttonIndex==1)
        [self shootPiicturePrVideo];
    else if(buttonIndex==2)
        [self selectExistingPictureOrVideo];
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
    NSString *picName = [NSString stringWithFormat:@"%@.jpg",currentDateStr];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        if (image.size.width > 1024 || image.size.height > 1024) {
            CGFloat bigSide = MAX(image.size.width, image.size.height);
            CGFloat scaleFactor = bigSide / 1024;
            CGSize targetSize = CGSizeMake(image.size.width / scaleFactor, image.size.height / scaleFactor);
            
            image = [image scaleImageToSize:targetSize];
            NSLog(@"%@",NSStringFromCGSize(image.size));
        }
        //保存图片
        NSData *imageData = UIImageJPEGRepresentation(image, 0.8f);
        if (self.isAddArchive) {
            NSString *filePath = [ArchiveData savePictoDocument:imageData picName:picName];
            [self.archiveData.reportPhotos addObject:filePath];
            [self.archiveData saveArchiveDataToFile];
            
            image = [[UIImage alloc] initWithData:imageData];
            
            [_dataProvider addObject:image];
            
            [_dataProvider exchangeObjectAtIndex:_dataProvider.count -1 withObjectAtIndex:_dataProvider.count -2];
            [self.colectView reloadData];
            
        }else if (self.isCreator) {
            //修改档案时,用户选择一张就上传一张
            [self addMedicalReportPicWithOrderNum:self.dataProvider.count - 1 imgData:imageData];
        }

    
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
 *  上传归档数据
 */
- (void)uploadArchiveData
{
    if ([SharedAppUtil defaultCommonUtil].userVO.key.length <= 0) {
        return;
    }
    
    NSMutableDictionary *params = [@{
                                     @"client":@"ios",
                                     @"key":[SharedAppUtil defaultCommonUtil].userVO.key,
                                     @"sys":@"2"
                                    }mutableCopy];
    
    params[@"truename"] = self.archiveData.truename;
    params[@"sex"] = self.archiveData.sex;
    params[@"birthday"] = self.archiveData.birthday;
    params[@"height"] = self.archiveData.height;
    params[@"weight"] = self.archiveData.weight;
    params[@"waistline"] = self.archiveData.waistline;
    params[@"systolicpressure"] = self.archiveData.systolicpressure;
    params[@"cholesterol"] = self.archiveData.cholesterol;
    params[@"mobile"] = self.archiveData.mobile;
    params[@"email"] = self.archiveData.email;
    params[@"address"] = self.archiveData.address;
    params[@"area_id"] = self.archiveData.area_id;
    params[@"occupation"] = self.archiveData.occupation;
    params[@"livingcondition"] = self.archiveData.livingcondition;
    params[@"units"] = self.archiveData.units;
    params[@"bremark"] = self.archiveData.bremark;
    
    params[@"physicalcondition"] = self.archiveData.physicalcondition;
    params[@"events"] = self.archiveData.events;
    params[@"takingdrugs"] = self.archiveData.takingdrugs;
    params[@"diabetes"] = self.archiveData.diabetes;
    params[@"medicalhistory"] = self.archiveData.medicalhistory;
    params[@"hereditarycardiovascular"] = self.archiveData.hereditarycardiovascular;
    params[@"geneticdisease"] = self.archiveData.geneticdisease;
    params[@"dremark"] = self.archiveData.dremark;
    
    
    params[@"smoke"] = self.archiveData.smoke;
    params[@"drink"] = self.archiveData.drink;
    if (self.archiveData.diet) {
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:self.archiveData.diet options:0 error:&error];
        params[@"diet"] = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    params[@"sleeptime"] = self.archiveData.sleeptime;
    params[@"getuptime"] = self.archiveData.getuptime;
    params[@"sports"] = self.archiveData.sports;
    params[@"badhabits"] = self.archiveData.badhabits;
    params[@"hremark"] = self.archiveData.hremark;
    

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    //医诊图片
    NSMutableArray *tempArrays = [[NSMutableArray alloc] init];
    NSMutableDictionary *tempDict = nil;
    for (int i = 0; i < self.dataProvider.count - 1; i++) {
        if ([self.dataProvider[i] isKindOfClass:[NSString class]]) {
            continue;
        }
        tempDict = [[NSMutableDictionary alloc] init];
        tempDict[@"name"] = [NSString stringWithFormat:@"medical_report_%d",i+1];
        tempDict[@"fileName"] = [NSString stringWithFormat:@"medical_report_%@_%d.jpg",currentDateStr,i];
        tempDict[@"mimeType"] = @"image/jpeg";
        UIImage *tempImage = self.dataProvider[i];
        NSData *data = UIImageJPEGRepresentation(tempImage, 0.8f);
        tempDict[@"fileData"] = data;
        [tempArrays addObject:tempDict];
    }
    //头像数据
    if (self.archiveData.avatarImage) {
        tempDict = [[NSMutableDictionary alloc] init];
        tempDict[@"name"] = @"avatar";
        tempDict[@"fileName"] = [NSString stringWithFormat:@"basic_avatar_%@.jpg",currentDateStr];
        tempDict[@"mimeType"] = @"image/jpeg";
        NSData *data = UIImageJPEGRepresentation(self.archiveData.avatarImage, 0.8f);
        tempDict[@"fileData"] = data;
        [tempArrays addObject:tempDict];
    }

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    [CommonRemoteHelper UploadPicWithUrl:URL_Add_fm parameters:params images:tempArrays success:^(NSDictionary *dict, id responseObject) {
        
        [hud removeFromSuperview];
        
        if([dict[@"code"] integerValue] != 0){
            [NoticeHelper AlertShow:dict[@"errorMsg"] view:nil];
            return;
        }
        
        [NoticeHelper AlertShow:@"成功" view:nil];
        if (self.isAddArchive) {
            [self.archiveData deleteArchiveData];
        }
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud removeFromSuperview];
        [NoticeHelper AlertShow:@"请求出错" view:nil];
    }];
}

/**
 *  修改传归档数据后重新上传
 */
- (void)editArchiveData
{
    if ([SharedAppUtil defaultCommonUtil].userVO.key.length <= 0) {
        return;
    }
    
    NSMutableDictionary *params = [@{
                                     @"client":@"ios",
                                     @"key":[SharedAppUtil defaultCommonUtil].userVO.key,
                                     @"sys": @"2",
                                     @"fmno":self.archiveData.fmno
                                     }mutableCopy];
    
    params[@"truename"] = self.archiveData.truename;
    params[@"sex"] = self.archiveData.sex;
    params[@"birthday"] = self.archiveData.birthday;
    params[@"height"] = self.archiveData.height;
    params[@"weight"] = self.archiveData.weight;
    params[@"waistline"] = self.archiveData.waistline;
    params[@"systolicpressure"] = self.archiveData.systolicpressure;
    params[@"cholesterol"] = self.archiveData.cholesterol;
    params[@"mobile"] = self.archiveData.mobile;
    params[@"email"] = self.archiveData.email;
    params[@"address"] = self.archiveData.address;
    params[@"area_id"] = self.archiveData.area_id;
    params[@"occupation"] = self.archiveData.occupation;
    params[@"livingcondition"] = self.archiveData.livingcondition;
    params[@"units"] = self.archiveData.units;
    params[@"bremark"] = self.archiveData.bremark;
    
    params[@"physicalcondition"] = self.archiveData.physicalcondition;
    params[@"events"] = self.archiveData.events;
    params[@"takingdrugs"] = self.archiveData.takingdrugs;
    params[@"diabetes"] = self.archiveData.diabetes;
    params[@"medicalhistory"] = self.archiveData.medicalhistory;
    params[@"hereditarycardiovascular"] = self.archiveData.hereditarycardiovascular;
    params[@"geneticdisease"] = self.archiveData.geneticdisease;
    params[@"dremark"] = self.archiveData.dremark;
    
    
    params[@"smoke"] = self.archiveData.smoke;
    params[@"drink"] = self.archiveData.drink;
    if (self.archiveData.diet) {
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:self.archiveData.diet options:0 error:&error];
        params[@"diet"] = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    params[@"sleeptime"] = self.archiveData.sleeptime;
    params[@"getuptime"] = self.archiveData.getuptime;
    params[@"sports"] = self.archiveData.sports;
    params[@"badhabits"] = self.archiveData.badhabits;
    params[@"hremark"] = self.archiveData.hremark;
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    //医诊图片
    NSMutableArray *tempArrays = [[NSMutableArray alloc] init];
    NSMutableDictionary *tempDict = nil;
    //头像数据
    if (self.archiveData.avatarImage) {
        tempDict = [[NSMutableDictionary alloc] init];
        tempDict[@"name"] = @"avatar";
        tempDict[@"fileName"] = [NSString stringWithFormat:@"basic_avatar_%@.jpg",currentDateStr];
        tempDict[@"mimeType"] = @"image/jpeg";
        NSData *data = UIImageJPEGRepresentation(self.archiveData.avatarImage, 0.8f);
        tempDict[@"fileData"] = data;
        [tempArrays addObject:tempDict];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    [CommonRemoteHelper UploadPicWithUrl:URL_Edit_fm parameters:params images:tempArrays success:^(NSDictionary *dict, id responseObject) {
        
        [hud removeFromSuperview];
        
        if([dict[@"code"] integerValue] != 0){
            [NoticeHelper AlertShow:dict[@"errorMsg"] view:nil];
            return;
        }
        
        [NoticeHelper AlertShow:@"成功" view:nil];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud removeFromSuperview];
        [NoticeHelper AlertShow:@"请求出错" view:nil];
    }];
}


/**
 *  新增医疗报告图片
 *  orderNum : 新增图片在dataProvider数组中的序号
 */
- (void)addMedicalReportPicWithOrderNum:(NSInteger)orderNum imgData:(NSData *)imageData
{
    if (imageData.length <= 0) {
        [NoticeHelper AlertShow:@"缺少图片" view:nil];
        return;
    }
    
    NSMutableDictionary *params = [@{
                                     @"client":@"ios",
                                     @"key":[SharedAppUtil defaultCommonUtil].userVO.key,
                                     @"sys":@"2"
                                     }mutableCopy];
    params[@"fmno"] = self.archiveData.fmno;
    //新增的医诊图片
    NSMutableArray *tempArrays = [[NSMutableArray alloc] init];
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    tempDict[@"name"] = @"new_medical_report";
    tempDict[@"fileName"] = @"medical_report_new.jpg";
    tempDict[@"mimeType"] = @"image/jpeg";
    tempDict[@"fileData"] = imageData;
    [tempArrays addObject:tempDict];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [CommonRemoteHelper UploadPicWithUrl:URL_Add_medical_report_item parameters:params images:tempArrays success:^(NSDictionary *dict, id responseObject) {
        [hud removeFromSuperview];
        if([dict[@"code"] integerValue] != 0){
            [NoticeHelper AlertShow:[NSString stringWithFormat:@"%@",dict[@"errorMsg"]] view:nil];
            return;
        }
        
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        
        [self.dataProvider addObject:image];
        
        [self.dataProvider exchangeObjectAtIndex:_dataProvider.count -1 withObjectAtIndex:_dataProvider.count -2];
        [self.colectView reloadData];
//        [NoticeHelper AlertShow:[NSString stringWithFormat:@"成功第%d",(int)orderNum + 1] view:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud removeFromSuperview];
        [NoticeHelper AlertShow:[NSString stringWithFormat:@"上传失败,请检查网络"] view:nil];
    }];
}

/**
 *  删除医疗报告图片
 *  orderNum : 在dataProvider数组中的序号
 */
- (void)delMedicalReportPicWithOrderNum:(NSInteger)orderNum
{
    NSMutableDictionary *params = [@{
                                     @"client":@"ios",
                                     @"key":[SharedAppUtil defaultCommonUtil].userVO.key,
                                     @"sys":@"2"
                                     }mutableCopy];
    params[@"fmno"] = self.archiveData.fmno;
    params[@"del_medical_report"] = @(orderNum + 1);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Del_medical_report_item parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        [hud removeFromSuperview];
        
        if ([dict[@"code"] integerValue] != 0) {
            [NoticeHelper AlertShow:[NSString stringWithFormat:@"%@",dict[@"errorMsg"]] view:nil];
        }
    
        [self.dataProvider removeObjectAtIndex:orderNum];
        
        [self.colectView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud removeFromSuperview];
        [NoticeHelper AlertShow:@"删除图片失败,请检查网络" view:nil];
    }];
}

#pragma mark - 事件方法
- (void)next:(UIButton *)sender
{
    //不是新增,也不是档案创建者
    if (!self.isAddArchive && !self.isCreator) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if (self.isAddArchive){
        [self uploadArchiveData];
    }else{
        [self editArchiveData];
    }
}

@end
