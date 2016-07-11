//
//  ServiceHeadView.h
//  QinQingBao
//
//  Created by 董徐维 on 15/9/8.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MassageModel;

@interface MarketHeadView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) IBOutlet UIImageView *markImg;
@property (strong, nonatomic) IBOutlet UILabel *sellLab;

@property (nonatomic, retain) MassageModel *item;

@end
