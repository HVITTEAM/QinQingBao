//
//  GoodsDetailController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "GoodsDetailViewController.h"

@interface GoodsDetailViewController ()
{
    NSMutableArray *imgArr;
    UIScrollView *bgScrollview;
}

@end

@implementation GoodsDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavgation];
    
    [self getGoodsBodyInfo];
    
    [self initScrollview];
    
}

-(void)initNavgation
{
    self.title = @"图文详情";
    self.view.backgroundColor = [UIColor whiteColor];
}

/**
 * 获取商品详情数据
 **/
-(void)getGoodsBodyInfo
{
    imgArr  = [[NSMutableArray alloc] init];
    [CommonRemoteHelper RemoteWithUrl:URL_Goods_body parameters:@{@"goods_id" : self.goodsID}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         [self.view initWithPlaceString:@"暂无数据"];
                                     }
                                     else
                                     {
                                         imgArr.array = [dict objectForKey:@"datas"];
                                         
                                         [self createImageViews];
                                     }
                                     
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [NoticeHelper AlertShow:@"获取失败!" view:self.view];
                                 }];
}

-(void)initScrollview
{
    bgScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH)];
    [self.view addSubview:bgScrollview];
    bgScrollview.backgroundColor = [UIColor whiteColor];
}

-(void)createImageViews
{
    NSMutableArray *imageviewArray = [[NSMutableArray alloc] init];
    NSMutableArray *contrains = [[NSMutableArray alloc] init];
    
    for (int i = 0 ; i <imgArr.count ; i ++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.backgroundColor = [UIColor whiteColor];
        //imgView.contentMode = UIViewContentModeScaleAspectFit;
        [imageviewArray addObject:imgView];
        [bgScrollview addSubview:imgView];
        
        imgView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *viewDict = NSDictionaryOfVariableBindings(imgView);
        
        
        [imgView addConstraint:[NSLayoutConstraint constraintWithItem:imgView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:MTScreenW]];
        
        [contrains addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imgView]-0-|" options:0 metrics:nil views:viewDict]];
        
        if (i == 0) {
            [contrains addObject:[NSLayoutConstraint constraintWithItem:imgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:bgScrollview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0] ];
        }else{
            
            [contrains addObject:[NSLayoutConstraint constraintWithItem:imgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:imageviewArray[i-1] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
        }
        
        if (i == imgArr.count - 1) {
            [contrains addObject:[NSLayoutConstraint constraintWithItem:imgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bgScrollview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
        }
        
        NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"",imgArr[i]]];
        [imgView sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"noneImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            CGFloat scale = image.size.width / image.size.height;
            CGFloat h = MTScreenW / scale;
            [imgView addConstraint:[NSLayoutConstraint constraintWithItem:imgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:h]];
            imgView.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage:)];
            [imgView addGestureRecognizer:singleTap];
            [self.view setNeedsLayout];
        }];
    }
    [bgScrollview addConstraints:contrains];
}

-(void)onClickImage:(UITapGestureRecognizer *)tap
{
    UIImageView *img = (UIImageView *)tap.view;
    SWYPhotoBrowserViewController *photoBrowser = [[SWYPhotoBrowserViewController alloc] initPhotoBrowserWithImages:@[img.image] currentIndex:0];
    [self.navigationController presentViewController:photoBrowser animated:YES completion:nil];
}

@end
