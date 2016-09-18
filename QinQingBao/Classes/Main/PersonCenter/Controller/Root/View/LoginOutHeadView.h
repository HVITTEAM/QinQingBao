//
//  LoginOutHeadView.h
//  QinQingBao
//
//  Created by 董徐维 on 16/9/9.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginOutHeadView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *userIcon;

@property (weak, nonatomic) IBOutlet UIImageView *headView;

@property (strong, nonatomic) IBOutlet UIButton *loginBtn;

- (IBAction)loginHandler:(id)sender;

@end
