//
//  IntercomCtrlView.m
//  VideoGo
//
//  Created by yudan on 13-9-29.
//
//

#import "IntercomCtrlView.h"
#import "IntercomVolumnView.h"
//#import "VoiceMailViewController.h"

@interface IntercomCtrlView()
{
    UIButton             *_ctrlBtn;
    IntercomVolumnView   *_volumnView;
    UILabel              *_labTips;
    
    unsigned int         *_nVolume;  
}

@property (nonatomic, assign) int nVolumn; 

@end

@implementation IntercomCtrlView

@synthesize delegate = _delegate;
@synthesize bUseForMail = _bUseForMail;

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame withType:IntercomVolumnViewTypeWithoutButton forMail:NO];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withType:(IntercomVolumnViewType)type forMail:(BOOL)bUseForMail
{
    self = [super initWithFrame:frame];
    if (self) {
        self.ivType = type;
        self.nVolumn = 0;
        self.bUseForMail = bUseForMail;
        [self initSubView:type];
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



#pragma mark - Private

- (void)initSubView:(IntercomVolumnViewType)type
{
    self.backgroundColor = [UIColor clearColor];
    
    CGRect frame = self.frame;
    frame.origin = CGPointMake(0, 0);
    
    _volumnView = [[IntercomVolumnView alloc] initWithFrame:frame];
    _volumnView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_volumnView];
    
    const NSUInteger width = 93;
    const NSUInteger height = 93;
    const NSUInteger x = (self.frame.size.width - 93) / 2;
    const NSUInteger y = (self.frame.size.height - 93) / 2;
    
    if (IntercomVolumnViewTypeWithButton == type) {
        NSString * strImg;
        NSString * strImgH;
        strImg = @"spkBtn.png";
        strImgH = @"spkBtn_sel.png";
        
        UIImage *img = [UIImage imageNamed:strImg];
        UIImage *hImg = [UIImage imageNamed:strImgH];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [btn setBackgroundImage:img forState:UIControlStateNormal];
        [btn setBackgroundImage:hImg forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(touchDownOnIntercomButton) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(touchUpInsideOnIntercomButton) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(touchUpOutsideOnIntercomButton) forControlEvents:UIControlEventTouchUpOutside];
        [self addSubview:btn];
        
    }
    else
    {
        UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        img.image = [UIImage imageNamed:@"spkImg.png"];
        [self addSubview:img];
    }
    
}

- (void)drawViewWithIntercomVolumn:(unsigned int)nVolumn
{
    [_volumnView drawViewWithIntercomVolumn: nVolumn];
}

- (void)touchDownOnIntercomButton
{
    if ([self.delegate respondsToSelector:@selector(didTouchDownOnIntercomButton)]) {
        [self.delegate didTouchDownOnIntercomButton];
    }
}

- (void)touchUpInsideOnIntercomButton
{
    if ([self.delegate respondsToSelector:@selector(didTouchUpInsideOnIntercomButton)]) {
        [self.delegate didTouchUpInsideOnIntercomButton];
    }
}

- (void)touchUpOutsideOnIntercomButton
{
    if ([self.delegate respondsToSelector:@selector(didTouchUpOutsideOnIntercomButton)])
    {
        [self.delegate didTouchUpOutsideOnIntercomButton];
    }
}

@end
