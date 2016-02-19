//
//  EditContactViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 16/2/19.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "HMCommonViewController.h"
#import "RelationModel.h"

@interface EditContactViewController : HMCommonViewController

@property (nonatomic, retain) RelationModel *item;
@property (nonatomic, copy) void (^editResultClick)(RelationModel *item);
@property (nonatomic, copy) void (^deleteResultClick)(RelationModel *item);

@end
