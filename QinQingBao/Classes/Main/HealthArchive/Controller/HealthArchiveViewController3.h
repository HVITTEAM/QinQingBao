//
//  HealthArchiveViewController3.h
//  QinQingBao
//
//  Created by 董徐维 on 2016/11/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveData.h"

@interface HealthArchiveViewController3 : UIViewController

@property (nonatomic, retain) NSMutableArray *dataProvider;

@property(strong, nonatomic) ArchiveData * archiveData;

@property (assign, nonatomic, getter=isAddArchive) BOOL addArchive;

@end
