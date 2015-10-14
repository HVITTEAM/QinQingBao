//
//  SimpleWifi.h
//  VideoGo
//
//  Created by yudan on 14-4-3.
//
//

#import <Foundation/Foundation.h>

@interface EzvizSimpleWifi : NSObject


/**
 *  开始wifi配置
 *
 *  @param strSSID rount ssid
 *  @param strKey  rount key
 *
 *  @return 函数运行成功与否  wifi配置成功与否由boujour返回
 */
- (BOOL)startWifiConfig:(NSString *)strSSID andKey:(NSString *)strKey;

/**
 *  用于支持AES加密设备配置wifi
 *  @param strAESKey 设备加密密钥
 **/
- (BOOL)startWifiConfig:(NSString *)strSSID addKey:(NSString *)strKey secretKey:(NSString *)strAESKey;

/**
 *  停止wifi配置
 */
- (void)stopWifiConfig;

@end


/* **********************  wifi 编码信息  ************************* */

@interface WifiEncodedInfo : NSObject 


@property (nonatomic, assign) unsigned char seq;
@property (nonatomic, assign) unsigned char type;  
@property (nonatomic, assign) unsigned long count;
@property (nonatomic, assign) unsigned char firstData;
@property (nonatomic, assign) unsigned char secondData;

@end