//
//  SWYPhotoBrowserViewController.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/5.
//  Copyright © 2015年 董徐维. All rights reserved.
//

typedef NS_ENUM(NSInteger, movingDirection) {
    movingDirectionNone,     // 不移动
    movingDirectionRight,    // 右移
    movingDirectionleft      // 左移
};

#import "SWYPhotoBrowserViewController.h"
#import "UIImageView+WebCache.h"

@interface SWYPhotoBrowserViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView *bkScrollView;         //背景scrollView
@property(nonatomic,strong)UIScrollView *leftScrollView;       //左侧scrollView
@property(nonatomic,strong)UIScrollView *currentScrollView;    //中间scrollView
@property(nonatomic,strong)UIScrollView *rightScrollView;      //右侧scrollView
@property(nonatomic,strong)UIImageView *leftImageView;         //左侧scrollView上的imageView
@property(nonatomic,strong)UIImageView *currentImageView;      //中间scrollView上的imageView
@property(nonatomic,strong)UIImageView *rightImageView;        //右侧scrollView上的imageView

@property(nonatomic,strong)NSArray *imageNames;      //图片名字数组
@property(nonatomic,strong)NSArray *images;          //图片image对象数组
@property(nonatomic,strong)NSArray *imageURls;       //图片URL字符串数组
@property(nonatomic,copy)NSString *placeholderImageName;                 //临时图片

@property(nonatomic,assign)NSInteger currentIndex;   //当前显示哪张
@property(nonatomic,assign)BOOL isDoubleTapBigger;      //双击时是放大还是还原图片大小

@end

@implementation SWYPhotoBrowserViewController
#pragma mark 初始化方法
-(instancetype)initPhotoBrowserWithImageNames:(NSArray *)imageNames currentIndex:(NSInteger)currentIndex
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _imageNames = imageNames;
        _currentIndex = currentIndex;
    }
    return self;
}

-(instancetype)initPhotoBrowserWithImages:(NSArray *)images currentIndex:(NSInteger)currentIndex
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _images = images;
        _currentIndex = currentIndex;
    }
    return self;
}

-(instancetype)initPhotoBrowserWithImageURls:(NSArray *)imageURLs currentIndex:(NSInteger)currentIndex placeholderImageNmae:(NSString *)placeholderImageName
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _imageURls = imageURLs;
        _currentIndex = currentIndex;
        _placeholderImageName = placeholderImageName;
        
    }
    return self;
}

#pragma mark 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initScrollView];
    [self initGestureRecognizer];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.bkScrollView.frame = self.view.bounds;
    
    CGFloat bkWidth = self.bkScrollView.width;
    CGFloat bkHeight = self.bkScrollView.height;
    
    self.leftScrollView.frame = CGRectMake(0, 0, bkWidth, bkHeight);
    self.currentScrollView.frame = CGRectMake(bkWidth, 0, bkWidth, bkHeight);
    self.rightScrollView.frame = CGRectMake(2*bkWidth, 0, bkWidth, bkHeight);
    
    self.leftImageView.frame = self.leftScrollView.bounds;
    self.currentImageView.frame = self.currentScrollView.bounds;
    self.rightImageView.frame = self.rightScrollView.bounds;
    
    self.bkScrollView.contentSize = CGSizeMake(3*bkWidth, bkHeight);
    
    [self changeImageWithMovingDirection:movingDirectionNone];
}

#pragma mark 视图的初始化方法、setter和getter方法
/**
 *  初始化ScrollView
 */
