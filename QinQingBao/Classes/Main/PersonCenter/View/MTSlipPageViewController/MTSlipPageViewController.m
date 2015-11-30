//
//  MTSlipPageViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/8/26.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

static const CGFloat kHeightOfTopScrollView = 44.0f;
static const CGFloat kFontSizeOfTabButton = 14.0f;

#import "MTSlipPageViewController.h"


@implementation MTSlipPageViewController

- (void)drawRect:(CGRect)rect
{
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)setViewArr:(NSMutableArray *)viewArr
{
    _viewArr = viewArr;
    [self initView];
}

/**
 * 初始化视图
 **/
-(void)initView
{
    
    self.buttonArr = [[NSMutableArray alloc] init];
    
    self.selectedIndex = 100;
    
    //创建顶部可滑动的scrollView
    self.headScrollView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, kHeightOfTopScrollView)];
    self.headScrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.headScrollView];
    
    //创建主滚动视图
    self.rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kHeightOfTopScrollView, MTScreenW, self.bounds.size.height - kHeightOfTopScrollView)];
    self.rootScrollView.delegate = self;
    self.rootScrollView.pagingEnabled = YES;
    self.rootScrollView.userInteractionEnabled = YES;
    self.rootScrollView.bounces = NO;
    self.rootScrollView.backgroundColor = HMGlobalBg;
    self.rootScrollView.showsHorizontalScrollIndicator = NO;
    self.rootScrollView.showsVerticalScrollIndicator = NO;
    _rootScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.rootScrollView];
    
    [self creatTabButtons];
    
    [self creatView];
}

-(void)creatTabButtons
{
    self.shadowImageView = [[UIImageView alloc] init];
    [self.shadowImageView setImage:[[UIImage imageNamed:@"red_line_and_shadow.png"]
                                    stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f]];
    
    for (int i = 0; i < self.viewArr.count; i++)
    {
        
        UIImageView *bgview = [[UIImageView alloc] init];
        [bgview setImage:[UIImage resizedImage:@"common_card_middle_background.png"]];
        
        UIViewController *vc = (UIViewController *)self.viewArr[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i + 100;
        button.backgroundColor = [UIColor whiteColor];
        [button setFrame:CGRectMake((MTScreenW/self.viewArr.count) *i,0,MTScreenW/self.viewArr.count, kHeightOfTopScrollView - 5)];
        [bgview setFrame:CGRectMake(button.x, 0, button.width, kHeightOfTopScrollView)];
        [button setTitle:vc.title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:kFontSizeOfTabButton];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:HMColor(12, 146, 241) forState:UIControlStateSelected];
        [button addTarget:self action:@selector(selectNameButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.headScrollView addSubview:bgview];
        [self.headScrollView addSubview:button];
        
        if (i == 0) {
            button.selected = YES;
            self.shadowImageView.frame = CGRectMake(0, 0, button.width,kHeightOfTopScrollView);
            
            [self.delegate switchView:self.viewArr[0] didselectTab:0];
        }
        [self.buttonArr addObject:button];
    }
    [self.headScrollView addSubview:_shadowImageView];

}

-(void)creatView
{
    for (int i=0; i < self.viewArr.count; i++) {
        UIViewController *vc = (UIViewController *)self.viewArr[i];
        vc.view.frame = CGRectMake(self.rootScrollView.width*i, 0,
                                   self.rootScrollView.width, self.rootScrollView.height - 66 - kHeightOfTopScrollView);
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
            [self.rootScrollView setContentOffset:CGPointMake((self.selectedIndex - 100)*MTScreenW, 0) animated:YES];
            self.isUseButtonClick = YES;
            [self.delegate switchView:self.viewArr[self.selectedIndex - 100] didselectTab:self.selectedIndex - 100];
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
 * @abstract
 * @discussion
 * @param
 * @result
 */
- (void)adjustScrollViewContentX:(NSInteger)index
{
    //取之前的按钮
    UIButton *lastButton = (UIButton *)[self.headScrollView viewWithTag:self.selectedIndex];
    lastButton.selected = NO;
    if (self.selectedIndex != index + 100)
    {
        [self.delegate switchView:self.viewArr[index] didselectTab:index];

        //新页面
        //赋值按钮ID
        self.selectedIndex = index + 100;
        UIButton *newButton = (UIButton *)[self.headScrollView viewWithTag:self.selectedIndex];
        newButton.selected = YES;
        
        //背景图片动画
        [UIView animateWithDuration:0.25 animations:^{
            
            [self.shadowImageView setFrame:CGRectMake(newButton.x, 0, newButton.width, kHeightOfTopScrollView)];
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

@end
