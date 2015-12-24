//
//  AdvertisementViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/12/8.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "AdvertisementViewController.h"
#import "HomePicModel.h"

@interface AdvertisementViewController ()
{
    UIScrollView *bgScrollview;
}

@end

@implementation AdvertisementViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavgation];
    
    [self initScrollView];
    
    [self initData];
}

-(void)initScrollView
{
    bgScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH)];
    bgScrollview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgScrollview];
}

-(void)initNavgation
{
    
    switch (self.type) {
        case 1:
            self.title = @"看护宝";
            break;
        case 2:
            self.title = @"腕表";
            break;
        case 3:
            self.title = @"心脏健康管家";
            break;
        case 4:
            self.title = @"血压仪";
            break;
        case 5:
            self.title = @"推拿理疗";
            break;
        default:
            break;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"back_icon.png"
                                                                 highImageName:@"back_icon.png"
                                                                        target:self action:@selector(back)];
}

-(void)initData
{
    HomePicModel *item = self.dataProvider[0];
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Img,item.url]];
    UIImageView *imageView = [[UIImageView alloc] init];
    
    [imageView sd_setImageWithURL:iconUrl];
    NSLog(@"%@",iconUrl);

//    CGSize size = imageView.image.size;
    //缩放比例
//    float scalePro = MTScreenW / size.width;
    imageView.x = 0;
    imageView.y = 0;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.height = 1750;
    imageView.width = MTScreenW;
    [bgScrollview addSubview:imageView];
    bgScrollview.contentSize = CGSizeMake(MTScreenW,  CGRectGetMaxY(imageView.frame));
    return;
    
//    UIImageView *lastimg;
//    
//    if (self.type > 2)
//    {
//        UIImage *img;
//        if (self.type == 3)
//            img = [UIImage imageNamed:@"heartmanager.jpg"];
//        else if (self.type == 4)
//            img = [UIImage imageNamed:@"bloodp.jpg"];
//        else if (self.type == 5)
//            img = [UIImage imageNamed:@"massage.jpg"];
//        CGSize size = img.size;
//        //缩放比例
//        float scalePro = MTScreenW / size.width;
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
//        imageView.x = 0;
//        imageView.y = CGRectGetMaxY(lastimg.frame);
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        imageView.width = MTScreenW;
//        imageView.height = size.height * scalePro;
//        
//        [bgScrollview addSubview:imageView];
//        bgScrollview.contentSize = CGSizeMake(MTScreenW,  CGRectGetMaxY(imageView.frame));
//        lastimg = imageView;
//        
//        return;
//    }
//    int max = self.type == 1 ? 6 : 8;
//    for (int i = 0; i < max; i++)
//    {
//        UIImage *img;
//        if (self.type == 1 )
//            img = [UIImage imageNamed:[NSString stringWithFormat:@"care_%d.jpg",i]];
//        else
//            img = [UIImage imageNamed:[NSString stringWithFormat:@"watch%d.jpg",i]];
//        
//        CGSize size = img.size;
//        //缩放比例
//        float scalePro = MTScreenW / size.width;
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
//        imageView.tag = i;
//        imageView.x = 0;
//        imageView.y = CGRectGetMaxY(lastimg.frame);
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        imageView.width = MTScreenW;
//        imageView.height = size.height * scalePro;
//        
//        [bgScrollview addSubview:imageView];
//        bgScrollview.contentSize = CGSizeMake(MTScreenW,  CGRectGetMaxY(imageView.frame));
//        lastimg = imageView;
//    }
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
