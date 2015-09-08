//
//  PlaceOrderView.h
//  QinQingBao
//
//  Created by 董徐维 on 15/9/6.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceOrderHeadView : UIView
@property (strong, nonatomic) IBOutlet UIButton *orderRightnow;
- (IBAction)orderRightnowClickHandler:(id)sender;
@property (nonatomic, copy) void (^submitClick)(UIButton *btn);
@end
