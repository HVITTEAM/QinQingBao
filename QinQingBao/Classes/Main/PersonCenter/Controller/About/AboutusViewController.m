//
//  AboutusViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/12/22.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "AboutusViewController.h"

@interface AboutusViewController ()

@end

@implementation AboutusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName:paragraphStyle};
    self.textView.attributedText = [[NSAttributedString alloc] initWithString:@"寸欣健康，集在线健康管理、线下科技理疗、智慧养老为一体，拥有国内先进的健康管理理念，服务于中老年人、亚健康人群，为您和家人的健康保驾护航。" attributes:attributes];
    self.textView.autoresizesSubviews = YES;
    self.textView.autoresizingMask =(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    self.textView.userInteractionEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
