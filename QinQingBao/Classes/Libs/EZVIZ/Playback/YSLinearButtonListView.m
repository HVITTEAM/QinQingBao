//
//  YSLinearButtonListView.m
//  VideoGo
//
//  Created by zhengwen zhu on 6/21/14.
//
//

#import "YSLinearButtonListView.h"
#import "ThumbBtnView.h"
#import "RecordingBtnView.h"
#import "RealFluxDataView.h"

const CGFloat seperator = 25.0f;
const CGFloat verticalButtonWidth = 64.0;
const CGFloat verticalButtonHeight = 64.0;
const CGFloat buttonWidth = 50.0;
const CGFloat buttonHeight = 50.0;

const NSUInteger listCount = 2;

@interface YSLinearButtonListView ()

@property (nonatomic, retain, readwrite) NSMutableArray *arrayButtons;
@property (nonatomic, assign, readwrite) BOOL layoutVertical;
@property (nonatomic, retain) UILabel *lblTraffic;

@end

@implementation YSLinearButtonListView

- (id)initWithFrame:(CGRect)frame layoutVertical:(BOOL)vertical
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _layoutVertical = vertical;
        _arrayButtons = [[NSMutableArray alloc] init];
        [self addContentSubviews];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _arrayButtons = [[NSMutableArray alloc] init];
        [self addContentSubviews];
    }
    return self;
}

- (void)reloadContentSubviewsWithVertical:(BOOL)vertical
{
    _layoutVertical = vertical;
    
    [_arrayButtons removeAllObjects];

    [_lblTraffic removeFromSuperview];
    while ([self.subviews lastObject])
    {
        UIView *view = [self.subviews lastObject];
        [view removeFromSuperview];
    }
    
    [self addContentSubviews];
}

- (RecordingBtnView *)recordView
{
    if (_layoutVertical)
    {
        return [_arrayButtons objectAtIndex:1];
    }
    else
    {
        return [_arrayButtons objectAtIndex:2];
    }
}

- (void)updateTrafficValue:(float)value downloadSpeed:(NSString *)speed totalValue:(NSString *)total
{
    if (!_layoutVertical)
    {
        RealFluxDataView *flux = [_arrayButtons objectAtIndex:3];
        [flux updateData:value];
        
        _lblTraffic.text = [NSString stringWithFormat:@"%@\n%@", speed, total];
    }
}

- (void)setPauseButtonImage:(UIImage *)image hightedImage:(UIImage *)hightedImage
{
    if (_layoutVertical)
    {
        UIButton *pause = [_arrayButtons objectAtIndex:0];
        if (pause)
        {
            [pause setImage:image forState:UIControlStateNormal];
            [pause setImage:hightedImage forState:UIControlStateHighlighted];
        }
    }

}

- (void)resetAccessoryButtonImage
{
    if (!_layoutVertical)
    {
        UIButton *accessory = [_arrayButtons objectAtIndex:4];
        if (accessory)
        {
            [accessory setBackgroundImage:[UIImage imageNamed:@"palyback_full_up.png"] forState:UIControlStateNormal];
            [accessory setBackgroundImage:[UIImage imageNamed:@"palyback_full_up.png"] forState:UIControlStateHighlighted];
        }
    }
}

- (void)enableListButtons:(BOOL)enable
{
    for (UIView *aView in _arrayButtons)
    {
        if ([aView isKindOfClass:[UIButton class]])
        {
            ((UIButton *)aView).enabled = enable;
        }
        else if ([aView isKindOfClass:[RecordingBtnView class]])
        {
            [((RecordingBtnView *)aView) enableBtn:enable];
        }
    }
}

#pragma mark - Private

