//
//  MedicineinfoModel.h
//  QinQingBao
//
//  Created by 董徐维 on 15/10/29.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MedicineinfoModel : NSObject
/**服药信息编号**/
@property (nonatomic, assign) NSString *medid;
/**高血压专项信息编号**/
@property (nonatomic, assign) NSString *hyid;
/**药物名称**/
@property (nonatomic, copy) NSString *medname;
/**剂量 **/
@property (nonatomic, copy) NSString *dose;
/**剂量**/
@property (nonatomic, copy) NSString *date;
@end
