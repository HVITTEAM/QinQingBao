//
//  MTSMSHelper.m
//  QinQinBao
//
//  Created by 董徐维 on 15/6/24.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "MTSMSHelper.h"

@interface MTSMSHelper ()
{
    CountryAndAreaCode* _data2;
    NSString* _str;
    NSMutableData* _data;
    int _state;
    NSString* _localPhoneNumber;
    
    NSString* _localZoneNumber;
    NSString* _appKey;
    NSString* _duid;
    NSString* _token;
    NSString* _appSecret;
    
    NSMutableArray* _areaArray;
    NSString* _defaultCode;
    NSString* _defaultCountryName;
}

@end

@implementation MTSMSHelper

+(MTSMSHelper *)sharedInstance
{
    static MTSMSHelper *smsHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        smsHelper = [[MTSMSHelper alloc] init];
    });
    return smsHelper;
}

/**
 * 验证是否通过
 **/
-(BOOL)checkCode:(NSString *)telNumber
{
    BOOL state;
    [SMS_SDK commitVerifyCode:telNumber result:^(enum SMS_ResponseState state) {
        if (1 == state)
        {
            NSLog(@"验证成功");
            state = YES;
        }
        else if(0==state)
        {
            NSLog(@"验证失败");
            state = NO;
        }
    }];
    return state;
}

/**
 * 发送验证码
 **/
-(void)getCheckcode:(NSString *)telNumber
{
    [self setTheLocalAreaCode];
    
    self.telNum = telNumber;
    
    int compareResult = 0;
    for (int i=0; i<_areaArray.count; i++)
    {
        NSDictionary* dict1=[_areaArray objectAtIndex:i];
        NSString* code1 = [dict1 valueForKey:@"zone"];
        if ([code1 isEqualToString:[self.areaCode stringByReplacingOccurrencesOfString:@"+" withString:@""]]) {
            compareResult=1;
            NSString* rule1=[dict1 valueForKey:@"rule"];
            NSPredicate* pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",rule1];
            BOOL isMatch=[pred evaluateWithObject:telNumber];
            if (!isMatch)
            {
                //手机号码不正确
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"notice", nil)
                                                              message:NSLocalizedString(@"errorphonenumber", nil)
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                                    otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            break;
        }
    }
    
    if (!compareResult)
    {
        if (telNumber.length!=11)
        {
            //手机号码不正确
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"notice", nil)
                                                          message:NSLocalizedString(@"errorphonenumber", nil)
                                                         delegate:self
                                                cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                                otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    
    NSString* str=[NSString stringWithFormat:@"%@:%@ %@",NSLocalizedString(@"我们将发送验证码到这个号码", nil),self.areaCode,telNumber];
    _str=[NSString stringWithFormat:@"%@",telNumber];
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"确认手机号码", nil)
                                                  message:str delegate:self
                                        cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                        otherButtonTitles:NSLocalizedString(@"好", nil), nil];
    [alert show];
}

/**
 * 选择是否确定发送
 **/
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1==buttonIndex)
    {
        //        VerifyViewController* verify=[[VerifyViewController alloc] init];
        NSString* str2=[self.areaCode stringByReplacingOccurrencesOfString:@"+" withString:@""];
        //        [verify setPhone:self.telField.text AndAreaCode:str2];
        [SMS_SDK getVerificationCodeBySMSWithPhone:self.telNum
                                              zone:str2
                                            result:^(SMS_SDKError *error)
         {
             if (!error)
             {
                 //倒计时
                 self.sureSendSMS();
             }
             else
             {
                 UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"codesenderrtitle", nil)
                                                               message:[NSString stringWithFormat:@"状态码：%zi ,错误描述：%@",error.errorCode,error.errorDescription]
                                                              delegate:self
                                                     cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                                     otherButtonTitles:nil, nil];
                 [alert show];
             }
         }];
    }
}

/**
 * 获取支持的地区列表
 **/
