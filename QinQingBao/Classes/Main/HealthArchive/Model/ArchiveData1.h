//
//  ArchiveData1.h
//  QinQingBao
//
//  Created by shi on 2016/11/16.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACBasicsModel.h"
#import "ACDiseasehistoryModel.h"
#import "ACHabitsModel.h"

@interface ArchiveData1 : NSObject

@property (nonatomic, copy) NSString *fm_fid;

@property (nonatomic, copy) NSString *fmno;

@property (nonatomic, copy) NSString *fm_bid;

@property (nonatomic, copy) NSString *fm_did;

@property (nonatomic, copy) NSString *fm_hid;

@property (nonatomic, copy) NSString *createtime;

@property (nonatomic, copy) NSString *creatememberid;

@property (nonatomic, strong) ACBasicsModel *basics;

@property (nonatomic, strong) ACDiseasehistoryModel *diseasehistory;

@property (nonatomic, strong) ACHabitsModel *habits;

@end
