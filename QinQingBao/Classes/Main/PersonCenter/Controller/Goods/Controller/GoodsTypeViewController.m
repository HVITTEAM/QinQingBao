//
//  GoodsTypeViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/20.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "GoodsTypeViewController.h"
#import "MTSlipPageViewController.h"
#import "QCSlideSwitchView.h"


@interface GoodsTypeViewController ()<MTSwitchViewDelegate,QCSlideSwitchViewDelegate>
{
    
}
@property (nonatomic, strong) QCSlideSwitchView *slideSwitchView;

@end

@implementation GoodsTypeViewController

-(instancetype)init
{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initNavigation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
    
    self.vc0 = [[GoodsViewController alloc] init];
    self.vc0.title = @"全部";
    
    self.vc1 = [[GoodsViewController alloc] init];
    self.vc1.title = @"待付款";
    
    self.vc2 = [[GoodsViewController alloc] init];
    self.vc2.title = @"待发货";
    
    self.vc3 = [[GoodsViewController alloc] init];
    self.vc3.title = @"待收货";
    
    self.vc4 = [[GoodsViewController alloc] init];
    self.vc4.title = @"待评价";
    
    self.vc5 = [[RefundGoodsListController alloc] init];
    self.vc5.title = @"售后/取消";
    
    [self.slideSwitchView buildUI];
}


#pragma mark - 滑动tab视图代理方法

/**
 *  MT
 *
 *  @param view   <#view description#>
 *  @param number <#number description#>
 */
-(void)switchView:(UIViewController *)view didselectTab:(NSUInteger)number
{
    GoodsViewController *vc = nil;
    if (number != 5) {
        if (number == 0) {
            vc = self.vc0;
        }else if (number == 1) {
            vc = self.vc1;
        } else if (number == 2) {
            vc = self.vc2;
        } else if (number == 3) {
            vc = self.vc3;
        } else if (number == 4) {
            vc = self.vc4;
        }
        vc.nav = self.navigationController;
        [vc viewDidCurrentView];
    }else if (number == 5) {
        self.vc5.nav = self.navigationController;
        [self.vc5 loadFirstPageRefundListData];
    }
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.title =   @"我的商品";
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - QCSlideSwitchView edit 2016-03-03 by Mr.Tung 为解决view宽度不够显示问题改变控制器

- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view
{
    return 6;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    if (number == 0) {
        return self.vc0;
    } else if (number == 1) {
        return self.vc1;
    } else if (number == 2) {
        return self.vc2;
    } else if (number == 3) {
        return self.vc3;
    } else if (number == 4) {
        return self.vc4;
    } else if (number == 5) {
        return self.vc5;
    }  else {
        return nil;
    }
}

- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    GoodsViewController *vc = nil;
    if (number != 5) {
        if (number == 0) {
            vc = self.vc0;
        }else if (number == 1) {
            vc = self.vc1;
        } else if (number == 2) {
            vc = self.vc2;
        } else if (number == 3) {
            vc = self.vc3;
        } else if (number == 4) {
            vc = self.vc4;
        }
        vc.nav = self.navigationController;
        [vc viewDidCurrentView];
    }else if (number == 5) {
        self.vc5.nav = self.navigationController;
        [self.vc5 loadFirstPageRefundListData];
    }
}

-(void)initView
{
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;

    self.slideSwitchView = [[QCSlideSwitchView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH - 50)];
    self.slideSwitchView.slideSwitchViewDelegate = self;
    [self.view addSubview:self.slideSwitchView];
    
    self.slideSwitchView.tabItemNormalColor = [QCSlideSwitchView colorFromHexRGB:@"868686"];
    self.slideSwitchView.tabItemSelectedColor = [QCSlideSwitchView colorFromHexRGB:@"1e90ff"];
    self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"red_line_and_shadow.png"]
                                        stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
}


@end
