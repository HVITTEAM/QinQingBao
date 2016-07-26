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
#import "QuestionModel.h"
#import "QuestionModel_1.h"

@interface WaistHipRatioViewController ()<CXRulerDelegate>
{
    QuestionModel *questionItem;
    
    //腰围数据
    QuestionModel_1 *answerItem;
    
    //臀围数据
    QuestionModel_1 *answerItem2;
}
@property (strong, nonatomic) IBOutlet UIImageView *headImg;
@property (strong, nonatomic) IBOutlet UIImageView *iconImg;
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UILabel *subtitleLab;
@property (strong, nonatomic) IBOutlet UILabel *ruletitleLab1;
@property (strong, nonatomic) IBOutlet UILabel *ruletitleLab2;
@property (strong, nonatomic) IBOutlet CXRuler *rule1;
@property (strong, nonatomic) IBOutlet CXRuler *rule2;
@property (strong, nonatomic) IBOutlet UILabel *value1Lab;
@property (strong, nonatomic) IBOutlet UILabel *value2Lab;
- (IBAction)next:(id)sender;

@end

@implementation WaistHipRatioViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"腰臀比";
    
    questionItem = self.dataProvider[2];
    
    [self initView];
}


-(void)initView
{
    self.titleLab.text = questionItem.eq_title;
    //腰围数据
    answerItem = questionItem.questions[0];
    
    //臀围数据
    answerItem2 = questionItem.questions[1];
    
    self.ruletitleLab1.text = answerItem.q_title;
    self.ruletitleLab2.text = answerItem2.q_title;
    
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:answerItem.q_detail_url] placeholderImage:[UIImage imageWithName:nil]];
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:answerItem.q_logo_url] placeholderImage:[UIImage imageWithName:nil]];
    
    _rule1.rulerDelegate = self;
    [_rule1 showRulerScrollViewWithCount:100 average:[NSNumber numberWithFloat:1] startValue:0 currentValue:(answerItem.q_rule && answerItem.q_rule.length > 0 )? [answerItem.q_rule floatValue] : 80];
    
    _rule2.rulerDelegate = self;
    [_rule2 showRulerScrollViewWithCount:100 average:[NSNumber numberWithFloat:1] startValue:0 currentValue:(answerItem2.q_rule && answerItem2.q_rule.length > 0) ? [answerItem2.q_rule floatValue]: 60];
    
}
- (void)CXRuler:(CXRulerScrollView *)rulerScrollView ruler:(CXRuler *)ruler
{
    
    NSString *value                             = [NSString stringWithFormat:@"%.0f",rulerScrollView.rulerValue];
    NSLog(@"%@",value);
    NSString *unitStr = (answerItem.q_unit && answerItem.q_unit.length > 0) ? answerItem.q_unit : @"cm";
    NSString *string                            = [NSString stringWithFormat:@"%@%@",value,unitStr];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    // 设置富文本样式
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor orangeColor]
                             range:NSMakeRange(0, value.length)];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:13.f]
                             range:NSMakeRange(value.length, unitStr.length)];
    
    if (ruler == _rule1)
        self.value1Lab.attributedText = attributedString;
    else
        self.value2Lab.attributedText = attributedString;
}

- (IBAction)next:(id)sender {
    QuestionBtnViewController *vc = [[QuestionBtnViewController alloc] init];
    vc.isMultipleSelection = YES;
    vc.isTwo = NO;
    vc.btnHeight = 45;
    vc.datas = @[@"a0",@"a1",@"a2",@"a3",@"a0",@"a1",@"a2",@"a3"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
