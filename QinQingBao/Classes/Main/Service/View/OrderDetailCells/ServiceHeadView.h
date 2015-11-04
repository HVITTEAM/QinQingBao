//
//  ServiceHeadView.h
//  QinQingBao
//
//  Created by 董徐维 on 15/9/8.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceItemModel.h"

@interface ServiceHeadView : UIView
@property (strong, nonatomic) IBOutlet UIView *bgview;
@property (strong, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *content;
@property (strong, nonatomic) IBOutlet UILabel *sum;

@property (nonatomic, retain) ServiceItemModel *itemInfo;
@end
