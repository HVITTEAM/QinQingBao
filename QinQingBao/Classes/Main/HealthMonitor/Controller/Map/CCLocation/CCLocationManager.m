//
//  CCLocationManager.m
//  MMLocationManager
//
//  Created by 董徐维  on 14-15-10.
//  Copyright (c) 2015年 董徐维 . All rights reserved.
//

#import "CCLocationManager.h"
#import "CLLocation+MTLocation.h"
@interface CCLocationManager (){
    CLLocationManager *_manager;
    
}
@property (nonatomic, strong) LocationBlock locationBlock;
@property (nonatomic, strong) NSStringBlock cityBlock;
@property (nonatomic, strong) NSStringBlock addressBlock;
@property (nonatomic, strong) NSStringBlock cityAndAreaBlock;
@property (nonatomic, strong) NSStringBlock getLocationErrorBlock;


@property (nonatomic, strong) LocationErrorBlock errorBlock;

@end

@implementation CCLocationManager


+ (CCLocationManager *)shareLocation{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    self = [super init];
    if (self) {
        NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
        
        float longitude = [standard floatForKey:CCLastLongitude];
        float latitude = [standard floatForKey:CCLastLatitude];
        self.longitude = longitude;
        self.latitude = latitude;
        self.lastCoordinate = CLLocationCoordinate2DMake(longitude,latitude);
        self.lastCity = [standard objectForKey:CCLastCity];
        self.lastAddress=[standard objectForKey:CCLastAddress];
    }
    return self;
}
//获取经纬度
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock
{
    self.locationBlock = [locaiontBlock copy];
    [self startLocation];
}

- (void) getLocationCoordinate:(LocationBlock) locaiontBlock  withAddress:(NSStringBlock) addressBlock
{
    self.locationBlock = [locaiontBlock copy];
    self.addressBlock = [addressBlock copy];
    [self startLocation];
}

- (void) getAddress:(NSStringBlock)addressBlock
{
    self.addressBlock = [addressBlock copy];
    [self startLocation];
}
//获取省市
- (void) getCity:(NSStringBlock)cityBlock
{
    self.cityBlock = [cityBlock copy];
    [self startLocation];
}

- (void)getCityAndArea:(NSStringBlock)cityAndAreaBlock
{
    self.cityAndAreaBlock = [cityAndAreaBlock copy];
    [self startLocation];
}

- (void)getLocationError:(NSStringBlock)locationErrorBlock
{
    self.getLocationErrorBlock = [locationErrorBlock copy];
}


- (void) getCity:(NSStringBlock)cityBlock error:(LocationErrorBlock) errorBlock
{
    self.cityBlock = [cityBlock copy];
    self.errorBlock = [errorBlock copy];
    [self startLocation];
}

#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    CLLocation * location = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    //    CLLocation * marsLoction =   [location locationMarsFromEarth];
    CLLocation * marsLoction =   location;
    
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:marsLoction completionHandler:^(NSArray *placemarks,NSError *error)
     {
         if (placemarks.count > 0) {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             _lastCity = placemark.locality;
             [standard setObject:_lastCity forKey:CCLastCity];//省市地址
             NSLog(@"______%@",_lastCity);
             _lastAddress = placemark.name;
             NSLog(@"______%@",_lastAddress);
             if (_cityAndAreaBlock) {
                 _cityAndAreaBlock([NSString stringWithFormat:@"%@",placemark.subLocality]);
                 _cityAndAreaBlock = nil;
             }
         }
         if (_cityBlock) {
             _cityBlock(_lastCity);
             _cityBlock = nil;
         }
         if (_addressBlock) {
             _addressBlock(_lastAddress);
             _addressBlock = nil;
         }
         
     }];
    
    _lastCoordinate = CLLocationCoordinate2DMake(marsLoction.coordinate.latitude ,marsLoction.coordinate.longitude);
    if (_locationBlock) {
        _locationBlock(_lastCoordinate);
        _locationBlock = nil;
    }
    
    NSLog(@"%f--%f",marsLoction.coordinate.latitude,marsLoction.coordinate.longitude);
    [standard setObject:@(marsLoction.coordinate.latitude) forKey:CCLastLatitude];
    [standard setObject:@(marsLoction.coordinate.longitude) forKey:CCLastLongitude];
    
    [manager stopUpdatingLocation];
}

-(void)startLocation
{
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        _manager=[[CLLocationManager alloc]init];
        _manager.delegate=self;
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        [_manager requestWhenInUseAuthorization];
        _manager.distanceFilter=100;
        [_manager startUpdatingLocation];
    }
    else
    {
        if (_getLocationErrorBlock)
        {
            _getLocationErrorBlock(@"需要开启定位服务,请到设置->隐私,打开定位服务");
            _getLocationErrorBlock = nil;
        }
    }
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    [self stopLocation];
    
}
-(void)stopLocation
{
    _manager = nil;
}


@end
