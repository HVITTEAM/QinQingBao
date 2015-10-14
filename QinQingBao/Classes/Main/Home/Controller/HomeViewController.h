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

- (IBAction)healthClickHandler:(id)sender;

/**图片数组*/
@property (strong,nonatomic)NSMutableArray *slideImages;
@property (strong,nonatomic)UIPageControl *pageControl;

@property (nonatomic, retain) ServiceListViewController *listView;
@property (nonatomic, retain)  HealthServicesController *healthVC;




@end
