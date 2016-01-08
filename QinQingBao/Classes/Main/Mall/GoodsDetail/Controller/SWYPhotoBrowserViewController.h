//
//  SWYPhotoBrowserViewController.h
//  EQ_DisasterReport
//
//  Created by shi on 15/11/5.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWYPhotoBrowserViewController : UIViewController

/**
 * 根据图片名字
 */
-(instancetype)initPhotoBrowserWithImageNames:(NSArray *)imageNames currentIndex:(NSInteger)currentIndex;

/**
 * 根据图片的UIImage对象
 */
-(instancetype)initPhotoBrowserWithImages:(NSArray *)images currentIndex:(NSInteger)currentIndex;

/**
 * 根据图片的URL字符串
 */
-(instancetype)initPhotoBrowserWithImageURls:(NSArray *)imageURLs currentIndex:(NSInteger)currentIndex placeholderImageNmae:(NSString *)placeholderImageName;
@end