- (void)addContentSubviews
{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat x = 0;
    CGFloat y = 0;
    
    if (_layoutVertical)
    {
        x = (width - verticalButtonWidth)/2;
        y = (height - verticalButtonHeight) / 2;
        
        UIButton *capture = [[UIButton alloc] initWithFrame:CGRectMake(x, y, verticalButtonWidth, verticalButtonHeight)];
        [capture setImage:[UIImage imageNamed:@"full_pause.png"] forState:UIControlStateNormal];
        [capture setImage:[UIImage imageNamed:@"full_pause_sel.png"] forState:UIControlStateHighlighted];
        [capture setImage:[UIImage imageNamed:@"previously_disable.png"] forState:UIControlStateDisabled];
        [capture addTarget:self action:@selector(clickOnButton:) forControlEvents:UIControlEventTouchUpInside];
        capture.tag = 0;
        [_arrayButtons addObject:capture];
    }
    else
    {
        CGFloat gap = 85.0;
        x = gap;
        y = 0;
        
        // left side buttons
        UIButton *pause = [[UIButton alloc] initWithFrame:CGRectMake(x, y, buttonWidth, buttonHeight)];
        pause.tag = 0;
        [pause setImage:[UIImage imageNamed:@"full_pause.png"] forState:UIControlStateNormal];
        [pause setImage:[UIImage imageNamed:@"full_pause_sel.png"] forState:UIControlStateHighlighted];
        [pause addTarget:self action:@selector(clickOnButton:) forControlEvents:UIControlEventTouchUpInside];
        [_arrayButtons addObject:pause];
        
        x += seperator + buttonWidth;
        UIButton *capture = [[UIButton alloc] initWithFrame:CGRectMake(x, y, buttonWidth, buttonHeight)];
        [capture setImage:[UIImage imageNamed:@"full_previously.png"] forState:UIControlStateNormal];
        [capture setImage:[UIImage imageNamed:@"full_previously_sel.png"] forState:UIControlStateHighlighted];
        [capture addTarget:self action:@selector(clickOnButton:) forControlEvents:UIControlEventTouchUpInside];
        capture.tag = 1;
        [_arrayButtons addObject:capture];
        
        x += seperator + buttonWidth;
        RecordingBtnView *record = [[RecordingBtnView alloc] initWithFrame:CGRectMake(x, y, buttonWidth, buttonHeight)];
        [record addBtnClickEvent:self sel:@selector(clickOnButton:)];
        record.tag = 2;
        [record setButtonImage:[UIImage imageNamed:@"full_video.png"]
                highlightImage:[UIImage imageNamed:@"full_video_sel.png"]];
        [record setRecordingButtonImage:[UIImage imageNamed:@"full_video_now.png"]
                         highlightImage:[UIImage imageNamed:@"full_video_now_sel.png"]];
        [_arrayButtons addObject:record];
        
        // right side buttons
        x = width - (seperator + buttonWidth) * 2.0;
        RealFluxDataView *flux = [[RealFluxDataView alloc] initWithFrame:CGRectMake(x, 0, buttonWidth, buttonHeight)];
        flux.backgroundColor = [UIColor clearColor];
        flux.tag = 3;
        UILabel *lblValue = [[UILabel alloc] initWithFrame:CGRectMake(2, 10, flux.frame.size.width - 4, flux.frame.size.height - 20)];
        lblValue.backgroundColor = [UIColor clearColor];
        lblValue.font = [UIFont systemFontOfSize:10.0f];
        lblValue.numberOfLines = 2;
        lblValue.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
        lblValue.textAlignment = NSTextAlignmentCenter;
        [flux addSubview:lblValue];
        self.lblTraffic = lblValue;
        [_arrayButtons addObject:flux];
        
        x += seperator + buttonWidth;
        UIButton *accessory = [[UIButton alloc] initWithFrame:CGRectMake(x, y, buttonWidth, buttonHeight)];
        [accessory setBackgroundImage:[UIImage imageNamed:@"palyback_full_up.png"] forState:UIControlStateNormal];
        [accessory setBackgroundImage:[UIImage imageNamed:@"palyback_full_up.png"] forState:UIControlStateHighlighted];
        [accessory addTarget:self action:@selector(clickOnButton:) forControlEvents:UIControlEventTouchUpInside];
        accessory.tag = 4;
        [_arrayButtons addObject:accessory];
    }
    
    for (UIView *view in _arrayButtons)
    {
        [self addSubview:view];
    }
}

- (void)clickOnButton:(UIView *)sender
{
    if ([_myDelegate respondsToSelector:@selector(buttonListView:didSelectButton:)])
    {
        [_myDelegate buttonListView:self didSelectButton:sender];
    }
}

@end
