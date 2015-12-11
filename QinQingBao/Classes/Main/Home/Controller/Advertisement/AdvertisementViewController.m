//
//  AdvertisementViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/12/8.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "AdvertisementViewController.h"

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
    self.title = self.type == 1 ? @"看护宝" :@"腕表";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"back_icon.png"
                                                                 highImageName:@"back_icon.png"
                                                                        target:self action:@selector(back)];
}

-(void)initData
{
    UIImageView *lastimg;
    int max = self.type == 1 ? 6 : 8;
    for (int i = 0; i < max; i++)
    {
        UIImage *img;
        if (self.type == 1 )
            img = [UIImage imageNamed:[NSString stringWithFormat:@"care_%d.jpg",i]];
        else
            img = [UIImage imageNamed:[NSString stringWithFormat:@"watch%d.jpg",i]];

        CGSize size = img.size;
        //缩放比例
        float scalePro = MTScreenW / size.width;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
        imageView.tag = i;
        imageView.x = 0;
        imageView.y = CGRectGetMaxY(lastimg.frame);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.width = MTScreenW;
        imageView.height = size.height * scalePro;

        [bgScrollview addSubview:imageView];
        bgScrollview.contentSize = CGSizeMake(MTScreenW,  CGRectGetMaxY(imageView.frame));
        lastimg = imageView;
        
    }}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
