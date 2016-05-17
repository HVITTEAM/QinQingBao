//
//  HomeViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 15/8/12.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//  test shi shi

#import <UIKit/UIKit.h>
#import "ServiceListViewController.h"
#import "HealthServicesController.h"


@interface HomeViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *imgPlayer;
@property (strong, nonatomic) IBOutlet UICollectionView *serviceColectionview;
@property (strong, nonatomic) IBOutlet UIView *healthServiceBackgroundView;
@property (strong, nonatomic) IBOutlet UIButton *healthBtn;
@property (strong, nonatomic) IBOutlet UIButton *questionBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imgWidth;
//症状自查image
@property (strong, nonatomic) IBOutlet UIImageView *checkSelfImg;
//症状自查距离中间线的距离
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightPadding;
//在线提问距离中间线的距离
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftPadding;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftPadding1;

//轮播图的高度
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imagePlayerHeight;
//中间按钮区域的高度
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttonTypeHeight;
//服务分类的高度
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *serviceCollectHeight;
//中间按钮的上边距
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *checkTop;
//推拿按钮的高度
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tuinaBtnHeight;
//竖线的高度
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *VlineHeight;
//竖线的上边距
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *vlineTop;

- (IBAction)healthClickHandler:(id)sender;
- (IBAction)questionClickHander:(id)sender;
- (IBAction)massageClickHandler:(id)sender;







@end
