//
//  LoopImageView.h
//  QinQingBao
//
//  Created by shi on 16/9/9.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoopImageView : UIView

@property (strong, nonatomic) NSArray *imageUrls;

@property (strong, nonatomic) void(^tapLoopImageCallBack)(NSInteger idx);

- (void)stopAutoScroll;

@end
