//
//  MyAnnotation.m
//  L8MapDemo
//
//  Created by Mr.Tung on 14/11/12.
//  Copyright (c) 2014年 Mr.Tung. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation

-(id) initWithCoordinate:(CLLocationCoordinate2D) coordiname2D;
{
    if (self == [super init]) {
        _coordinate = coordiname2D;
    }
    return self;
}

@end
