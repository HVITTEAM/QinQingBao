//
//  CitiesViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 15/11/24.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTCityChangeDelegate <NSObject>

-(void)selectedChange:(NSString *)city;

@end

@interface CitiesViewController : UITableViewController

@property (nonatomic, retain) UINavigationController *nav;

@property (nonatomic, assign) id<MTCityChangeDelegate> delegate;

@end