-(void)setTheLocalAreaCode
{
    [SMS_SDK getZone:^(enum SMS_ResponseState state, NSArray *array)
     {
         if (1 == state)
         {
             NSLog(@"get the area code sucessfully");
             //区号数据
             _areaArray=[NSMutableArray arrayWithArray:array];
         }
         else if (0 == state)
         {
             NSLog(@"failed to get the area code");
         }
     }];
    
    
    NSLocale *locale = [NSLocale currentLocale];
    
    NSDictionary *dictCodes = [NSDictionary dictionaryWithObjectsAndKeys:@"972", @"IL",
                               @"93", @"AF", @"355", @"AL", @"213", @"DZ", @"1", @"AS",
                               @"376", @"AD", @"244", @"AO", @"1", @"AI", @"1", @"AG",
                               @"54", @"AR", @"374", @"AM", @"297", @"AW", @"61", @"AU",
                               @"43", @"AT", @"994", @"AZ", @"1", @"BS", @"973", @"BH",
                               @"880", @"BD", @"1", @"BB", @"375", @"BY", @"32", @"BE",
                               @"501", @"BZ", @"229", @"BJ", @"1", @"BM", @"975", @"BT",
                               @"387", @"BA", @"267", @"BW", @"55", @"BR", @"246", @"IO",
                               @"359", @"BG", @"226", @"BF", @"257", @"BI", @"855", @"KH",
                               @"237", @"CM", @"1", @"CA", @"238", @"CV", @"345", @"KY",
                               @"236", @"CF", @"235", @"TD", @"56", @"CL", @"86", @"CN",
                               @"61", @"CX", @"57", @"CO", @"269", @"KM", @"242", @"CG",
                               @"682", @"CK", @"506", @"CR", @"385", @"HR", @"53", @"CU",
                               @"537", @"CY", @"420", @"CZ", @"45", @"DK", @"253", @"DJ",
                               @"1", @"DM", @"1", @"DO", @"593", @"EC", @"20", @"EG",
                               @"503", @"SV", @"240", @"GQ", @"291", @"ER", @"372", @"EE",
                               @"251", @"ET", @"298", @"FO", @"679", @"FJ", @"358", @"FI",
                               @"33", @"FR", @"594", @"GF", @"689", @"PF", @"241", @"GA",
                               @"220", @"GM", @"995", @"GE", @"49", @"DE", @"233", @"GH",
                               @"350", @"GI", @"30", @"GR", @"299", @"GL", @"1", @"GD",
                               @"590", @"GP", @"1", @"GU", @"502", @"GT", @"224", @"GN",
                               @"245", @"GW", @"595", @"GY", @"509", @"HT", @"504", @"HN",
                               @"36", @"HU", @"354", @"IS", @"91", @"IN", @"62", @"ID",
                               @"964", @"IQ", @"353", @"IE", @"972", @"IL", @"39", @"IT",
                               @"1", @"JM", @"81", @"JP", @"962", @"JO", @"77", @"KZ",
                               @"254", @"KE", @"686", @"KI", @"965", @"KW", @"996", @"KG",
                               @"371", @"LV", @"961", @"LB", @"266", @"LS", @"231", @"LR",
                               @"423", @"LI", @"370", @"LT", @"352", @"LU", @"261", @"MG",
                               @"265", @"MW", @"60", @"MY", @"960", @"MV", @"223", @"ML",
                               @"356", @"MT", @"692", @"MH", @"596", @"MQ", @"222", @"MR",
                               @"230", @"MU", @"262", @"YT", @"52", @"MX", @"377", @"MC",
                               @"976", @"MN", @"382", @"ME", @"1", @"MS", @"212", @"MA",
                               @"95", @"MM", @"264", @"NA", @"674", @"NR", @"977", @"NP",
                               @"31", @"NL", @"599", @"AN", @"687", @"NC", @"64", @"NZ",
                               @"505", @"NI", @"227", @"NE", @"234", @"NG", @"683", @"NU",
                               @"672", @"NF", @"1", @"MP", @"47", @"NO", @"968", @"OM",
                               @"92", @"PK", @"680", @"PW", @"507", @"PA", @"675", @"PG",
                               @"595", @"PY", @"51", @"PE", @"63", @"PH", @"48", @"PL",
                               @"351", @"PT", @"1", @"PR", @"974", @"QA", @"40", @"RO",
                               @"250", @"RW", @"685", @"WS", @"378", @"SM", @"966", @"SA",
                               @"221", @"SN", @"381", @"RS", @"248", @"SC", @"232", @"SL",
                               @"65", @"SG", @"421", @"SK", @"386", @"SI", @"677", @"SB",
                               @"27", @"ZA", @"500", @"GS", @"34", @"ES", @"94", @"LK",
                               @"249", @"SD", @"597", @"SR", @"268", @"SZ", @"46", @"SE",
                               @"41", @"CH", @"992", @"TJ", @"66", @"TH", @"228", @"TG",
                               @"690", @"TK", @"676", @"TO", @"1", @"TT", @"216", @"TN",
                               @"90", @"TR", @"993", @"TM", @"1", @"TC", @"688", @"TV",
                               @"256", @"UG", @"380", @"UA", @"971", @"AE", @"44", @"GB",
                               @"1", @"US", @"598", @"UY", @"998", @"UZ", @"678", @"VU",
                               @"681", @"WF", @"967", @"YE", @"260", @"ZM", @"263", @"ZW",
                               @"591", @"BO", @"673", @"BN", @"61", @"CC", @"243", @"CD",
                               @"225", @"CI", @"500", @"FK", @"44", @"GG", @"379", @"VA",
                               @"852", @"HK", @"98", @"IR", @"44", @"IM", @"44", @"JE",
                               @"850", @"KP", @"82", @"KR", @"856", @"LA", @"218", @"LY",
                               @"853", @"MO", @"389", @"MK", @"691", @"FM", @"373", @"MD",
                               @"258", @"MZ", @"970", @"PS", @"872", @"PN", @"262", @"RE",
                               @"7", @"RU", @"590", @"BL", @"290", @"SH", @"1", @"KN",
                               @"1", @"LC", @"590", @"MF", @"508", @"PM", @"1", @"VC",
                               @"239", @"ST", @"252", @"SO", @"47", @"SJ", @"963", @"SY",
                               @"886", @"TW", @"255", @"TZ", @"670", @"TL", @"58", @"VE",
                               @"84", @"VN", @"1", @"VG", @"1", @"VI", nil];
    
    NSString* tt=[locale objectForKey:NSLocaleCountryCode];
    NSString* defaultCode=[dictCodes objectForKey:tt];
    self.areaCode = [NSString stringWithFormat:@"+%@",defaultCode];
    
    NSString* defaultCountryName=[locale displayNameForKey:NSLocaleCountryCode value:tt];
    _defaultCode=defaultCode;
    _defaultCountryName=defaultCountryName;
}


@end
