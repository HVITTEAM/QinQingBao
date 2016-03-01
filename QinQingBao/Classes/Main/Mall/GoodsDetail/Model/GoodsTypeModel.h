//
//  GoodsTypeModel.h
//  QinQingBao
//
//  Created by 董徐维 on 16/2/29.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsTypeModel : NSObject
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, retain) NSMutableArray *datas;
@property (nonatomic, assign) BOOL selected;
@end
