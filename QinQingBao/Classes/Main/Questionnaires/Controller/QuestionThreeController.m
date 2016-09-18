//
//  QuestionThreeController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/7/12.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "QuestionThreeController.h"

#import "DiseaseBtnController.h"


@interface QuestionThreeController ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    QuestionModel *questionItem;
    QuestionModel_1 *item1;
    QuestionModel_1 *item2;
    QuestionModel_1 *item3;
    
    NSString *leftSelectedValue;
    NSString *rightSelectedValue;
    
    //收缩压
    NSMutableArray *data1;
    //舒张压
    NSMutableArray *data2;
    
    IBOutlet UILabel *pageLab;
}
@property (strong, nonatomic) IBOutlet UIImageView *headImg;

@property (strong, nonatomic) IBOutlet UIImageView *iconImg;

@property (strong, nonatomic) IBOutlet UILabel *titleLab;

@property (strong, nonatomic) IBOutlet UILabel *swtchLab;

@property (strong, nonatomic) IBOutlet UIButton *switchBtn;
- (IBAction)switchHandler:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *leftSubtitleLab;

@property (strong, nonatomic) IBOutlet UILabel *rightSubtitleLab;

@property (strong, nonatomic) IBOutlet UIPickerView *rightPicker;

@property (strong, nonatomic) IBOutlet UIPickerView *leftPicker;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation QuestionThreeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置血压的正常范围
    data1 = [[NSMutableArray alloc] init];
    for (int i = 1; i  < 181; i ++ )
    {
        [data1 addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    data2 = [[NSMutableArray alloc] init];
    for (int j = 1; j  < 121; j ++ )
    {
        [data2 addObject:[NSString stringWithFormat:@"%d",j]];
    }
    
    [self setupUI];
    
    self.leftPicker.delegate = self;
    self.rightPicker.delegate = self;
    self.rightPicker.dataSource = self;
    self.leftPicker.dataSource = self;
    
    [self.leftPicker selectRow:88 inComponent:0 animated:YES];
    leftSelectedValue = data1[3];
    rightSelectedValue = data2[3];
    [self.rightPicker selectRow:88 inComponent:0 animated:YES];
    
    OptionModel *item = item3.options[0];
    self.switchBtn.tag = [item.qo_id integerValue];
    
    self.containerView.layer.borderWidth = 1.0f;
    self.containerView.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
    self.containerView.layer.cornerRadius = 7.0f;
    
    [self initdata];
}

-(void)setupUI
{
    [self setupView:self.containerView];
    
    //设置页面序号
    NSString *pageNumStr = @"11/16";
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
    
    
    [self.switchBtn setBackgroundImage:[UIImage imageNamed:@"yes.png"] forState:UIControlStateSelected];
    [self.switchBtn setBackgroundImage:[UIImage imageNamed:@"no.png"] forState:UIControlStateNormal];
    self.switchBtn.selected = NO;
    
    self.nextBtn.layer.cornerRadius = 7.0f;
    
    questionItem = self.dataProvider[10];
    self.title = questionItem.eq_subtitle;
    
    item1 = questionItem.questions[0];
    item2 = questionItem.questions[1];
    item3 = questionItem.questions[2];
    self.titleLab.text = item1.q_title;
    
    self.leftSubtitleLab.text = item1.q_title;
    
    self.rightSubtitleLab.text = item2.q_title;
    
    self.swtchLab.text = item3.q_title;
    
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:item1.q_logo_url] placeholderImage:[UIImage imageNamed:@"head"]];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:item1.q_detail_url] placeholderImage:[UIImage imageNamed:@"placeholder_serviceMarket"]];
}

/**
 *  初始化数据
 */
-(void)initdata
{
    for (NSMutableDictionary *dictItem in [self.answerProvider copy])
    {
        if ([[dictItem objectForKey:@"q_id"] isEqualToString:item1.q_id])
        {
            leftSelectedValue = data1[[[dictItem objectForKey:@"qa_detail"] integerValue] - 1];
            [self.leftPicker selectRow:[[dictItem objectForKey:@"qa_detail"] integerValue] -1 inComponent:0 animated:YES];
        }
        else if ([[dictItem objectForKey:@"q_id"] isEqualToString:item2.q_id])
        {
            rightSelectedValue = data2[[[dictItem objectForKey:@"qa_detail"] integerValue] - 1];
            [self.rightPicker selectRow:[[dictItem objectForKey:@"qa_detail"] integerValue] -1 inComponent:0 animated:YES];
        }
        else if ([[dictItem objectForKey:@"q_id"] isEqualToString:item3.q_id])
        {
            for (OptionModel *item in item3.options)
            {
                if ([dictItem objectForKey:@"qa_detail"] == item.qo_id && [item.qo_content rangeOfString:@"是"].location != NSNotFound)
                {
                    self.switchBtn.selected = YES;
                }
                else if ([dictItem objectForKey:@"qa_detail"] == item.qo_id && [item.qo_content rangeOfString:@"否"].location != NSNotFound)
                {
                    self.switchBtn.selected = NO;
                }
            }
        }
    }
}

