//
//  DetailImgModel.h
//  QinQingBao
//
//  Created by 董徐维 on 16/9/27.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailImgModel : NSObject
@property (nonatomic, copy) NSString *src;
/** 图片尺寸 */
@property (nonatomic, copy) NSString *pixel;
/** 图片所处的位置 */
@property (nonatomic, copy) NSString *ref;

@property (nonatomic, copy) NSString *alt;

@end
