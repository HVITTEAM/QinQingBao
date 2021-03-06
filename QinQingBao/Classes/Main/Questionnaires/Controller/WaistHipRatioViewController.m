//
//  WaistHipRatioViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/7/25.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "WaistHipRatioViewController.h"
#import "CXRuler.h"

#import "DiseaseBtnController.h"

@interface WaistHipRatioViewController ()<CXRulerDelegate>
{
    QuestionModel *questionItem;
    
    //腰围数据
    QuestionModel_1 *answerItem;
    
    //臀围数据
    QuestionModel_1 *answerItem2;
    
    
    NSString *rule1Value;
    NSString *rule2Value;
    
    IBOutlet UILabel *pageLab;

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
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
- (IBAction)next:(id)sender;
@end

@implementation WaistHipRatioViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    questionItem = self.dataProvider[2];
    
    self.title = questionItem.eq_subtitle;
    
    self.containerView.layer.borderWidth = 1.0f;
    self.containerView.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
    self.containerView.layer.cornerRadius = 7.0f;

    [self initView];
}


-(void)initView
{
    self.nextBtn.layer.cornerRadius = 7.0f;
    
    //设置页面序号
    NSString *pageNumStr = @"3/16";
    NSDictionary *attr1 = @{
                            NSFontAttributeName :[UIFont systemFontOfSize:10],
                            NSForegroundColorAttributeName:HMColor(228, 185, 160)
                            };
    
    NSDictionary *attr2 = @{
                            NSFontAttributeName :[UIFont systemFontOfSize:14],
                            NSForegroundColorAttributeName:[UIColor whiteColor]
                            };
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:pageNumStr attributes:attr1];
    NSRange range = [pageNumStr rangeOfString:@"/"];
    [attrStr setAttributes:attr2 range:NSMakeRange(0,range.location)];
    pageLab.attributedText = attrStr;


    //腰围数据
    answerItem = questionItem.questions[0];
    //臀围数据
    answerItem2 = questionItem.questions[1];
    
    self.titleLab.text = questionItem.eq_title;

    self.subtitleLab.text = questionItem.eq_subtitle;
    
    self.ruletitleLab1.text = answerItem.q_title;
    
    self.ruletitleLab2.text = answerItem2.q_title;
    
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:answerItem.q_detail_url] placeholderImage:[UIImage imageWithName:@"placeholder_serviceMarket"]];
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:answerItem.q_logo_url] placeholderImage:[UIImage imageWithName:@"placeholder_serviceMarket"]];
    
    _rule1.rulerDelegate = self;
    [_rule1 showRulerScrollViewWithCount:150 average:[NSNumber numberWithFloat:1] startValue:1 currentValue: 80];
    
    _rule2.rulerDelegate = self;
    [_rule2 showRulerScrollViewWithCount:150 average:[NSNumber numberWithFloat:1] startValue:1 currentValue: 60];
    
    [self initdata];
}

/**
 *  初始化数据
 */
-(void)initdata
{
    for (NSMutableDictionary *dictItem in [self.answerProvider copy])
    {
        if ([[dictItem objectForKey:@"q_id"] isEqualToString:answerItem.q_id])
        {
            [_rule1 showRulerScrollViewWithCount:100 average:[NSNumber numberWithFloat:1] startValue:0 currentValue: [[dictItem objectForKey:@"qa_detail"] floatValue]];

        }
        else if ([[dictItem objectForKey:@"q_id"] isEqualToString:answerItem2.q_id])
        {
            [_rule2 showRulerScrollViewWithCount:100 average:[NSNumber numberWithFloat:1] startValue:0 currentValue: [[dictItem objectForKey:@"qa_detail"] floatValue]];
        }
    }
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
    {
        self.value1Lab.attributedText = attributedString;
        rule1Value = value;
    }
    else
    {
        self.value2Lab.attributedText = attributedString;
        rule2Value = value;
    }
}

- (IBAction)next:(id)sender
{
    NSArray * array = [NSArray arrayWithArray:[self.answerProvider copy]];
    
    //是否已经添加到数据源中
    BOOL find = false;
    //查找第一个
    for (NSMutableDictionary *dictItem in array)
    {
        if ([[dictItem objectForKey:@"q_id"] isEqualToString:answerItem.q_id])
        {
            find = YES;
            [dictItem setObject:rule1Value forKey:@"qa_detail"];
            break;
        }
    }
    if (!find)
    {
        NSMutableDictionary * dict1 = [[NSMutableDictionary alloc] init];
        [dict1 setObject:answerItem.q_id forKey:@"q_id"];
        [dict1 setObject:rule1Value forKey:@"qa_detail"];
        [dict1 setValue:answerItem.q_type forKey:@"q_type"];
        [self.answerProvider addObject:dict1];
    }
    
    //查找第二个
    //是否已经添加到数据源中
    BOOL find1 = false;
    for (NSMutableDictionary *dictItem in array)
    {
        
        if ([[dictItem objectForKey:@"q_id"] isEqualToString:answerItem2.q_id])
        {
            find1 = YES;
            [dictItem setObject:rule2Value forKey:@"qa_detail"];
            break;
        }
    }
    if (!find1)
    {
        NSMutableDictionary * dict2 = [[NSMutableDictionary alloc] init];
        [dict2 setObject:answerItem2.q_id forKey:@"q_id"];
        [dict2 setObject:rule2Value forKey:@"qa_detail"];
        [dict2 setValue:answerItem2.q_type forKey:@"q_type"];

        [self.answerProvider addObject:dict2];
        
    }
    
    DiseaseBtnController *vc = [[DiseaseBtnController alloc] init];
    vc.dataProvider = self.dataProvider;
    vc.eq_id = 4;
    vc.exam_id = self.exam_id;
    vc.answerProvider = self.answerProvider;
    vc.calculatype = self.calculatype;
    vc.e_title = self.e_title;

    [self.navigationController pushViewController:vc animated:YES];
}

@end
