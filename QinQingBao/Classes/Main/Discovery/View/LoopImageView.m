//
//  LoopImageView.m
//  QinQingBao
//
//  Created by shi on 16/9/9.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "LoopImageView.h"
#import "UIImageView+WebCache.h"

@interface LoopImageView ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIPageControl *pageControl;

@property (strong, nonatomic) NSMutableArray *imageViews;

@property (assign, nonatomic) NSInteger currentIdx;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation LoopImageView

@synthesize imageUrls = _imageUrls;

- (instancetype)init
{
    if (self = [super init]) {
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.currentPage = 0;
        _pageControl.hidesForSinglePage = YES;
        [self addSubview:_pageControl];
        
        self.currentIdx = 0;
        
        [self startAutoScroll];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    
    self.scrollView.frame = self.bounds;
    
    self.pageControl.frame = CGRectMake(0, h - 30, w, 30);
    
    for (int i = 0; i < self.imageViews.count; i++) {
        UIImageView *v  = self.imageViews[i];
        v.frame = CGRectMake(i * w, 0, w, h);
    }
    
    self.scrollView.contentSize = CGSizeMake(w * self.imageViews.count, h);
    self.scrollView.contentOffset = CGPointMake((self.currentIdx + 1) * self.scrollView.bounds.size.width, 0);
}

- (NSArray *)imageUrls
{
    if (!_imageUrls) {
        _imageUrls = [[NSArray alloc] init];
    }
    
    return _imageUrls;
}

- (NSMutableArray *)imageViews
{
    if (!_imageViews) {
        _imageViews = [[NSMutableArray alloc] init];
    }
    
    return _imageViews;
}

- (void)setImageUrls:(NSArray *)imageUrls
{
    _imageUrls = imageUrls;
    
    self.pageControl.numberOfPages = imageUrls.count;
    
    //这里是防止多次设置imageUrls时重复创建
    NSInteger num =  self.imageViews.count - (imageUrls.count + 2);
    if (num < 0) {
        for (int i = 0; i < -num; i++) {
            UIImageView *imgv = [[UIImageView alloc] init];
            imgv.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
            recognizer.numberOfTapsRequired = 1;
            recognizer.numberOfTouchesRequired = 1;
            [imgv addGestureRecognizer:recognizer];
            
            [self.scrollView addSubview:imgv];
            [self.imageViews addObject:imgv];
        }
    }else{
        for (int i = (int)self.imageViews.count - 1; i >= self.imageViews.count - num; i--) {
            
            UIImageView *imgv = self.imageViews[i];
            [imgv removeFromSuperview];
            [self.imageViews removeObject:imgv];
        }
    }
    
    for (int i = 0; i < imageUrls.count + 2; i++) {
        UIImageView *imgv = self.imageViews[i];
        NSURL *url = nil;
        if (i == 0) {
            url = [[NSURL alloc] initWithString:[imageUrls lastObject]];
            imgv.tag = 1000 + imageUrls.count - 1;
        }else if (i == imageUrls.count + 1){
            url = [[NSURL alloc] initWithString:imageUrls[0]];
            imgv.tag = 1000 + 0;
        }else{
            url = [[NSURL alloc] initWithString:imageUrls[i-1]];
            imgv.tag = 1000 + i - 1;
        }
        
        [imgv sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"advplaceholderImage"]];
        
    }
    
    [self setNeedsLayout];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger idx = (int)(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5);
    
    self.currentIdx = idx - 1;
    if (self.currentIdx < 0) {
        self.currentIdx = 0;
    }else if (self.currentIdx > self.imageUrls.count - 1){
        self.currentIdx = self.imageUrls.count - 1;
    }
    
    self.pageControl.currentPage = self.currentIdx;
    
//    NSLog(@"%d---%f",(int)self.currentIdx,scrollView.contentOffset.x);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger idx = (int)(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5);
    if (idx == 0) {
        scrollView.contentOffset = CGPointMake(self.imageUrls.count * scrollView.bounds.size.width, 0);
    }else if (idx == self.imageUrls.count + 1){
        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopAutoScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startAutoScroll];
}

- (void)startAutoScroll
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
}

- (void)stopAutoScroll
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)tapImageView:(UITapGestureRecognizer *)recognizer
{
//    NSLog(@"%d",(int)recognizer.view.tag);
    if (self.tapLoopImageCallBack) {
        self.tapLoopImageCallBack(recognizer.view.tag - 1000);
    }
}

- (void)nextImage
{
    self.currentIdx++;
    
    [self.scrollView setContentOffset:CGPointMake((self.currentIdx + 1) * self.scrollView.bounds.size.width, 0) animated:YES];
}

@end
