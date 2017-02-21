//
//  LifeHealthViewController.m
//  QinQingBao
//
//  Created by shi on 16/8/10.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "LifeHealthViewController.h"
#import "QuestionModel.h"
#import "QuestionModel_1.h"
#import "OptionModel.h"
#import "QuestionResultController2.h"
#import "ResultModel.h"
#import "QuestionResultController3.h"

@interface LifeHealthViewController ()

@property (strong,nonatomic)QuestionModel *qModel;

@property (strong,nonatomic)QuestionModel_1 *qModel_1;

@property (strong,nonatomic)UIView *promptView;

@end

@implementation LifeHealthViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;

}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bigImageViewWidthHeightCons.active = NO;
    NSLayoutConstraint *cons = [NSLayoutConstraint constraintWithItem:self.bigImageView
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.bigImageView
                                                            attribute:NSLayoutAttributeHeight
                                                           multiplier:668/260.0
                                                             constant:0];
    cons.active = YES;
    
    //    [self.bigImageView addConstraint:];
    
    if (!self.answerProvider)
        self.answerProvider = [[NSMutableArray alloc] init];
    
    if (self.eq_id <= 1) {
        [self getDataProvider];
    }else{
        [self setDatasForUI];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //界面消失时认为用户已经选择完成,设置答案
    [self setAnswer];
}

/**
 *  设置界面的数据
 */
-(void)setDatasForUI
{
    //设置页面序号
    NSString *pageNumStr = [NSString stringWithFormat:@"%d/%02d",(int)self.eq_id,(int)self.dataProvider.count];
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
    self.orderNumberLb.attributedText = attrStr;
    
    if (self.dataProvider.count == 0) {
        return;
    }
    
    self.qModel = self.dataProvider[self.eq_id - 1];
    self.navigationItem.title = self.qModel.eq_subtitle;
    
    self.qModel_1 = [self.qModel.questions firstObject];
    self.titleLb.text = self.qModel_1.q_title;
    self.subtitleLb.text = self.qModel_1.q_subtitle;
    
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:self.qModel_1.q_logo_url] placeholderImage:nil];
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:self.qModel_1.q_detail_url] placeholderImage:[UIImage imageNamed:@"placeholder_serviceMarket"]];
    
    
    //类型  1.单选  2.多选  3.单行输入 4.多行输入  5.多项填空  6.有条件选择
    switch ([self.qModel_1.q_type integerValue]) {
        case 1:
        case 3:
        case 4:
        case 5:
            self.isMultipleSelection = NO;
            break;
        case 2:
        case 6:
            self.isMultipleSelection = YES;
            break;
        default:
            self.isMultipleSelection = NO;
            break;
    }
    
    //选项超过4个就两行排列
    self.datas = self.qModel_1.options;
    
    //----以下为设置默认数据-----//
    //判断是不是已经保存过答案
    //answerIdx表示题目答案的位置,-1表示还没有回答过题目
    NSInteger answerIdx = -1;
    for (NSDictionary *answer in self.answerProvider) {
        if ([answer[@"q_id"] isEqualToString:self.qModel_1.q_id]) {
            answerIdx = [self.answerProvider indexOfObject:answer];
        }
    }
    
    //小于0表示还没回答过题目,是第一次回答
    if (answerIdx < 0) {
        NSIndexPath *idx = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.btnCollectionView selectItemAtIndexPath:idx animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        [self.selectedIdxArray addObject:idx];
    }else{
        NSDictionary *oldAnswerDict = self.answerProvider[answerIdx];
        NSString *optionStr = oldAnswerDict[@"qa_detail"];
        NSArray *arr = [optionStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[],"]];
        NSLog(@"%@",arr);
        
        for (int i = 0; i < arr.count; i++) {
            NSString *option = arr[i];
            for (int j = 0; j < self.datas.count; j++) {
                
                OptionModel *optionmode = self.datas[j];
                if ([option isEqualToString:optionmode.qo_id]) {
                    NSIndexPath *idx = [NSIndexPath indexPathForRow:j inSection:0];
                    [self.btnCollectionView selectItemAtIndexPath:idx animated:YES scrollPosition:UICollectionViewScrollPositionNone];
                    [self.selectedIdxArray addObject:idx];
                }
                
            }
            
        }
    }
    //----设置默认数据end-----//

}

