//
//  HealthArchiveViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 2016/11/7.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveData.h"
#import "ArchiveDataListModel.h"

@interface HealthArchiveViewController : UITableViewController

@property (strong, nonatomic) ArchiveData * archiveData;

@property (strong, nonatomic) ArchiveDataListModel *selectedListModel;

@property (assign, nonatomic, getter=isAddArchive) BOOL addArchive;

@end
