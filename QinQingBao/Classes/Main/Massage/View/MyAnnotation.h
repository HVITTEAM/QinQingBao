//
//  MyAnnotation.h
//  L8MapDemo
//
//  Created by Mr.Tung on 14/11/12.
//  Copyright (c) 2014年 Mr.Tung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject<MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;//设置提示窗口的标题

@property (nonatomic, copy) NSString *subtitle;//设置提示窗口的子标题

-(id) initWithCoordinate:(CLLocationCoordinate2D) coordiname2D;
@end
