//
//  TipsPublicView.m
//  VideoGo
//
//  Created by yudan on 14-4-4.
//
//

#import "TipsPublicView.h"

@implementation TipsPublicView

@synthesize tipsLab = _tipsLab;
@synthesize backBtn = _backBtn;
@synthesize menuBtn = _menuBtn;
@synthesize bgImgView = _bgImgView;
@synthesize bottomView = _bottomView;

@dynamic strTitle;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self initView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)strTitle
{
    self = [self initWithFrame:frame];
    
    self.strTitle = strTitle;
    
    return self;
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
    
    _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -20, rcView.size.width, rcView.size.height+20)];
    _bgImgView.image = [UIImage imageNamed:@"title.png"];
    _tipsLab.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_bgImgView];
    
    _tipsLab = [[UILabel alloc] initWithFrame:CGRectMake(68, 0, rcView.size.width - 136, rcView.size.height)];
    _tipsLab.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
    _tipsLab.textAlignment = NSTextAlignmentCenter;
    _tipsLab.font = [UIFont systemFontOfSize:20.0f];
    _tipsLab.backgroundColor = [UIColor clearColor];
    [self addSubview:_tipsLab];
    
    _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, 0, 60, 44)];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"Back_Bnt.png"] forState:UIControlStateNormal];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"BackBnt_sel"] forState:UIControlStateHighlighted];
    [_backBtn setTitleColor:UIColorFromRGB(0x454545, 1.0f) forState:UIControlStateNormal];
    [_backBtn setTitleColor:UIColorFromRGB(0x454545, 1.0f) forState:UIControlStateHighlighted];
    _backBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    _backBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:_backBtn];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, rcView.size.height-1, rcView.size.width, 1)];
    _bottomView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    _bottomView.backgroundColor = UIColorFromRGB(0xc8c7cc, 1.0f);
    [self addSubview:_bottomView];

}

- (NSString *)strTitle
{
    return _tipsLab?_tipsLab.text:nil;
}

- (void)setStrTitle:(NSString *)strTitle
{
    if (_tipsLab)
    {
        _tipsLab.text = strTitle;
    }
}

/**
 *  显示menu按钮
 */
- (void)showMenuBtn
{
    if (!_menuBtn)
    {
        _menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(260, 0, 60, 44)];
        _menuBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:_menuBtn];
    }
    
    _menuBtn.hidden = NO;
}

/**
 *  隐藏menu按钮
 */
- (void)hideMenuBtn
{
    _menuBtn.hidden = YES;  
}

/**
 *  增加返回按钮点击触发时间
 *
 *  @param action 事件响应函数
 */
- (void)addBackBtnTouchEvent:(id)target action:(SEL)action
{
    if (_backBtn)
    {
        [_backBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
}

/**
 *  增加菜单按钮响应时间
 *
 *  @param action       事件响应函数
 *  @param controlEvent 响应事件类型
 */
- (void)addMenuBtnTouchEvent:(id)target action:(SEL)action andEvent:(UIControlEvents)controlEvent
{
    if (_menuBtn)
    {
        [_menuBtn addTarget:target action:action forControlEvents:controlEvent];
    }
}

@end
