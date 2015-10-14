//
//  VideoAlarmMsgCell.m
//  VideoGo
//
//  Created by luohs on 11/27/13.
//
//

#import "VideoAlarmMsgCell.h"
#import "YSAlarmInfo.h"

#define BUTTON_HEIGHT 35.0f
#define LABEL_WIDTH         185.0f
#define LABEL_HEIGHT        20.0f
#define TIME_LABEL_HEIGHT   21.0f
#define MARGIN_X            5.0f
#define MARGIN_Y            5.0f
#define PIC_HEIGH           70.0f
#define PIC_WIDTH           95.0f
#define FONT [UIFont systemFontOfSize:15.0f]

@interface VideoAlarmMsgCell()
{
    UIButton *_playReal;
    UIButton *_playBack;
    UIView *_seporatorView;
    UIView *_horizontalSeporatorView;
    
    NSThread *_getPicHandler;
}
@end

@implementation VideoAlarmMsgCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _playReal = [self button:NSLocalizedString(@"Live Video", @"现场视频")];
        [_playReal setImage:[UIImage imageNamed:@"message_play.png"] forState:UIControlStateNormal];
        [_playReal setImage:[UIImage imageNamed:@"message_play_Sel.png"] forState:UIControlStateHighlighted];
        [_playReal setImage:[UIImage imageNamed:@"message_play_dis.png"] forState:UIControlStateDisabled];
        [_playReal addTarget:self action:@selector(onClickPlayReal:) forControlEvents:UIControlEventTouchUpInside];
        _playReal.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [self.contentView addSubview:_playReal];
        
        _playBack = [self button:NSLocalizedString(@"Record File", @"消息录像")];
        [_playBack setImage:[UIImage imageNamed:@"message_video.png"] forState:UIControlStateNormal];
        [_playBack setImage:[UIImage imageNamed:@"message_video_sel.png"] forState:UIControlStateHighlighted];
        [_playBack setImage:[UIImage imageNamed:@"message_video_dis.png"] forState:UIControlStateDisabled];
        [_playBack addTarget:self action:@selector(onClickPlayBack:) forControlEvents:UIControlEventTouchUpInside];
        _playBack.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [self.contentView addSubview:_playBack];
        
        _seporatorView = [[UIView alloc] init];
        [_seporatorView setBackgroundColor:UIColorFromRGB(0xe5e5e5, 1.0)];
        [self.contentView addSubview:_seporatorView];
        
        _horizontalSeporatorView = [[UIView alloc] init];
        [_horizontalSeporatorView setBackgroundColor:UIColorFromRGB(0xe5e5e5, 1.0)];
        [self.contentView addSubview:_horizontalSeporatorView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect backgroundRect = self.contentView.bounds;
    CGRect logoButtonRect = backgroundRect;
    logoButtonRect.size = CGSizeMake(PIC_WIDTH,PIC_HEIGH);
    logoButtonRect.origin.x = MARGIN_X;
    logoButtonRect.origin.y = MARGIN_Y;

    CGRect horizontalSeporatorRect = backgroundRect;
    horizontalSeporatorRect.size = CGSizeMake(backgroundRect.size.width,0.5);
    horizontalSeporatorRect.origin.x = 0;
    horizontalSeporatorRect.origin.y = CGRectGetMaxY(logoButtonRect)+MARGIN_Y;
    _horizontalSeporatorView.frame = horizontalSeporatorRect;
    
    float buttonHeight = backgroundRect.size.height - CGRectGetMaxY(horizontalSeporatorRect);
    CGRect _playBackRect = backgroundRect;
    _playBackRect.size = CGSizeMake(backgroundRect.size.width/2,buttonHeight);
    _playBackRect.origin.x = 0;
    _playBackRect.origin.y = CGRectGetMaxY(horizontalSeporatorRect);
    _playBack.frame = _playBackRect;
    
    CGRect realPlayRect = backgroundRect;
    realPlayRect.size = CGSizeMake(backgroundRect.size.width/2,buttonHeight);
    realPlayRect.origin.x = CGRectGetMaxX(_playBackRect);
    realPlayRect.origin.y = CGRectGetMaxY(horizontalSeporatorRect);
    _playReal.frame = realPlayRect;
    
    CGRect seporatorRect = backgroundRect;
    seporatorRect.size = CGSizeMake(0.5,buttonHeight);
    seporatorRect.origin.x = CGRectGetMaxX(_playBackRect);
    seporatorRect.origin.y = CGRectGetMaxY(horizontalSeporatorRect);
    _seporatorView.frame = seporatorRect;
    
}

#pragma mark -
#pragma mark - private method
- (UIButton *)button:(NSString *)title
{
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [button setTitleColor:UIColorFromRGB(0x555555, 1.0) forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0x555555, 1.0) forState:UIControlStateHighlighted];
    [button setTitleColor:UIColorFromRGB(0xcbcaca, 1.0) forState:UIControlStateDisabled];
    
    return button;
}



- (void)setButtonEdgeInsets:(UIButton *)b
{
    CGPoint buttonBoundsCenter = CGPointMake(CGRectGetMidX(b.bounds), CGRectGetMidY(b.bounds));
    
    // 找出imageView最终的center
    CGPoint endImageViewCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetMidY(b.imageView.bounds));
    
    // 找出titleLabel最终的center
    CGPoint endTitleLabelCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetHeight(b.bounds)-CGRectGetMidY(b.titleLabel.bounds));
    
    // 取得imageView最初的center
    CGPoint startImageViewCenter = b.imageView.center;
    
    // 取得titleLabel最初的center
    CGPoint startTitleLabelCenter = b.titleLabel.center;
    
    // 设置imageEdgeInsets
    CGFloat imageEdgeInsetsTop = endImageViewCenter.y - startImageViewCenter.y;
    CGFloat imageEdgeInsetsLeft = endImageViewCenter.x - startImageViewCenter.x;
    CGFloat imageEdgeInsetsBottom = -imageEdgeInsetsTop;
    CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
    b.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsetsTop, imageEdgeInsetsLeft, imageEdgeInsetsBottom, imageEdgeInsetsRight);
    
    // 设置titleEdgeInsets
    CGFloat titleEdgeInsetsTop = endTitleLabelCenter.y-startTitleLabelCenter.y;
    CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x;
    CGFloat titleEdgeInsetsBottom = -titleEdgeInsetsTop;
    CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
    b.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsetsTop, titleEdgeInsetsLeft, titleEdgeInsetsBottom, titleEdgeInsetsRight);
    
}

#pragma mark -
#pragma mark - property setter & getter

#pragma mark -
#pragma mark - action
- (void)onClickPlayBack:(id)sender
{
    if ([_delegate respondsToSelector:@selector(startPlaybackWithCell:)]) {
        [_delegate startPlaybackWithCell:self];
    }
    
}

- (void)onClickPlayReal:(id)sender
{
    if ([_delegate respondsToSelector:@selector(startRealPlayWithCell:)]) {
        [_delegate startRealPlayWithCell:self];
    }
    
}

#pragma mark -
#pragma mark - dealloc
- (void)dealloc
{
    
    if (_getPicHandler)
    {
        [_getPicHandler cancel];
        _getPicHandler = nil;
    }
}

#pragma mark -
#pragma mark - class method
+ (float)cellHeight
{
    return (MARGIN_Y + PIC_HEIGH + MARGIN_Y + BUTTON_HEIGHT);
}

@end
