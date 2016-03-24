//
//  HealthPlaceHolderView.h
//  QinQingBao
//
//  Created by 董徐维 on 16/3/23.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthPlaceHolderView : UIView
@property (strong, nonatomic) IBOutlet UIButton *bangBtn;
- (IBAction)clickHandler:(id)sender;
@property (nonatomic, copy) void (^buttonClick)(UIButton *btn);


@end
