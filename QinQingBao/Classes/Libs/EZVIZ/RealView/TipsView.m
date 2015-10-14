//
//  TipsView.m
//  VideoGo
//
//  Created by yudan on 13-4-11.
//
//

#import "TipsView.h"
//#import "RealViewDef.h"
#import "CTimeBarPanel.h"


@implementation TipsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self InitView];
    }
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


- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    
    return self;
}


- (void)InitView
{
    if (_tipsLab == nil)
    {
        _tipsLab = [[UILabel alloc] init];
        _tipsLab.backgroundColor = [UIColor clearColor];
        _tipsLab.textColor = UIColorFromRGB(0x898989, 1.0f);
        _tipsLab.lineBreakMode = NSLineBreakByWordWrapping;
        _tipsLab.numberOfLines = 0;
        _tipsLab.textAlignment = NSTextAlignmentCenter;
        _tipsLab.font = [UIFont systemFontOfSize:18];
        [self addSubview:_tipsLab];
        _tipsLab.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
    
}

- (void)ShowTips:(NSString *)strTips
{
    if (strTips == nil || [strTips isEqualToString:@""])
    {
        _tipsLab.text = [NSString stringWithFormat:@""];
        return;
    }
    
    _tipsLab.text = strTips;
    
    [self LayoutView];
}

- (void)ShowTipsAutoHide:(NSString *)strTips
{
    [self ShowTips:strTips];
    
    [self performSelector:@selector(clearTips) withObject:nil afterDelay:3];
}

- (void)LayoutView
{
    NSString *strTips = [NSString stringWithFormat:@"%@", _tipsLab.text];
    
    CGRect rcView = self.frame;
    float fLabWidth = rcView.size.width - 40;
    CGSize size = [strTips sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(fLabWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    float fHeight = size.height + 9.0f;
        
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
    {
        _tipsLab.frame = CGRectMake(20, rcView.size.height / 2 + 10, fLabWidth, fHeight);
    }
    else
    {
        _tipsLab.frame = CGRectMake(20, rcView.size.height/2 + 10, fLabWidth, fHeight);
    }
    
}

- (void)clearTips
{
    [self performSelectorOnMainThread:@selector(ShowTips:) withObject:nil waitUntilDone:NO];
}

@end
