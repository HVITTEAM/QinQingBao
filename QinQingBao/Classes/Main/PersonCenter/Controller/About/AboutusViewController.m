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
    
    self.view.backgroundColor = HMGlobalBg;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName:paragraphStyle};
    self.textView.attributedText = [[NSAttributedString alloc] initWithString:@"“寸欣健康”是一款预约居家养老服务、孝敬和关爱老人的手机APP。方便子女们为渐渐年迈的父母及长辈预约居家生活帮助、健康管理、安全防护、保健娱乐等服务。通过智能手表、居家看护宝、血压仪等穿戴设备，亲属可以通过APP实时查看老人的心率、血压数据和位置信息并可以视频通话。我们将陆续提供在线健康自查和问诊服务，以及更多医疗看护服务。孝心商城是晚辈关爱尽孝的专门为老人提供特需用品的电商平台。" attributes:attributes];
    self.textView.autoresizesSubviews = YES;
    self.textView.autoresizingMask =(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    self.textView.userInteractionEnabled = NO;
    self.textView.backgroundColor = HMGlobalBg;
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
