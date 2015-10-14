//
//  ThumbBtnView.m
//  VideoGo
//
//  Created by yudan on 14-5-30.
//
//

#import "ThumbBtnView.h"


@interface ThumbBtnView ()
{
    UIButton * _actionBtn;
    UIImageView * _imgView;
    UIImageView * _imgFront;
    
    NSTimer * _timer;
}

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;

@end


@implementation ThumbBtnView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initView];  
    }
    return self;
}

- (void)dealloc
{
    if ([_timer isValid])
    {
        [_timer invalidate];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)initView
{
    CGRect rcView = self.frame;
    
    self.backgroundColor = [UIColor clearColor];
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rcView.size.width, rcView.size.height)];
    _imgFront = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rcView.size.width, rcView.size.height)];
    
    _imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _imgFront.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _actionBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, rcView.size.width, rcView.size.height)];
    _actionBtn.backgroundColor = [UIColor clearColor];
    [_actionBtn addTarget:self action:@selector(onClickBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_imgView];
    [self addSubview:_imgFront];
    [self addSubview:_actionBtn];
    
}

/**
 *  按钮点击事件
 *
 *  @param target
 *  @param action 按钮点击事件响应函数
 */
- (void)addTarget:(id)target touchAction:(SEL)action
{
    self.target = target;
    self.action = action;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (void)onClickBtn
{
    [self.target performSelector:self.action];
}

#pragma clang diagnostic pop


/**
 *  显示图片
 *
 *  @param strPath 图片路径
 */
- (void)showImage:(NSString *)strPath andWaterImg:(NSString *)strWater
{
    _imgView.image = [UIImage imageWithContentsOfFile:strPath];
    
    _imgFront.image = [UIImage imageNamed:strWater];
    
    if ([_timer isValid])
    {
        [_timer invalidate];
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.5f target:self selector:@selector(hideImgView) userInfo:nil repeats:NO];
    
    self.hidden = NO;
    self.alpha = 1.0f;
}

/**
 *  隐藏
 */
- (void)hideImgView
{
    if ([_timer isValid])
    {
        [_timer invalidate];
    }
    
    _timer = nil;
    
    [UIView animateWithDuration:0.75f animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.alpha = 1.0f;
    }];
    
}

@end
