//
//  IntercomCtrlView.h
//  VideoGo
//
//  Created by yudan on 13-9-29.
//
//

#import <UIKit/UIKit.h>


typedef enum _IntercomVolumnViewType {
    IntercomVolumnViewTypeWithButton,
    IntercomVolumnViewTypeWithoutButton
}IntercomVolumnViewType;

@class IntercomVolumnView;

@protocol IntercomCtrlViewDelegate <NSObject>

- (void)didTouchDownOnIntercomButton;
- (void)didTouchUpInsideOnIntercomButton;
- (void)didTouchUpOutsideOnIntercomButton;

@end


@interface IntercomCtrlView : UIView
{
    IntercomVolumnViewType         _ivType;
    BOOL                           _bUseForMail;
    
}

@property (nonatomic, assign) IntercomVolumnViewType ivType;
@property (assign) BOOL bUseForMail;
@property (nonatomic, assign) id<IntercomCtrlViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withType:(IntercomVolumnViewType)type forMail:(BOOL)bUseForMail;

- (void)drawViewWithIntercomVolumn:(unsigned int)nVolumn;


@end
