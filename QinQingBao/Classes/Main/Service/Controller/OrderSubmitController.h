//
//  OrderSubmitController.h
//  QinQingBao
//
//  Created by 董徐维 on 15/9/8.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderSubmitCell.h"
#import "PayViewController.h"
#import "FamilyViewController.h"
#import "ServiceCustomCell.h"
#import "ServiceItemModel.h"
#import "ServiceTypeModel.h"

@interface OrderSubmitController : UITableViewController<UIActionSheetDelegate,UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic,retain) UIDatePicker* datePicker;

@property (nonatomic,retain) UIPickerView* datePickView;

/*服务详情**/
@property (nonatomic, retain) ServiceItemModel *serviceDetailItem;

@property (nonatomic, retain) ServiceTypeModel *serviceTypeItem;

@end
