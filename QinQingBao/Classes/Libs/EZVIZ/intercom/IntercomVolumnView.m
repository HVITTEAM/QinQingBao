//
//  IntercomVolumnView.m
//  VideoGo
//
//  Created by zhengwen zhu on 9/24/13.
//
//

#import "IntercomVolumnView.h"


#define   GEOMETRIC_FACTOR      1.2           // 等比系数
#define   AVERAGE_FACTOR        5             // 平均系数


@interface IntercomVolumnView()
{
    float             _fRadioSpace;
    
    int               _nSumValue;
    int               _nTimeSpace;
    int               _nLastValue;
}

@end

@implementation IntercomVolumnView

@synthesize nValue = _nValue;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    
        _nSumValue = 0;
        _nTimeSpace = 0;
        _nLastValue = 0;
        
        _fRadioSpace = (frame.size.width - 93.0)/2.0 * (1 - GEOMETRIC_FACTOR) / (1 - pow(GEOMETRIC_FACTOR, 10));
        
        self.backgroundColor = [UIColor clearColor];  
        
    }
    return self;
}


#pragma mark - Public

- (void)drawViewWithIntercomVolumn:(unsigned int)nVolumn
{
    _nTimeSpace++;
    _nSumValue += nVolumn;
    
    if (_nTimeSpace >= AVERAGE_FACTOR)
    {
        int nValue = _nSumValue / AVERAGE_FACTOR / 10 + 1;
        _nTimeSpace = 0;
        _nSumValue = 0;

        while (nValue != self.nValue)
        {
            self.nValue < nValue?self.nValue++:self.nValue--;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self setNeedsDisplay];
            });
            
            usleep(20 * 1000);
        }
        
    }

}


@end
