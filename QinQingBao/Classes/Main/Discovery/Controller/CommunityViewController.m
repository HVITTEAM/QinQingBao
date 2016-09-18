//
//  CommunityViewController.m
//  QinQingBao
//
//  Created by shi on 16/9/10.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CommunityViewController.h"
#import "CardCell.h"
#import "SiglePicCardCell.h"

#define kBkImageViewHeight 140
#define kHeadViewHeith 140
#define kTabViewHeight 50
#define kNewsCellHeight 50

#define kLeftBtnTag 1200
#define kRightBtnTag 1201

@interface CommunityViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIView *line;

@property (strong, nonatomic) UIView *tabView;

@property (strong, nonatomic) UIImageView *bkImageView;

@property (strong, nonatomic) UIView *navBar;

@property (weak, nonatomic) IBOutlet UIImageView *headIconView;

@property (weak, nonatomic) IBOutlet UILabel *headTitleLb;

@property (weak, nonatomic) IBOutlet UILabel *numberLb;

@property (weak, nonatomic) IBOutlet UILabel *ownerLb;

@end

@implementation CommunityViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"释放");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HMGlobalBg;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)setupUI
{
    UIImageView *bkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, kBkImageViewHeight)];
    bkImageView.image = [UIImage imageNamed:@"1-1"];
    bkImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bkImageView];
    self.bkImageView = bkImageView;
    
    UITableView *tbv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH) style:UITableViewStylePlain];
    tbv.showsVerticalScrollIndicator = NO;
    tbv.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tbv.delegate = self;
    tbv.dataSource = self;
    tbv.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tbv];
    self.tableView = tbv;

    UIView *headView = [[[NSBundle mainBundle] loadNibNamed:@"CommunityHeadView" owner:self options:nil] firstObject];
    headView.backgroundColor = [UIColor clearColor];
    headView.frame = CGRectMake(0, 0, MTScreenW, kHeadViewHeith);
    self.tableView.tableHeaderView = headView;
    
    self.navBar = [[UIView alloc] initWithFrame:CGRectMake(0,0, MTScreenW, 64)];
    self.navBar.backgroundColor = [UIColor whiteColor];
    self.navBar.alpha = 0;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15, 27, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"checkMark_icon"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, MTScreenW, 30)];
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.textColor = [UIColor darkTextColor];
    titleLb.font = [UIFont systemFontOfSize:17];
    titleLb.text = @"标题";
    UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MTScreenW, 0.5)];
    lv.backgroundColor = HMColor(230, 230, 230);
    [self.navBar addSubview:lv];
    [self.navBar addSubview:backBtn];
    [self.navBar addSubview:titleLb];
    
    [self.view addSubview:self.navBar];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (0 == section) {
        return 3;
    }
    
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        static NSString *newsCellId = @"newsCell";
        UITableViewCell *newsCell = [tableView dequeueReusableCellWithIdentifier:newsCellId];
        if (!newsCell) {
            newsCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newsCellId];
        }
        newsCell.imageView.image = [UIImage imageNamed:@"sport"];
        newsCell.textLabel.text = @"水电费金砂街道富乐山绝地反击上岛咖啡绝色赌妃图格里克韩国帅哥世界大学城星罗棋布时";
        cell = newsCell;
    }else{
//        CardCell *cardCell = [CardCell createCellWithTableView:tableView];
//        [cardCell setData];
//        cell = cardCell;
        SiglePicCardCell *siglePicCardCell = [SiglePicCardCell createCellWithTableView:tableView];
        [siglePicCardCell setData];
        cell = siglePicCardCell;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        return kNewsCellHeight;
    }
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 0.01;
    }
    
    return kTabViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return nil;
    }
    
    if (!self.tabView) {
        self.tabView = [self createTabView];
    }

    return self.tabView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
        CGFloat distance = -scrollView.contentOffset.y;
        self.bkImageView.frame = CGRectMake(0, 0, MTScreenW, kBkImageViewHeight + distance);
        
    }else{
        self.bkImageView.frame = CGRectMake(0, -scrollView.contentOffset.y, MTScreenW, kBkImageViewHeight);
    }
    
    CGFloat positionY = kHeadViewHeith + 3 * kNewsCellHeight + 10;

    if (scrollView.contentOffset.y > positionY - 64) {
        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    }else{
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    if (scrollView.contentOffset.y > positionY - 128) {
        CGFloat delta = 1.0 / 64;
        self.navBar.alpha = (scrollView.contentOffset.y - (positionY - 128)) * delta;
    }else{
        self.navBar.alpha = 0;
    }

}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeTab:(UIButton *)sender
{
    UIButton *leftbtn = (UIButton *)[self.view viewWithTag:kLeftBtnTag];
    [leftbtn setTitleColor:HMColor(153, 153, 153) forState:UIControlStateNormal];
    UIButton *rightbtn = (UIButton *)[self.view viewWithTag:kRightBtnTag];
    [rightbtn setTitleColor:HMColor(153, 153, 153) forState:UIControlStateNormal];
    
    [sender setTitleColor:HMColor(112, 164, 38) forState:UIControlStateNormal];
    
    if (sender == leftbtn) {
        NSLog(@"全部数据");
        
    }else{
        NSLog(@"热门数据");
    }
 
    [self.tableView reloadData];
    
    CGRect frame = self.line.frame;
    frame.origin.x = sender.frame.origin.x;
    frame.size.width = sender.frame.size.width;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.line.frame = frame;
    }];
}

- (UIView *)createTabView
{
    UIView *tabView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, kTabViewHeight)];
    tabView.backgroundColor = [UIColor whiteColor];
    
    UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(0, kTabViewHeight, MTScreenW, 0.5)];
    lv.backgroundColor = HMColor(235, 235, 235);
    [tabView addSubview:lv];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.tag = kLeftBtnTag;
    [leftBtn setTitle:@"全部" forState:UIControlStateNormal];
    [leftBtn setTitleColor:HMColor(112, 164, 38) forState:UIControlStateNormal];
    [leftBtn sizeToFit];
    leftBtn.frame = CGRectMake(0.25 * MTScreenW - leftBtn.width / 2, 0, leftBtn.width, kTabViewHeight);
    [leftBtn addTarget:self action:@selector(changeTab:) forControlEvents:UIControlEventTouchUpInside];
    [tabView addSubview:leftBtn];
    
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.tag = kRightBtnTag;
    [rightBtn setTitle:@"热门" forState:UIControlStateNormal];
    [rightBtn setTitleColor:HMColor(153, 153, 153) forState:UIControlStateNormal];
    [rightBtn sizeToFit];
    rightBtn.frame = CGRectMake(0.75 * MTScreenW - rightBtn.width / 2, 0, rightBtn.width, kTabViewHeight);
    [rightBtn addTarget:self action:@selector(changeTab:) forControlEvents:UIControlEventTouchUpInside];
    [tabView addSubview:rightBtn];
    
    self.line = [[UIView alloc] initWithFrame:CGRectMake(leftBtn.x, kTabViewHeight - 3, leftBtn.width, 3)];
    self.line.backgroundColor = HMColor(112, 164, 38);
    [tabView addSubview:self.line];
    
    return tabView;
}

@end
