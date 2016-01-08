//
//  MTHeardView.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/7.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MTShoppingCarController.h"

typedef void (^clickBlock)(UIButton *);
@interface MTHeardView : UIView

@property(nonatomic,copy)clickBlock blockBT;

- (instancetype)initWithFrame:(CGRect)frame section :(NSInteger )section carDataArrList:(NSMutableArray *)carDataArrList block:(void (^)(UIButton *))blockbt;



@end