-(void)initScrollView
{
    
    self.bkScrollView = [[UIScrollView alloc] init];
    
    self.bkScrollView.pagingEnabled = YES;
    self.bkScrollView.delegate = self;
    self.bkScrollView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.bkScrollView];
    
    self.leftScrollView = [[UIScrollView alloc] init];
    self.leftScrollView.delegate = self;
    self.leftScrollView.minimumZoomScale=1;
    self.leftScrollView.maximumZoomScale=4;
    self.leftImageView = [[UIImageView alloc] init];
    self.leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.leftScrollView addSubview:self.leftImageView];
    [self.bkScrollView addSubview:self.leftScrollView];
    
    self.currentScrollView = [[UIScrollView alloc] init];
    self.currentScrollView.delegate = self;
    self.currentScrollView.minimumZoomScale=1;
    self.currentScrollView.maximumZoomScale=4;
    self.currentImageView = [[UIImageView alloc] init];
    self.currentImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.currentScrollView addSubview:self.currentImageView];
    [self.bkScrollView addSubview:self.currentScrollView];
    self.currentImageView.backgroundColor = [UIColor redColor];
    
    self.rightScrollView = [[UIScrollView alloc] init];
    self.rightScrollView.delegate = self;
    self.rightScrollView.minimumZoomScale=1;
    self.rightScrollView.maximumZoomScale=4;
    self.rightImageView = [[UIImageView alloc] init];
    self.rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.rightScrollView addSubview:self.rightImageView];
    [self.bkScrollView addSubview:self.rightScrollView];
    
    if (self.images.count == 1||self.imageNames.count == 1 ||self.imageURls.count ==1) {
        self.bkScrollView.scrollEnabled = NO;
    }
}

/**
 *  初始化手势
 */
-(void)initGestureRecognizer
{
    //单击手势
    UITapGestureRecognizer *sigleGestureRe = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    sigleGestureRe.numberOfTouchesRequired = 1;
    sigleGestureRe.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:sigleGestureRe];
    
    //双击手势
    UITapGestureRecognizer *doubleGestureRe = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImage:)];
    doubleGestureRe.numberOfTouchesRequired = 1;
    doubleGestureRe.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleGestureRe];
    [sigleGestureRe requireGestureRecognizerToFail:doubleGestureRe];
    
    //双击是否放大还是还原
    self.isDoubleTapBigger = YES;
}

#pragma mark 协议方法
#pragma mark  UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.bkScrollView) {
        if (scrollView.contentOffset.x<=0 ) {
            //如果小于等于0表示图片向右侧移动
            [self changeImageWithMovingDirection:movingDirectionRight];
        }else if (scrollView.contentOffset.x>=2*self.bkScrollView.bounds.size.width){
            //如果大于等于 2*MTScreenW 表示图片向左侧移动
            [self changeImageWithMovingDirection:movingDirectionleft];
        }
    }
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.currentImageView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self centerScrollViewContents];
}

#pragma mark 事件方法
/**
 *  双击手势时调用，来放大或缩小图片
 */
-(void)scaleImage:(UITapGestureRecognizer *)gestureRecognizer
{
    CGFloat newscale = 1.5;
    
    CGRect zoomRect = [self zoomRectForScale:newscale withCenter:[gestureRecognizer locationInView:self.currentImageView] andScrollView:self.currentScrollView];
    
    if (self.isDoubleTapBigger == YES)  {
        [self.currentScrollView zoomToRect:zoomRect animated:YES];
    }else {
        [self.currentScrollView setZoomScale:self.currentScrollView.minimumZoomScale animated:YES];
    }
    self.isDoubleTapBigger = !self.isDoubleTapBigger;
}

