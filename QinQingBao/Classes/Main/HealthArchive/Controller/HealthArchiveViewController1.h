//
//  HealthArchiveViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 2016/11/7.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MarketCustomInfo.h"
#import "ArchiveData.h"

@interface HealthArchiveViewController1 : UITableViewController

//@property(strong,nonatomic)MarketCustomInfo *customInfo;

@property(strong, nonatomic) ArchiveData * archiveData;

@property (assign, nonatomic, getter=isAddArchive) BOOL addArchive;

@property (assign, nonatomic) BOOL isCreator;    //当前登录用户是否是档案创建者,查看时候才有用

@end
