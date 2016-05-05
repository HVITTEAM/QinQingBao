//
//  BindingResultViewController.m
//  QinQingBao
//
//  Created by shi on 16/2/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "BindingResultViewController.h"

@interface BindingResultViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation BindingResultViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.title = @"注册结果";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //按钮
    self.finishBtn.layer.cornerRadius = 8.0f;
    self.finishBtn.layer.masksToBounds = YES;
    
    //文本
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 10;
    
    NSDictionary *attrDict = @{
                               NSForegroundColorAttributeName:HMColor(12, 167, 161),
                               NSParagraphStyleAttributeName:paragraph,
                               NSFontAttributeName:[UIFont boldSystemFontOfSize:17]
                               };
    NSString *tempStr = @"感谢您使用寸欣健康平台进行\n亲友信息登记和硬件设备绑定!";
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:tempStr attributes:attrDict];
    self.titleLb.attributedText = attrString;
    self.titleLb.textAlignment = NSTextAlignmentCenter;
    
    //活动指示器
//    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden = YES;
}


- (IBAction)finishBinding:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
