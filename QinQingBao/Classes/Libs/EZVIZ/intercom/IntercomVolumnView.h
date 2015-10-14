//
//  IntercomVolumnView.h
//  VideoGo
//
//  Created by zhengwen zhu on 9/24/13.
//
//

#import <UIKit/UIKit.h>

static inline double radians (double degrees) { return degrees * M_PI/180; }

#pragma mark -

@interface IntercomVolumnView : UIView
{
    unsigned int      _nValue;
}

@property (nonatomic, assign) unsigned int nValue;  

- (void)drawViewWithIntercomVolumn:(unsigned int)nVolumn;

@end
