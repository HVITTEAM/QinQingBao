//
//  DiseaseBtnController.m
//  QinQingBao
//
//  Created by shi on 16/8/10.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "DiseaseBtnController.h"
#import "QuestionThreeController.h"
#import "QuestionResultController.h"
#import "QuestionModel.h"
#import "QuestionModel_1.h"
#import "OptionModel.h"

@interface DiseaseBtnController ()

@property (strong,nonatomic)QuestionModel *qModel;

@property (strong,nonatomic)QuestionModel_1 *qModel_1;

@end

@implementation DiseaseBtnController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setDatasForUI];
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
    if (self.datas.count >= 5) {
        self.isTwo = YES;
    }
    
    //设置默认数据
    if (self.datas.count > 0) {
        NSIndexPath *idx = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.btnCollectionView selectItemAtIndexPath:idx animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        [self.selectedIdxArray addObject:idx];
    }
}

#pragma mark - 重写父类方法
//重写父类方法
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
    //    NSLog(@"-------------%@",self.answerProvider);
}

/**
 *  跳转到下一页面
 */
-(void)toNextVC
{
    NSInteger nextQuestionId = self.eq_id + 1;
    if (nextQuestionId >= 4 && nextQuestionId <= 16 && nextQuestionId != 10) {
        DiseaseBtnController *nextQuestionBtnVC = [[DiseaseBtnController alloc] init];
        nextQuestionBtnVC.dataProvider = self.dataProvider;
        nextQuestionBtnVC.eq_id = nextQuestionId;
        nextQuestionBtnVC.exam_id = self.exam_id;
         nextQuestionBtnVC.e_title = self.e_title;
        nextQuestionBtnVC.calculatype = self.calculatype;
        nextQuestionBtnVC.answerProvider = self.answerProvider;
        [self.navigationController pushViewController:nextQuestionBtnVC animated:YES];
    }else if (nextQuestionId == 10){
        QuestionThreeController *nextQuestionThreeVC = [[QuestionThreeController alloc] init];
        nextQuestionThreeVC.dataProvider = self.dataProvider;
        nextQuestionThreeVC.answerProvider = self.answerProvider;
        nextQuestionThreeVC.exam_id = self.exam_id;
        nextQuestionThreeVC.e_title = self.e_title;

        nextQuestionThreeVC.calculatype = self.calculatype;
        [self.navigationController pushViewController:nextQuestionThreeVC animated:YES];
    }else if (nextQuestionId == 17){
        QuestionResultController *vc = [[QuestionResultController alloc] init];
        vc.answerProvider = self.answerProvider;
        vc.exam_id = self.exam_id;
        vc.e_title = self.e_title;
        vc.calculatype = self.calculatype;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
