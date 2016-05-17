//
//  AdvertisementController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/5/13.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "AdvertisementController.h"
#import "GoodsHeadViewController.h"

@interface AdvertisementController ()

@property(strong,nonatomic)UIImageView *imageView;

@end

@implementation AdvertisementController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
}


-(void)setItem:(HomePicModel *)item
{
    _item = item;
    self.title = item.title;
    self.url = [NSString stringWithFormat:@"%@%@",URL_WebImg,item.bc_article_url];
}


-(void)initView
{
    if (self.item.bc_goods_id.length > 0)
    {
        CGFloat bottomViewHeight = 60;
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MTScreenH - bottomViewHeight, MTScreenW, bottomViewHeight)];
        bottomView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bottomView];
        UIButton *commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, MTScreenW - 20, bottomViewHeight)];
        
        NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_AdvanceImg,self.item.bc_goods_bg]];
        self.imageView = [[UIImageView alloc] init];
        [self.imageView sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            [commitBtn setBackgroundImage:image forState:UIControlStateNormal];
            [bottomView addSubview:commitBtn];
            [self.view layoutIfNeeded];
        }];
        [commitBtn addTarget:self action:@selector(commitHandle:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)commitHandle:(id)sender
{
    GoodsHeadViewController *vc = [[GoodsHeadViewController alloc] init];
    vc.goodsID =self.item.bc_goods_id;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