-(void)back
{
//    float ff = self.currentScrollView.zoomScale;
//    if (self.currentScrollView.zoomScale > 1)
//        [self.currentScrollView setZoomScale:self.currentScrollView.minimumZoomScale animated:YES];
//    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 私有方法

/**
 *  根据滚动方向重新设置图片
 */
-(void)changeImageWithMovingDirection:(movingDirection)direction
{
    NSInteger imgCount = 0;
    if (self.imageNames) {
        imgCount = self.imageNames.count;
    }else if (self.images){
        imgCount = self.images.count;
    }else if (self.imageURls){
        imgCount = self.imageURls.count;
    }
    
    //确定当前要显示的图片的index,
    switch (direction) {
        case movingDirectionRight:
            self.currentIndex = (self.currentIndex -1+imgCount)%imgCount;   //将左侧的图片作为当前图片
            break;
        case movingDirectionleft:
            self.currentIndex = (self.currentIndex+1)%imgCount;            //将右侧图片作为当前图片
            break;
        case movingDirectionNone:
            break;
    }
    //根据当前图片计算左侧和右侧图片。
    NSInteger leftIndex = (self.currentIndex -1+imgCount)%imgCount;
    NSInteger rigthIndex = (self.currentIndex+1)%imgCount;
    
    //设置图片
    if (self.imageNames) {
        self.leftImageView.image = [UIImage imageNamed:self.imageNames[leftIndex]];
        self.currentImageView.image = [UIImage imageNamed:self.imageNames[self.currentIndex]];
        self.rightImageView.image = [UIImage imageNamed:self.imageNames[rigthIndex]];
    }else if (self.images){
        self.leftImageView.image = self.images[leftIndex];
        self.currentImageView.image = self.images[self.currentIndex];
        self.rightImageView.image = self.images[rigthIndex];
    }else if (self.imageURls){
        
        [self.leftImageView sd_setImageWithURL:self.imageURls[leftIndex] placeholderImage:[UIImage imageNamed:self.placeholderImageName] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
        
        [self.currentImageView sd_setImageWithURL:self.imageURls[self.currentIndex] placeholderImage:[UIImage imageNamed:self.placeholderImageName] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self setimageViewFrame];
        }];
        
        [self.rightImageView sd_setImageWithURL:self.imageURls[rigthIndex] placeholderImage:[UIImage imageNamed:self.placeholderImageName] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
    }
    
    //将currentScrollView这个视图显示在屏幕上
    self.bkScrollView.contentOffset = CGPointMake(self.bkScrollView.bounds.size.width, 0);
    self.isDoubleTapBigger = YES;
    
    //设置currentImageView的大小位置
    [self setimageViewFrame];
}

/**
 *  设置currentImageView的大小位置以及currentScrollView的缩放比例
 */
-(void)setimageViewFrame
{
    CGSize imageSize = self.currentImageView.image.size;
    self.currentImageView.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
    self.currentScrollView.contentSize = imageSize;
    
    CGSize scrollviewSize = self.currentScrollView.bounds.size;
    CGFloat scaleW = scrollviewSize.width / imageSize.width;
    CGFloat scaleH = scrollviewSize.height / imageSize.height;
    CGFloat finalScale;
    if (scaleW > scaleH) {
        finalScale = scaleH;
    }else{
        finalScale = scaleW;
    }
    self.currentScrollView.minimumZoomScale = finalScale;
    self.currentScrollView.zoomScale = finalScale;
    
    [self centerScrollViewContents];
    //    self.currentImageView.center = CGPointMake(self.currentScrollView.bounds.size.width/2, self.currentScrollView.bounds.size.height/2);
    
}

/**
 *  设置中心
 */
- (void)centerScrollViewContents {
    CGSize scrollviewSize = self.currentScrollView.bounds.size;
    CGRect contentsFrame = self.currentImageView.frame;
    
    if (contentsFrame.size.width < scrollviewSize.width) {
        contentsFrame.origin.x = (scrollviewSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < scrollviewSize.height) {
        contentsFrame.origin.y = (scrollviewSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.currentImageView.frame = contentsFrame;
}

/**
 *  缩放大小获取方法，将点击的点作为中心
 */
- (CGRect)zoomRectForScale:(CGFloat)newscale withCenter:(CGPoint)center andScrollView:(UIScrollView *)scrollV{
    
    CGRect zoomRect = CGRectZero;
    //计算大小
    zoomRect.size.height = scrollV.frame.size.height / newscale;
    zoomRect.size.width = scrollV.frame.size.width  / newscale;
    //计算原点坐标
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

-(void)dealloc
{
    _bkScrollView = nil;
    _leftScrollView = nil;
    _currentScrollView = nil;
    _rightScrollView = nil;
    _leftImageView = nil;
    _currentImageView = nil;
    _rightImageView = nil;
    _imageNames = nil;
    _images = nil;
    _imageURls = nil;
    NSLog(@"SWYPhotoBrowserViewController 释放");
}

@end
