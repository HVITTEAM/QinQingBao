//
//  AddContactViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 16/2/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "HMCommonViewController.h"
#import "RelationModel.h"

@interface AddContactViewController : HMCommonViewController
@property (nonatomic, copy) void (^addResultClick)(RelationModel *item);

@end
