//
//  MTPageNavViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/9/10.
//  Copyright © 2016年 董徐维. All rights reserved.
//

static const CGFloat kHeightOfTopScrollView = 44.0f;
static const CGFloat kFontSizeOfTabButton = 15.0f;

#import "MTPageNavViewController.h"

@interface MTPageNavViewController ()<UIScrollViewDelegate>
/**是否是点击了headBtn**/
@property (nonatomic, assign) BOOL isUseButtonClick;

@property (nonatomic, strong)  UIScrollView *rootScrollView;
@property (nonatomic, strong)  UIView *headScrollView;
@property (nonatomic, strong)  UIImageView *shadowImageView;

@property (nonatomic, strong) NSMutableArray *buttonArr;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation MTPageNavViewController

-(void)setViewArr:(NSMutableArray *)viewArr
{
    _viewArr = viewArr;
    
    [self initView];
}

#pragma mark page控制器
/**
 * 初始化视图
 **/
-(void)initView
{
    self.selectedIndex = 100;
    
    self.buttonArr = [[NSMutableArray alloc] init];
    
    //创建顶部可滑动的scrollView
    self.headScrollView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW - 120, kHeightOfTopScrollView)];
    self.navigationItem.titleView = self.headScrollView;
    
    //创建主滚动视图
    self.rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, self.view.height)];
    self.rootScrollView.pagingEnabled = YES;
    self.rootScrollView.delegate = self;
    self.rootScrollView.userInteractionEnabled = YES;
    self.rootScrollView.bounces = NO;
    self.rootScrollView.backgroundColor = HMGlobalBg;
    self.rootScrollView.showsHorizontalScrollIndicator = NO;
    self.rootScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.rootScrollView];
    
    [self creatTabButtons];
    
    [self creatView];
}

-(void)creatTabButtons
{
    self.shadowImageView = [[UIImageView alloc] init];
    [self.shadowImageView setImage:[[UIImage imageNamed:@"red_line_and_shadow.png"] stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f]];
    
    for (int i = 0; i < self.viewArr.count; i++)
    {
        
        UIViewController *vc = (UIViewController *)self.viewArr[i];
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i + 100;
        [button setFrame:CGRectMake(((MTScreenW - 120)/self.viewArr.count) *i,0,(MTScreenW - 120)/self.viewArr.count, kHeightOfTopScrollView - 5)];
        [button setTitle:vc.title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:kFontSizeOfTabButton];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRGB:@"70a426"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(selectNameButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.headScrollView addSubview:button];
        
        if (i == 0)
        {
            button.selected = YES;
            self.shadowImageView.frame = CGRectMake(0, 0, button.width,kHeightOfTopScrollView);
        }
        [self.buttonArr addObject:button];
    }
    [self.headScrollView addSubview:_shadowImageView];
}

-(void)creatView
{
    for (int i = 0; i < self.viewArr.count; i++)
    {
        UIViewController *vc = (UIViewController *)self.viewArr[i];
        vc.view.frame = CGRectMake(self.rootScrollView.width*i, 0 ,self.rootScrollView.width, self.rootScrollView.height);
        
        [self.rootScrollView addSubview:vc.view];
    }
    self.rootScrollView.contentSize = CGSizeMake(MTScreenW * [self.viewArr count], 0);
    //滚动到选中的视图
    [self.rootScrollView setContentOffset:CGPointMake((self.selectedIndex - 100)*MTScreenW, 0) animated:NO];
}

- (void)selectNameButton:(UIButton *)sender
{
    //如果更换按钮
    if (sender.tag != self.selectedIndex)
    {
        //取之前的按钮
        UIButton *lastButton = (UIButton *)[self.headScrollView viewWithTag:self.selectedIndex];
        lastButton.selected = NO;
        sender.selected = YES;
        //赋值按钮ID
        self.selectedIndex = sender.tag;
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.shadowImageView setFrame:CGRectMake(sender.frame.origin.x, 0, sender.width, kHeightOfTopScrollView)];
        } completion:^(BOOL finished) {
            [self.rootScrollView setContentOffset:CGPointMake((self.selectedIndex - 100)*MTScreenW,-64) animated:YES];
            self.isUseButtonClick = YES;
        }];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.isUseButtonClick)
        return;
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor(scrollView.contentOffset.x - pageWidth / self.viewArr.count) / pageWidth +1;//计算当前页码
    [self adjustScrollViewContentX:page];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    self.isUseButtonClick = NO;
}

/*!
 * @method 调整顶部滚动视图x位置
 */
- (void)adjustScrollViewContentX:(NSInteger)index
{
    if (self.selectedIndex != index + 100)
    {
        //取之前的按钮
        UIButton *lastButton = (UIButton *)[self.headScrollView viewWithTag:self.selectedIndex];
        lastButton.selected = NO;
        
        //赋值按钮ID
        self.selectedIndex = index + 100;
        UIButton *newButton = (UIButton *)[self.headScrollView viewWithTag:self.selectedIndex];
        newButton.selected = YES;
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.shadowImageView setFrame:CGRectMake(newButton.x, 0, newButton.width, kHeightOfTopScrollView)];
        } completion:^(BOOL finished) {
        }];
    }
}

/**
 设置角标
 @param value badgevalue
 */
-(void)setBadge:(NSString *)value
{
    if([value integerValue] <1)return;
    for (int i = 0; i < self.buttonArr.count; i++)
    {
        UIButton *btn = (UIButton *)self.buttonArr[i];
        
        if ([btn.titleLabel.text  isEqual:@"私信"])
        {
            [btn.titleLabel initWithBadgeValue:value];
        }
    }
    
}
@end
