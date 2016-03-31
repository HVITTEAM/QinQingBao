//
//  WorkPicModel.h
//  QinQingBao
//
//  Created by shi on 16/3/23.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkPicModel : NSObject

@property(nonatomic, retain) NSString *wid;

@property(nonatomic, retain) NSString *url;

@property(nonatomic, copy) NSMutableArray *pic_info;

@end