#pragma mark - 重写父类方法
//重写父类方法
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ButtonCell *cell = (ButtonCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    OptionModel *optionmode = self.datas[indexPath.row];
    cell.titleLb .text = optionmode.qo_content;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.qModel_1.q_rule && self.qModel_1.q_rule.length > 0) {
        
        NSArray *options = [self analyzeRules:self.qModel_1.q_rule];
        NSMutableArray *options_one = options[0];
        NSMutableArray *options_two = options[1];
        
        //按规则多选
        OptionModel *selectedOption = self.datas[indexPath.row];
        if ([options_one containsObject:selectedOption.qo_id]) {
            NSMutableArray *deSelectedOptions = [[NSMutableArray alloc] init];
            for (NSIndexPath *idx in self.selectedIdxArray) {
                OptionModel *option = self.datas[idx.row];
                if ([options_two containsObject:option.qo_id]) {
                    [deSelectedOptions addObject:idx];
                    [collectionView deselectItemAtIndexPath:idx animated:YES];
                }
            }
            [self.selectedIdxArray removeObjectsInArray:deSelectedOptions];
            
        }else{
            NSMutableArray *deSelectedOptions = [[NSMutableArray alloc] init];
            for (NSIndexPath *idx in self.selectedIdxArray) {
                OptionModel *option = self.datas[idx.row];
                if ([options_one containsObject:option.qo_id]) {
                    [deSelectedOptions addObject:idx];
                    [collectionView deselectItemAtIndexPath:idx animated:YES];
                }
            }
            [self.selectedIdxArray removeObjectsInArray:deSelectedOptions];
        }
    }
    
    //需要调用父类的这个方法
    [super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
}

//重写父类方法
- (IBAction)nextBtnClicke:(id)sender
{
    if (self.selectedIdxArray.count <= 0) {
        [NoticeHelper AlertShow:@"请先选择答案" view:nil];
        return;
    }
    
    //设置答案
    [self setAnswer];
    
    //跳转到下一级
    [self toNextVC];
    
}

#pragma mark - 内部方法
/**
 *  设置答案
 */
-(void)setAnswer
{
    //获取选中的选项qo_id
    NSMutableArray *selectedDatas = [[NSMutableArray alloc] init];
    for (NSIndexPath *idx in self.selectedIdxArray) {
        
        OptionModel *option = self.datas[idx.row];
        [selectedDatas addObject:option.qo_id];
    }
    
    //创建答案
    NSMutableDictionary *answerDict = [[NSMutableDictionary alloc] init];
    [answerDict setValue:self.qModel_1.q_id forKey:@"q_id"];
    [answerDict setValue:self.qModel_1.q_type forKey:@"q_type"];
    
    //如果用户选择了多个选项
    if (selectedDatas.count > 1) {
        NSMutableString *str = [@"[" mutableCopy];
        for (int i = 0; i < selectedDatas.count; i++) {
            [str appendFormat:@"%@",selectedDatas[i]];
            if (i < selectedDatas.count - 1) {
                [str appendString:@","];
            }
        }
        [str appendString:@"]"];
        [answerDict setValue:str forKey:@"qa_detail"];
        
    }else if(selectedDatas.count == 1){
        [answerDict setValue:selectedDatas[0] forKey:@"qa_detail"];
    }
    
    //判断是不是已经保存过答案
    //answerIdx表示题目答案的位置,-1表示还没有回答过题目
    NSInteger answerIdx = -1;
    for (NSDictionary *answer in self.answerProvider) {
        if ([answer[@"q_id"] isEqualToString:self.qModel_1.q_id]) {
            answerIdx = [self.answerProvider indexOfObject:answer];
        }
    }
    
    //小于0表示还没回答过题目,是第一次回答
    if (answerIdx < 0) {
        [self.answerProvider addObject:answerDict];
    }else{
        self.answerProvider[answerIdx] = answerDict;
    }
        NSLog(@"-------------%@",self.answerProvider);
}

