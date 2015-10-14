//
//  MapViewController.h
//  QinQinBao
//
//  Created by 董徐维 on 15/6/15.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MyAnnotation.h"

@interface MapViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
@property (nonatomic) MKMapView *map;
@property (nonatomic) CLLocationManager *locationManager;


@end
