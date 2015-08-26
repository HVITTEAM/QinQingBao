//
//  PlaceOrderController.h
//  QinQinBao
//
//  Created by 董徐维 on 15/6/30.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "HMCommonViewController.h"
#import "HMCommonGroup.h"
#import "HMCommonArrowItem.h"
#import "HMCommonSwitchItem.h"
#import "HMCommonCell.h"
#import "HMCommonTextfieldItem.h"

@interface PlaceOrderController : HMCommonViewController<UIActionSheetDelegate,UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic,retain) HMCommonArrowItem *item2;

@property (nonatomic,retain) UIDatePicker* datePicker;


@property (nonatomic,retain) UIPickerView* datePickView;



@end
