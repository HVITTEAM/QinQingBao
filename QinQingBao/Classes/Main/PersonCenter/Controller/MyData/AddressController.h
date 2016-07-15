//
//  AddressController.h
//  QinQingBao
//
//  Created by 董徐维 on 16/7/15.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "HMCommonViewController.h"

#import "AreaModel.h"

@interface AddressController : HMCommonViewController

/**
 * 初始化参数
 * cityStr 选择的省市区地址
 * streetStr 街道
 * streetCode 街道code
 * areaInfo 详细地址
 */
-(void)setItemInfoWith:(NSString *)cityStr regionStr:(NSString *)regionStr regionCode:(NSString*)regionCode areaInfo:(NSString*)areaInfo;

/**下单修改地址回调block
 * selectedRegionmodel 最后一级的model
 * addressStr 界面显示的整个字符串
 * areaInfo 后台需要的areainfo数据
 */
@property (nonatomic, copy) void (^changeDataBlock)(AreaModel *selectedRegionmodel, NSString *addressStr,NSString *areaInfo);
@end
