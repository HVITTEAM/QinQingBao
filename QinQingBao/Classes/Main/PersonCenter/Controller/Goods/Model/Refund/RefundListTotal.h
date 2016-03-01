//
//  RefundListTotal.h
//  QinQingBao
//
//  Created by shi on 16/2/29.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RefundListTotal : NSObject

@property(copy,nonatomic)NSString *code;

@property(copy,nonatomic)NSString *hasmore;

@property(copy,nonatomic)NSString *page_total;

@property(strong,nonatomic)NSMutableArray *datas;

@end
