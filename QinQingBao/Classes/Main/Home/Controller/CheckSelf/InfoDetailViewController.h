//
//  DiseaseDetailViewController.h
//  QinQingBao
//
//  Created by shi on 16/1/22.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoDetailViewController : UITableViewController

@property(strong,nonatomic)NSString *detail;                //信息详情

@property(strong,nonatomic)NSString *headTitle;             //信息标题

@property(strong,nonatomic)NSString *headIconName;              //信息标题图标

@property(strong,nonatomic)NSString *navTitle;              //导航栏标题

@end
