//
//  YSHTTPClient.h
//  EzvizRealPlay
//
//  Created by zhengwen zhu on 7/10/14.
//  Copyright (c) 2014 yudan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ERROR_PARAMETER                     10001 // 参数错误
#define ERROR_TOKEN_EXCEPTION               10002 // access_tocken异常
#define ERROR_TOKEN_EXPIRED                 10003 // access_tocken过期
#define ERROR_ACCOUNT                       10004 // 用户名或者密码错误
#define ERROR_APPKEY_EXCEPTION              10005 // appKey异常
#define ERROR_CHANNEL_NONEXIST              20001 // 通道不存在
#define ERROR_DEVICE_NONEXIST               20002 // 设备不存在
#define ERROR_FEATURECODE_NULL              20003 // 硬件特征码为空，版本过低
#define ERROR_FEATURECODE_VERIFICATION      20004 // 硬件特征码检测失败，版本过低
#define ERROR_FEATURECODE_OPERATION         20005 // 硬件特征码操作失败
#define ERROR_NETWORK_EXCEPTION             20006 // 网络异常
#define ERROR_DEVICE_OFFLINE                20007 // 设备不在线
#define ERROR_DEVICE_TIMEOUT                20008 // 设备响应超时
#define ERROR_SERVER_EXCEPTION              50000 // 服务器异常


/**
 *  http 请求回调
 *
 *  @param responseObject json 字符串
 *  @param error          网络异常错误
 *
 *  @since v1.0.0.0
 */
typedef void (^ComplitionBlock)(id responseObject, NSError *error);

@class YSAlarmSearchInfo;

@interface YSHTTPClient : NSObject

/**
 *  网络请求单例
 *
 *  @return 单例
 *
 *  @since v1.0.0.0
 */
+ (YSHTTPClient *)sharedInstance;

/**
 *  设置app 信息
 *
 *  @param appKey    appkey
 */
- (void)setClientAppKey:(NSString *)appKey;

/**
 *  设置客户端访问令牌
 *
 *  @param token 令牌字符串
 *
 *  @since v1.0.0.0
 */
- (void)setClientAccessToken:(NSString *)token;

/**
 *  请求摄像头列表
 *
 *  @param pageNo 开始请求页
 *  @param size   单页大小
 *  @param block  块回调
 *
 *  @since v1.0.0.0
 */
- (void)requestSearchCameraListPageFrom:(NSInteger)pageNo pageSize:(NSInteger)size complition:(ComplitionBlock)block;

/**
 *  请求报警录像列表
 *
 *  @param cameraId 摄像头id
 *  @param info     报警搜索参数对象
 *  @param pageNo   开始请求页
 *  @param size     单页大小
 *  @param block    块回调
 *
 *  @since v1.0.0.0
 */
- (void)requestSearchAlarmListWithCameraId:(NSString *)cameraId
                           alarmSearchInfo:(YSAlarmSearchInfo *)info
                                  pageFrom:(NSInteger)pageNo
                                  pageSize:(NSInteger)size
                                complition:(ComplitionBlock)block;

/**
 *  请求云服务器上面的录像列表
 *
 *  @param cameraId  摄像头id
 *  @param startTime 查询开始时间
 *  @param endTime   查询结束时间
 *  @param pageNo    开始请求页
 *  @param size      单页大小
 *  @param block     块回调
 *
 *  @since v1.0.0.0
 */
- (void)requestSearchCloudRecordListWithCameraId:(NSString *)cameraId
                                        timeFrom:(NSString *)startTime
                                              to:(NSString *)endTime
                                        pageFrom:(NSInteger)pageNo
                                        pageSize:(NSInteger)size
                                    complication:(ComplitionBlock)block;

/**
 *  请求从用户列表中删除设备
 *
 *  @param deviceId 设备id
 *  @param block    块回调
 *
 *  @since v1.0.0.0
 */
- (void)requestDeleteDeviceWithDeviceId:(NSString *)deviceId complition:(ComplitionBlock)block;

/**
 *  获取指定录像uuid 的抓图
 *
 *  @param recordUUID 录像 uuid
 *  @param pixel      图片宽度, 合法值区间(0- 1280]像素
 *  @param block      如果成功, 返回UIImage对象
 */
- (void)requestGetDevicePictureWithUUID:(NSString *)recordUUID
                             imageWidth:(NSInteger)pixel
                           complication:(ComplitionBlock)block;

/**
 *  请求短信验证码
 *
 *  @param signString 平台获取的签名字符串
 *  @param block      请求成功返回短信验证码， 失败返回错误信息
 */
- (void)requestGetSMSVerificationCodeWithSign:(NSString *)signString
                                 complication:(ComplitionBlock)block;

/**
 *  校验用户短信验证码
 *
 *  @param theType 标识请求的用途， 1: 帐号绑定获取用户accessToken, 2: 硬件特征码校验
 *  @param uid     用户标识符id
 *  @param no      用户手机号码
 *  @param code    短信验证码
 *  @param block   校验成功返回 200， 失败返回错误码
 */
- (void)requestCheckSMSVerificationCodeWithType:(NSInteger)theType
                                         userId:(NSString *)uid
                                    phoneNumber:(NSString *)no
                               verificationCode:(NSString *)code
                                   complication:(ComplitionBlock)block;
/**
 *  获取视频广场栏位
 *
 *  @param block 查询成功, 回调视频广场栏目信息
 */
