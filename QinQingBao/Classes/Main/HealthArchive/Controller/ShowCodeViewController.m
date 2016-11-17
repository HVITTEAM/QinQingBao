//
//  ShowCodeViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 2016/11/16.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ShowCodeViewController.h"

@interface ShowCodeViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *iconImg;
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *codeLab;

@end

@implementation ShowCodeViewController

-(void)setArchiveData:(ArchiveData *)archiveData
{
    _archiveData = archiveData;

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",archiveData.portraitPic]];
    [self.iconImg sd_setImageWithURL:url placeholderImage:[UIImage imageWithName:@"pc_user.png"]];
    self.nameLab.text = archiveData.truename;
    self.codeLab.text = [NSString stringWithFormat:@"档案号：%@",archiveData.fmno];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的二维码";
    // 1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认
    [filter setDefaults];
    // 3.给过滤器添加数据
    NSString *dataString = self.archiveData.fmno;
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    // 4.通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    // 5.将CIImage转换成UIImage，并放大显示
    self.imageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    //设置比例
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 创建bitmap（位图）;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

@end
