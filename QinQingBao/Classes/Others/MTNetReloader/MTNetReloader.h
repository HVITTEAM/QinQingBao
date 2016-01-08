//
//  MTNetReloader.h
//
//
//  Created by 董徐维 on 15/12/8.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^ReloadButtonClickBlock)() ;

@interface MTNetReloader : UIView

- (instancetype)initWithFrame:(CGRect)frame
                  reloadBlock:(ReloadButtonClickBlock)reloadBlock ;

- (void)showInView:(UIView *)viewWillShow ;
- (void)dismiss ;

@end

