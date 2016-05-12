//
//  MapViewController.m
//  QinQinBao
//
//  Created by 董徐维 on 15/6/15.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "MapViewController.h"
#import "CLLocation+MTLocation.h"
#import "WGS84TOGCJ02.h"

@interface MapViewController ()
{
    CLGeocoder *geocoder;
}

@end

@implementation MapViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initNavgation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initMapview];
    
    geocoder = [[CLGeocoder alloc] init];
    
    //    CLLocation * location = [[CLLocation alloc]initWithLatitude:[self.latitude floatValue] longitude:[self.longitude floatValue]];
    //    CLLocation * marsLoction =  [location locationMarsFromBaidu];
    //    NSLog(@"%f,%f",marsLoction.coordinate.latitude,marsLoction.coordinate.longitude);
    CLLocationCoordinate2D cords = CLLocationCoordinate2DMake([self.latitude floatValue], [self.longitude floatValue]);
    
    //    CLLocationCoordinate2D cords;
    //    if (![WGS84TOGCJ02 isLocationOutOfChina:[location coordinate]]) {
    //        //转换后的coord
    //        cords = [WGS84TOGCJ02 transformFromWGSToGCJ:[location coordinate]];
    //    }
    //    CLLocationCoordinate2D cords = CLLocationCoordinate2DMake([self.latitude floatValue], [self.longitude floatValue]);
    
    float zoomLevel = 0.01;//缩放区域
    MKCoordinateRegion region = MKCoordinateRegionMake(cords, MKCoordinateSpanMake(zoomLevel, zoomLevel));
    [_map setRegion:[_map regionThatFits:region] animated:YES];
    
    MyAnnotation *annotation = [[MyAnnotation alloc] initWithCoordinate:cords];
    annotation.title = @"位置";
    annotation.subtitle = self.address;
    [_map addAnnotation:annotation];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    if ([[UIDevice currentDevice].systemVersion doubleValue]>=8.0) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

-(void)initMapview
{
    _map = [[MKMapView alloc] initWithFrame:[self.view bounds]];
    
    //    self.map.showsCompass= YES; //指南针
    //锁定视图旋转
    self.map.rotateEnabled = NO;
    //锁定2D视图
    self.map.rotateEnabled = NO;
    
    _map.showsUserLocation = YES;
    //显示用户位置（蓝色发光圆圈），还有None和FollowWithHeading两种，当有这个属性的时候，iOS8第一次打开地图，会自动定位并显示这个位置。iOS7模拟器上不会。
    self.map.userTrackingMode = MKUserTrackingModeFollow;
    //设置代理
    self.map.delegate=self;
    [self.view addSubview:_map];
}

//-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
//{
//    MKAnnotationView *view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"dada"];
//    view.image = [UIImage imageNamed:@"1.png"];
//    return view;
//}

-(void)initNavgation
{
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 75, 35)];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    backBtn.titleLabel.textColor = [UIColor whiteColor];
    backBtn.backgroundColor = HMColor(51, 50, 48);
    backBtn.layer.cornerRadius = 5;
    backBtn.alpha = 0.66;
    [self.map addSubview:backBtn];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
}

//MKUserLocation是地图上大头针模型，有title和subtitle以及location信息。该方法调用频繁
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"%f,%f",userLocation.location.coordinate.longitude,userLocation.location.coordinate.latitude);
    //点击大头针，会出现以下信息
    userLocation.title=@"当前地址";
    userLocation.subtitle=@"";
    
    //让地图显示用户的位置（iOS8一打开地图会默认转到用户所在位置的地图），该方法不能设置地图精度
    //    [mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    
    //这个方法可以设置地图精度以及显示用户所在位置的地图
    //    MKCoordinateSpan span=MKCoordinateSpanMake(0.1, 0.1);
    //    MKCoordinateRegion region=MKCoordinateRegionMake(userLocation.location.coordinate, span);
    //    [mapView setRegion:region animated:YES];
    
    //    [self.locationManager stopUpdatingLocation];
    
    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:
     ^(NSArray *placemarks, NSError *error){
         if (error||placemarks.count==0) {
             NSLog(@"你输入的地址没找到，可能在月球上");
         }else//编码成功
         {
             //显示最前面的地标信息
             //CLPlacemark *firstPlacemark=[placemarks firstObject];
             // NSArray* addrArray = [firstPlacemark.addressDictionary
             // objectForKey:@"FormattedAddressLines"];
             // NSString *str1 = firstPlacemark.thoroughfare;
             // NSString *str2 = firstPlacemark.subThoroughfare;
             // NSString *str3 = firstPlacemark.locality;
             // NSString *str4 = firstPlacemark.subLocality;
             // NSString *str5 = firstPlacemark.administrativeArea;
             // NSString *str6 = firstPlacemark.subAdministrativeArea;
             // NSString *str7 = firstPlacemark.country;
             // NSString *str = firstPlacemark.name;
             // NSString *locationStr = [NSString stringWithFormat:@"%@%@%@%@%@附近",firstPlacemark.locality,firstPlacemark.subLocality,firstPlacemark.thoroughfare,firstPlacemark.subThoroughfare,firstPlacemark.name];
             // NSLog(locationStr);
         }     }];
    
}

- (IBAction)backToUserLocation:(id)sender
{
    [self.map setCenterCoordinate:self.map.userLocation.location.coordinate animated:YES];
}

- (IBAction)back:(id)sender
{
    _map.showsUserLocation = NO;
    if (_map && _map.overlays)
        [_map removeOverlays:_map.overlays];
    if (_map && _map.annotations)
        [_map removeAnnotations:_map.annotations];
    _map.delegate = nil; // 不用时，置nil
    _map = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
