//
//  HealthReportCell.m
//  QinQingBao
//
//  Created by 董徐维 on 2016/11/7.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#define kPageheight 160
#define kPagewidth MTScreenW - 10

#import "HealthReportCell.h"

@interface HealthReportCell ()<UIScrollViewDelegate>

@end

@implementation HealthReportCell


+ (HealthReportCell*) healthReportCell
{
    HealthReportCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"HealthReportCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = HMGlobalBg;
    cell.bgview.layer.cornerRadius = 8;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setDataProvider:(NSArray *)dataProvider
{
    _dataProvider = dataProvider;
    [self initPageView];
}

-(void)initPageView
{
    self.planLab.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleLabTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClicklab:)];
    [self.planLab addGestureRecognizer:singleLabTap];
    
    self.pageView.bounces = YES;
    self.pageView.pagingEnabled = YES;
    self.pageView.delegate = self;
    self.pageView.userInteractionEnabled = YES;
    self.pageView.showsHorizontalScrollIndicator = NO;
    
    // 初始化 pagecontrol
    [self.pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithRGB:@"94bf36"]];
    [self.pageControl setPageIndicatorTintColor:[UIColor grayColor]];
    if (_dataProvider.count == 1)
        self.pageControl.hidden = YES;
    else
        self.pageControl.hidden = NO;
    
    self.pageControl.numberOfPages = _dataProvider.count;
    self.pageControl.currentPage = 0;
    
    // 创建图片 imageview
    for (int i = 0; i <_dataProvider.count; i++)
    {
        UIView *view = [self getPageViewwithItem:_dataProvider[i]];
        view.frame = CGRectMake((MTScreenW - 10) * i, 0, (MTScreenW - 10), kPageheight);
        view.userInteractionEnabled=YES;
        view.tag = i;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage:)];
        [view addGestureRecognizer:singleTap];
        [self.pageView addSubview:view];
    }
    
    [self.pageView setContentSize:CGSizeMake((MTScreenW - 10) * _dataProvider.count, kPageheight)];
    [self.pageView setContentOffset:CGPointMake(0, 0)];
    [self.pageView scrollRectToVisible:CGRectMake(0 , 0 ,MTScreenW, kPageheight) animated:NO];
}

#pragma mark -- UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pagewidth = self.pageView.frame.size.width;
    int page = floor((self.pageView.contentOffset.x - pagewidth/5)/pagewidth)+1;
    self.pageControl.currentPage = page;
}

-(UIView *)getPageViewwithItem:(PersonReportModel *)item
{
    UIView *view = [[UIView alloc] init];
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 25, 25)];
    icon.image  = [UIImage imageNamed:@"report.png"];
    [view addSubview:icon];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame) + 8, 8, 200, 20)];
    lab.font =  [UIFont fontWithName:@"Helvetica-Bold" size:13];
    lab.text = item.iname;
    [lab sizeToFit];
    [view addSubview:lab];
    
    UILabel *timelab = [[UILabel alloc] init];
    timelab.text = item.wp_create_time;
    timelab.textColor = [UIColor colorWithRGB:@"999999"];
    timelab.font = [UIFont fontWithName:@"Helvetica" size:13];
    
    CGSize size = [timelab.text sizeWithAttributes:@{NSFontAttributeName:timelab.font}];
    timelab.frame = CGRectMake(MTScreenW - 20 - size.width, 7, size.width, 23);
    [view addSubview:timelab];
    
    NSURL *iconUrl = [NSURL URLWithString:item.examreport_url];
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
    imageView.frame = CGRectMake(0, 40, MTScreenW - 10, 140);
    imageView.backgroundColor = [UIColor whiteColor];
    [view addSubview:imageView];
    return view;
}

#pragma mark -- clickHandler

-(void)onClickImage:(UITapGestureRecognizer *)sender
{
    if(self.clickType)
        self.clickType(_dataProvider[sender.view.tag]);
}

-(void)onClicklab:(UITapGestureRecognizer *)sender
{
    if(self.clickType)
        self.clickType(_dataProvider[sender.view.tag]);
    
}

@end
