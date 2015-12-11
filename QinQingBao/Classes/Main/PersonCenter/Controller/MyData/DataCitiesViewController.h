//
//  DataCitiesViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 15/12/7.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityModel.h"

@interface DataCitiesViewController : UITableViewController


@property (nonatomic, copy) NSString *dvcode_id;

@property (nonatomic, copy) NSString *viewTitle;

@property (nonatomic, copy) NSString *detailStr;

@property (nonatomic, copy) void (^selectedHandler)(CityModel *VO ,NSString *str);


@end
