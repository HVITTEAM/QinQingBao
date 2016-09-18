//
//  LoginOutHeadView.m
//  QinQingBao
//
//  Created by 董徐维 on 16/9/9.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "LoginOutHeadView.h"

@implementation LoginOutHeadView

-(void)awakeFromNib
{
    self.userIcon.layer.cornerRadius = self.userIcon.width/2;
    self.userIcon.layer.masksToBounds = YES;
    
    self.loginBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.loginBtn.layer.borderWidth = .5f;
    self.loginBtn.layer.cornerRadius = 5;
    self.loginBtn.layer.masksToBounds = YES;

}

- (IBAction)loginHandler:(id)sender {
    [MTNotificationCenter postNotificationName:MTNeedLogin object:nil userInfo:nil];
}
@end
