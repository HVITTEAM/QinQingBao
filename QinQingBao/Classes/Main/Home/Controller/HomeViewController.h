//
//  HomeViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 15/8/12.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//  test

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

- (IBAction)healthClickHandler:(id)sender;
- (IBAction)questionClickHander:(id)sender;
- (IBAction)massageClickHandler:(id)sender;







@end