- (IBAction)nextBtnClicke:(id)sender
{
    NSArray * array = [NSArray arrayWithArray:[self.answerProvider copy]];
    
    //是否已经添加到数据源中
    BOOL find = false;
    //查找第一个
    for (NSMutableDictionary *dictItem in array)
    {
        if ([[dictItem objectForKey:@"q_id"] isEqualToString:item1.q_id])
        {
            find = YES;
            [dictItem setObject:leftSelectedValue forKey:@"qa_detail"];
            break;
        }
    }
    if (!find)
    {
        NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
        [dict1 setObject:item1.q_id forKey:@"q_id"];
        [dict1 setValue:item1.q_type forKey:@"q_type"];
        [dict1 setObject:leftSelectedValue forKey:@"qa_detail"];
        [self.answerProvider addObject:dict1];
    }
    
    //查找第二个
    //是否已经添加到数据源中
    BOOL find1 = false;
    for (NSMutableDictionary *dictItem in array)
    {
        
        if ([[dictItem objectForKey:@"q_id"] isEqualToString:item2.q_id])
        {
            find1 = YES;
            [dictItem setObject:rightSelectedValue forKey:@"qa_detail"];
            
            break;
        }
    }
    if (!find1)
    {
        NSMutableDictionary * dict2 = [[NSMutableDictionary alloc] init];
        [dict2 setObject:item2.q_id forKey:@"q_id"];
        [dict2 setValue:item2.q_type forKey:@"q_type"];
        [dict2 setObject:rightSelectedValue forKey:@"qa_detail"];
        [self.answerProvider addObject:dict2];
    }
    
    //查找第三个
    //是否已经添加到数据源中
    BOOL find2 = false;
    for (NSMutableDictionary *dictItem in array)
    {
        if ([[dictItem objectForKey:@"q_id"] isEqualToString:item3.q_id])
        {
            find2 = YES;
            [dictItem setObject:[NSString stringWithFormat:@"%.0ld",(long)self.switchBtn.tag] forKey:@"qa_detail"];
            break;
        }
    }
    if (!find2)
    {
        NSMutableDictionary *dict3 = [[NSMutableDictionary alloc] init];
        [dict3 setObject:item3.q_id forKey:@"q_id"];
        [dict3 setValue:item3.q_type forKey:@"q_type"];
        [dict3 setObject:[NSString stringWithFormat:@"%.0ld",(long)self.switchBtn.tag] forKey:@"qa_detail"];
        [self.answerProvider addObject:dict3];
        
    }
    
    DiseaseBtnController *nextQuestionBtnVC = [[DiseaseBtnController alloc] init];
    nextQuestionBtnVC.dataProvider = self.dataProvider;
    nextQuestionBtnVC.eq_id = 12;
    nextQuestionBtnVC.exam_id = self.exam_id;
    nextQuestionBtnVC.e_title = self.e_title;
    nextQuestionBtnVC.calculatype = self.calculatype;
    nextQuestionBtnVC.answerProvider = self.answerProvider;
    [self.navigationController pushViewController:nextQuestionBtnVC animated:YES];
}

-(void)setupView:(UIView *)v
{
    v.layer.borderWidth = 1.0f;
    v.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
    v.layer.cornerRadius = 7.0f;
}

#pragma mark UIPickerViewDelegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerView == self.leftPicker ? data1.count : data2.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == self.leftPicker)
    {
        leftSelectedValue = data1[row];
    }
    else
    {
        rightSelectedValue = data2[row];
    }
    
    UILabel *lab = (UILabel*)[pickerView viewForRow:row forComponent:component];
    lab.textColor = [UIColor orangeColor];
    lab.font  = [UIFont systemFontOfSize:16];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:lab.text];
    
    // 设置富文本样式
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor grayColor]
                             range:NSMakeRange(lab.text.length - 4, 4)];
    
    lab.attributedText = attributedString;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 23;
}

-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //    if (row == 3)
    //    {
    //        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.width, 35)];
    //        lab.textAlignment = NSTextAlignmentCenter;
    //        NSString *str= [NSString stringWithFormat:@"%@mmHg",pickerView == self.leftPicker ? data1[row] : data2[row]];
    //        lab.textColor = [UIColor darkGrayColor];
    //        lab.text = str;
    //        lab.font = [UIFont systemFontOfSize:14];
    //
    //        lab.textColor = [UIColor orangeColor];
    //        lab.font  = [UIFont systemFontOfSize:14];
    //        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    //
    //        // 设置富文本样式
    //        [attributedString addAttribute:NSForegroundColorAttributeName
    //                                 value:[UIColor grayColor]
    //                                 range:NSMakeRange(lab.text.length - 4, 4)];
    //
    //        lab.attributedText = attributedString;
    //        return lab;
    //    }
    //    else
    //    {
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.width, 35)];
    lab1.textAlignment = NSTextAlignmentCenter;
    NSString *str= [NSString stringWithFormat:@"%@mmHg",pickerView == self.leftPicker ? data1[row] : data2[row]];
    lab1.textColor = [UIColor darkGrayColor];
    lab1.text = str;
    lab1.font = [UIFont systemFontOfSize:14];
    return lab1;
    //    }
}

- (IBAction)switchHandler:(id)sender {
    
    UIButton *sw = (UIButton *)sender;
    sw.selected = !sw.selected;
    if (sw.selected == YES)
    {
        for (OptionModel *item in item3.options)
        {
            if ([item.qo_content rangeOfString:@"是"].location != NSNotFound)
            {
                sw.tag = [item.qo_id integerValue];
            }
        }
    }
    else
    {
        for (OptionModel *item in item3.options)
        {
            if ([item.qo_content rangeOfString:@"否"].location != NSNotFound || [item.qo_content rangeOfString:@"不"].location != NSNotFound)
            {
                sw.tag = [item.qo_id integerValue];
            }
        }
    }
}
@end
