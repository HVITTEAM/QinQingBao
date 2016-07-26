//
//  WaistHipRatioViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/7/25.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "WaistHipRatioViewController.h"
#import "CXRuler.h"

#import "QuestionBtnViewController.h"
//#import "QuestionThreeController.h"

#import "QuestionModel.h"
#import "QuestionModel_1.h"
#import "OptionModel.h"

@interface WaistHipRatioViewController ()<CXRulerDelegate>

@property (strong, nonatomic) IBOutlet CXRuler *rule1;
@property (strong, nonatomic) IBOutlet CXRuler *rule2;
- (IBAction)next:(id)sender;

@end

@implementation WaistHipRatioViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _rule1.rulerDelegate = self;
    [_rule1 showRulerScrollViewWithCount:100 average:[NSNumber numberWithFloat:1] startValue:1 currentValue:80];
    
    _rule2.rulerDelegate = self;
    [_rule2 showRulerScrollViewWithCount:100 average:[NSNumber numberWithFloat:1] startValue:1 currentValue:80];
}

- (void)CXRuler:(CXRulerScrollView *)rulerScrollView
{
    NSString *value                             = [NSString stringWithFormat:@"%.0f",rulerScrollView.rulerValue];
    NSLog(@"%@",value);
    //    NSString *string                            = [NSString stringWithFormat:@"%@%@",value,_unit];
    //    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    //
    //    // 设置富文本样式
    //    [attributedString addAttribute:NSForegroundColorAttributeName
    //                             value:[UIColor orangeColor]
    //                             range:NSMakeRange(0, value.length)];
    //
    //    [attributedString addAttribute:NSFontAttributeName
    //                             value:[UIFont systemFontOfSize:13.f]
    //                             range:NSMakeRange(value.length, _unit.length)];
    //
    //    showLabel.attributedText = attributedString;
    //
    //    rulerValue = [value floatValue];
}


- (IBAction)next:(id)sender {
    
    QuestionBtnViewController *vc = [[QuestionBtnViewController alloc] init];
    vc.dataProvider = self.dataProvider;
    vc.eq_id = 4;
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
