//
//  HealthArchivesController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/10/28.
//  Copyright © 2015年 董徐维. All rights reserved.
//

static float cellWidth = 66;

#import "HealthArchivesController.h"

#import "HabitViewController.h"
#import "HeredityinfoController.h"
#import "DiseaseinfoController.h"
#import "HealthyinfoController.h"
#import "HypertensioninfoController.h"

@interface HealthArchivesController ()
{
 
    
}

@property (nonatomic, strong) HabitViewController *vc1;
@property (nonatomic, strong) HeredityinfoController *vc2;
@property (nonatomic, strong) DiseaseinfoController *vc3;
@property (nonatomic, strong) HypertensioninfoController *vc4;
@property (nonatomic, strong) HealthyinfoController *vc5;
@end

@implementation HealthArchivesController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initNavigation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.backgroundColor = HMGlobalBg;
    [self.view addSubview:self.scrollView];
    
    [self initView];
    
    self.vc1 = [[HabitViewController alloc] init];
    self.vc1.habitVO = self.familyInfoTotal.habitinfo;
    self.vc1.title = @"生活习惯";

    self.vc2 = [[HeredityinfoController alloc] init];
    self.vc2.heredityVO = self.familyInfoTotal.heredityinfo;
    self.vc2.title = @"家族遗传史";
    
    self.vc3 = [[DiseaseinfoController alloc] init];
    self.vc3.dataProvider = self.familyInfoTotal.diseaseinfo;

    self.vc3.title = @"疾病史";
    
    self.vc4 = [[HypertensioninfoController alloc] init];
    self.vc4.hyoertensionVO = self.familyInfoTotal.hypertensioninfo;
    self.vc4.title = @"高血压专项";
    
    self.vc5 = [[HealthyinfoController alloc] init];
    self.vc5.dataProvider = self.familyInfoTotal.healthyinfo;
    self.vc5.title = @"健康信息";
    
    [self.slideSwitchView buildUI];
}



#pragma mark - 滑动tab视图代理方法

- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view
{
    return 5;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    if (number == 0) {
        return self.vc1;
    } else if (number == 1) {
        return self.vc2;
    } else if (number == 2) {
        return self.vc3;
    } else if (number == 3) {
        return self.vc4;
    } else if (number == 4) {
        return self.vc5;
    }  else {
        return nil;
    }
}

//- (void)slideSwitchView:(QCSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer *)panParam
//{
//    QCViewController *drawerController = (QCViewController *)self.navigationController.mm_drawerController;
//    [drawerController panGestureCallback:panParam];
//}

- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    QCListViewController *vc = nil;
    HabitViewController *vc0 = nil;
    HeredityinfoController *vc1 = nil;
    DiseaseinfoController *vc2 = nil;
    HypertensioninfoController *vc3 = nil;
    HealthyinfoController *vc4 = nil;

    if (number == 0) {
        vc0 = self.vc1;
    } else if (number == 1) {
        vc1 = self.vc2;
    } else if (number == 2) {
        vc2 = self.vc3;
    } else if (number == 3) {
        vc3 = self.vc4;
    } else if (number == 4) {
        vc4 = self.vc5;
    }
    vc.nav = self.navigationController;
    vc0.nav = self.navigationController;
    vc1.nav = self.navigationController;
    vc2.nav = self.navigationController;
    vc3.nav = self.navigationController;
    vc4.nav = self.navigationController;
    [vc viewDidCurrentView];
}

-(void)initView
{
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.slideSwitchView = [[QCSlideSwitchView alloc] initWithFrame:CGRectMake(0,0, self.view.width, self.view.height  - cellWidth)];
    self.slideSwitchView.slideSwitchViewDelegate = self;
    [self.scrollView addSubview:self.slideSwitchView];
    
    self.slideSwitchView.tabItemNormalColor = [QCSlideSwitchView colorFromHexRGB:@"868686"];
    self.slideSwitchView.tabItemSelectedColor = [QCSlideSwitchView colorFromHexRGB:@"1e90ff"];
    self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"red_line_and_shadow.png"]
                                        stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
