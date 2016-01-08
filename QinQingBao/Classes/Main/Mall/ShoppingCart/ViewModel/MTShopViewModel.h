//
//  MTShopViewModel.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/7.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^NumPriceBlock)();

@interface MTShopViewModel : NSObject

@property(nonatomic,copy)NumPriceBlock priceBlock;

- (void)getShopData:(void (^)(NSArray * commonArry, NSArray * kuajingArry))shopDataBlock  priceBlock:(void (^)()) priceBlock;

- (void)getNumPrices:(void (^)()) priceBlock;

-(void)clickAllBT:(NSMutableArray *)carDataArrList bt:(UIButton *)bt;

- (NSDictionary *)verificationSelect:(NSMutableArray *)arr type:(NSString *)type;

- (void)pitchOn:(NSMutableArray *)carDataArrList;

@end
