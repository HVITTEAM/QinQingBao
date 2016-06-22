//
//  MarketBuyView.h
//  QinQingBao
//
//  Created by 董徐维 on 15/9/6.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MassageModel;

@interface MarketBuyView : UIView
@property (strong, nonatomic) IBOutlet UILabel *sellnumLab;
@property (strong, nonatomic) IBOutlet UIButton *orderRightnow;
@property (strong, nonatomic) IBOutlet UILabel *priceLab;
- (IBAction)orderRightnowClickHandler:(id)sender;
@property (nonatomic, copy) void (^submitClick)(UIButton *btn);
@property (strong, nonatomic) IBOutlet UILabel *markPriceLab;

@property (nonatomic, retain) MassageModel *item;
@end
