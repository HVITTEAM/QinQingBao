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
    
    [self initScrollView];
    
}

-(void)initScrollView
{
    bgScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH)];
    bgScrollview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgScrollview];
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
    [CommonRemoteHelper RemoteWithUrl:URL_Goods_body parameters:@{@"goods_id" : @100131}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     imgArr.array = [dict objectForKey:@"datas"];
                                     
                                     [self initData];
                                     
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [NoticeHelper AlertShow:@"获取失败!" view:self.view];
                                 }];
}

-(void)initData
{
    UIImageView *lastimg;
    if (!imgArr || imgArr.count == 0)
        return [self initWithPlaceString:@"暂无图文详情数据!"];
    for (int i = 0; i < imgArr.count; i++)
    {
      
        UIImageView *imageView = [[UIImageView alloc] init];
        NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"",imgArr[i]]];

        [imageView sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"noneImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            NSLog(@"图片加载完成！");
            
            imageView.tag = i;
            imageView.x = 0;
            imageView.y = MTScreenW *i;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.width = MTScreenW;
            imageView.height = MTScreenW;
            [bgScrollview addSubview:imageView];
        }];
////        CGSize size = img.size;
//        //缩放比例
////        float scalePro = MTScreenW / size.width;
//        imageView.tag = i;
//        imageView.x = 0;
//        imageView.y = CGRectGetMaxY(lastimg.frame);
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        imageView.width = MTScreenW;
////        imageView.height = size.height * scalePro;
//        imageView.height = MTScreenW;
//        [bgScrollview addSubview:imageView];
//        bgScrollview.contentSize = CGSizeMake(MTScreenW,  CGRectGetMaxY(imageView.frame));
//        lastimg = imageView;
    }
    
    bgScrollview.contentSize = CGSizeMake(MTScreenW,  MTScreenW * imgArr.count);

}



@end