- (void)requestSquareColumnWithComplication:(ComplitionBlock)block;

/**
 *  获取视频广场资源
 *
 *  @param longitude      经度(可选)
 *  @param latitude       维度(可选)
 *  @param range          范围(可选)
 *  @param thirdComment   第三方扩展字段(可选)
 *  @param cameraName     视频名称(可选)
 *  @param viewSort       是否按观看次数排序：0：不排序，1：降序排序(可选)
 *  @param cameraNameSort 是否按视频名称排序：0：不排序，1：降序排序(可选)
 *  @param rangeSort      是否按照距离由近及远排序，0：不排序，1：排序(可选)
 *  @param channel        广场频道
 *  @param pageStart      分页起始页
 *  @param pageSize       分页大小
 *  @param block
 */
- (void)requestSquareVideoListWithLongitude:(NSString *)longitude
                                   latitude:(NSString *)latitude
                                      range:(NSString *)range
                               thirdComment:(NSString *)thirdComment
                                 cameraName:(NSString *)cameraName
                                   viewSort:(int)viewSort
                             cameraNameSort:(int)cameraNameSort
                                  rangeSort:(int)rangeSort
                                    channel:(int)channel
                                   pageFrom:(int)pageStart
                                   pageSize:(int)pageSize
                                 complition:(ComplitionBlock)block;

/**
 *  收藏公共视频广场资源
 *
 *  @param squareId 视频广场id
 *  @param block
 */
- (void)requestSaveFavoriteSquareVideo:(NSString *)squareId
                            complition:(ComplitionBlock)block;

/**
 *  取消公共视频广场资源收藏
 *
 *  @param squareId 视频广场id
 *  @param block
 */
- (void)requestDeleteFavoriteSquareVideo:(NSString *)squareId
                              complition:(ComplitionBlock)block;

/**
 *  获取收藏的公共视频资源
 *
 *  @param pageStart 分页起始页
 *  @param pageSize  分页大小
 *  @param block
 */
- (void)requestGetFavoriteSquareVideoListPageFrom:(NSInteger)pageStart
                                         pageSize:(NSInteger)pageSize
                                       complition:(ComplitionBlock)block;

/**
 *  判断视频资源是否已被用户收藏
 *
 *  @param squareIds 视频广场资源Id
 *  @param block
 */
- (void)requestCheckSquareVideoFavoritedWith:(NSArray *)squareIds
                                  complition:(ComplitionBlock)block;

/**
 *  设置报警消息已读
 *
 *  @param block
 */
- (void)requestMarkAlarmMessageAsReadComplition:(ComplitionBlock)block;

/**
 *  获取单个设备信息
 *
 *  @param serial 设备序列号
 *  @param block
 */
- (void)requestSearchDeviceInfoWithDeviceSerial:(NSString *)serial
                                     complition:(ComplitionBlock)block;


#pragma mark - System Inc. API

/**
 *  用户注册
 *
 *  @param cityKey     城市代码(可选)
 *  @param userName    用户名
 *  @param password    密码
 *  @param phoneNumber 手机号码
 *  @param block
 */
- (void)requestUserRegisteWithCity:(NSString *)cityKey
                          userName:(NSString *)userName
                          password:(NSString *)password
                           phoneNo:(NSString *)phoneNumber
                        complition:(ComplitionBlock)block;

/**
 *  查询所有已建城市
 *
 *  @param pageStart 分页起始页
 *  @param pageSize  分页大小
 *  @param block
 */
- (void)requestGetConfiggedCityListPageFrom:(NSInteger)pageStart
                                   pageSize:(NSInteger)pageSize
                                 complition:(ComplitionBlock)block;

/**
 *  查询对应城市的配置
 *
 *  @param cityKey 城市代码
 *  @param block
 */
- (void)requestGetCityConfigurationWithCityKey:(NSString *)cityKey
                                    complition:(ComplitionBlock)block;

/**
 *  获取重置密码短信验证码
 *
 *  @param account 手机号或用户名
 *  @param block
 */
- (void)requestResetUserPasswordSmsCodeWithAccount:(NSString *)account
                                        complition:(ComplitionBlock)block;

/**
 *  重置账号密码
 *
 *  @param account     用户登录名或手机号
 *  @param smsCode     短信验证码
 *  @param newPassword 新的密码
 *  @param block
 */
- (void)requestResetUserPasswordWithAccount:(NSString *)account
                                    smsCode:(NSString *)smsCode
                                newPassword:(NSString *)newPassword
                                 complition:(ComplitionBlock)block;

/**
 *  用户退出登录
 *
 *  @param block
 */
- (void)requestUserLogoutWithComplition:(ComplitionBlock)block;


/**
 *  透传接口
 *
 *  @param requestString 透传参数（指定的格式的JSON字符串）
 *  @param completion    返回数据
 */
- (void)requestTransferWithReqStr:(NSString *)requestString
                       completion:(void (^)(id responseObject, NSError *error))completion;


@end


#pragma mark - YSAlarmSearchInfo

@interface YSAlarmSearchInfo : NSObject

@property (nonatomic, copy) NSString *startTime;     // 报警查询开始时间 时间格式为：2013-09-05 09:38:48
@property (nonatomic, copy) NSString *endTime;       // 报警查询结束时间 时间格式为：2013-09-05 09:38:48
@property (nonatomic, assign) NSInteger alarmType;   // 报警类型
@property (nonatomic, copy) NSString *status;        // 报警消息状态

@end