/**
 *  跳转到下一页面
 */
-(void)toNextVC
{
    NSInteger nextQuestionId = self.eq_id + 1;
    if (nextQuestionId >= 1 && nextQuestionId <= self.dataProvider.count) {
        LifeHealthViewController *nextQuestionBtnVC = [[LifeHealthViewController alloc] init];
        nextQuestionBtnVC.dataProvider = self.dataProvider;
        nextQuestionBtnVC.eq_id = nextQuestionId;
        nextQuestionBtnVC.exam_id = self.exam_id;
        nextQuestionBtnVC.e_title = self.e_title;
        nextQuestionBtnVC.calculatype = self.calculatype;
        nextQuestionBtnVC.answerProvider = self.answerProvider;
        [self.navigationController pushViewController:nextQuestionBtnVC animated:YES];
    }else if (nextQuestionId == self.dataProvider.count + 1){
//        QuestionResultController2 *vc = [[QuestionResultController2 alloc] init];
//        vc.answerProvider = self.answerProvider;
//        vc.exam_id = self.exam_id;
//        vc.e_title = self.e_title;
//        vc.calculatype = self.calculatype;
//        [self.navigationController pushViewController:vc animated:YES];
        [self getResult];
    }
}

#pragma mark - 网络相关
/**
 *  获取数据源
 */
-(void)getDataProvider
{
    [CommonRemoteHelper RemoteWithUrl:URL_Get_questions parameters:@{@"id" :self.exam_id}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     NSDictionary *dict1 = [dict objectForKey:@"datas"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         NSString *msg = dict[@"errorMsg"];
                                         [NoticeHelper AlertShow:msg view:nil];
                                     }
                                     else
                                     {
                                         self.dataProvider = [QuestionModel objectArrayWithKeyValuesArray:[dict1 objectForKey:@"questions"]];
                                         [self setDatasForUI];
                                         
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                 }];
}

-(void)getResult
{
    NSMutableDictionary *resultdict = [[NSMutableDictionary alloc] init];
    [resultdict setObject:self.exam_id forKey:@"exam_id"];
    [resultdict setObject:self.e_title forKey:@"r_etitle"];
    [resultdict setObject:self.answerProvider forKey:@"qitem"];
    
    NSLog(@"%@",resultdict);
    NSString *dictstr = [self dictionaryToJson:[resultdict copy]];
    //去掉换行符
    NSString * encodingString = [dictstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *resultStr = [encodingString stringByReplacingOccurrencesOfString:@"%0A%20%20" withString:@""];
    [self submit_exam:resultStr];
    NSLog(@"%@",resultStr);
}

/**
 *  获取数据源
 */
-(void)submit_exam:(NSString *)resultStr
{
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] initWithDictionary:@{@"result" : resultStr,
                                                                                       @"client" : @"ios",
                                                                                       @"calculatype":self.calculatype
                                                                                       }];
    if ( [SharedAppUtil defaultCommonUtil].userVO.key)
    {
        [paramDict setObject:[SharedAppUtil defaultCommonUtil].userVO.key forKey:@"key"];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Submit_exam parameters:paramDict
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     [hud removeFromSuperview];
                                     id codeNum = [dict objectForKey:@"code"];
                                     NSDictionary *dict1 = [dict objectForKey:@"datas"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         
                                     }
                                     else
                                     {
                                         ResultModel *model = [ResultModel objectWithKeyValues:dict1];
                                         QuestionResultController3 *questionResultVC = [[QuestionResultController3 alloc] init];
                                         questionResultVC.r_ids = model.r_ids;
                                         questionResultVC.r_dangercoefficient = model.r_dangercoefficient;
                                         questionResultVC.hmd_advise = model.r_result.hmd_advise;
                                         questionResultVC.navigationItem.hidesBackButton = YES;
                                         [self.navigationController pushViewController:questionResultVC animated:YES];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                     NSLog(@"发生错误！%@",error);
                                     [hud removeFromSuperview];
                                 }];
}

//词典转换为字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


@end
