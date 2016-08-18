//
//  ExtendFooterView.h
//  QinQingBao
//
//  Created by shi on 16/8/15.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExtendFooterView : UIView

@property(copy)void(^extendFooterViewTapCallBack)(NSInteger section,BOOL extend);

-(instancetype)initWithTitle:(NSString *)title extendTitle:(NSString *)extendTitle imageName:(NSString *)imageName extend:(BOOL)isExtend section:(NSInteger)section;

@end
