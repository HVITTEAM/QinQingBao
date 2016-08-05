//
//  QuestionThreeViewController.m
//  Healthy
//
//  Created by shi on 16/7/12.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#define btnVertSpace 10      //按钮之间的垂直间距
#define btnHorizSpace 10    //按钮之间的水平间距

#import "QuestionBtnViewController.h"
#import "QuestionThreeController.h"
#import "QuestionResultController.h"
#import "ButtonCell.h"
#import "QuestionModel.h"
#import "QuestionModel_1.h"
#import "OptionModel.h"

@interface QuestionBtnViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightCons;

@property (weak, nonatomic) IBOutlet UICollectionView *btnCollectionView;

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@property (weak, nonatomic) IBOutlet UILabel *subtitleLb;

@property (weak, nonatomic) IBOutlet UILabel *orderNumberLb;

@property (strong, nonatomic)NSMutableArray *selectedIdxArray;   //选中的选项(数组元素是NSIndexPath)

@property (strong,nonatomic)QuestionModel *qModel;

@property (strong,nonatomic)QuestionModel_1 *qModel_1;

@end

@implementation QuestionBtnViewController

@synthesize btnHeight = _btnHeight;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
    
    [self setCollectionViewHeight];
    
    [self setDatasForUI];
}

-(void)setupUI
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.btnCollectionView.collectionViewLayout = flowLayout;
    flowLayout.minimumLineSpacing = btnVertSpace;
    
    //注册cell
    UINib *buttonCellNib = [UINib nibWithNibName:@"ButtonCell" bundle:nil];
    [self.btnCollectionView registerNib:buttonCellNib forCellWithReuseIdentifier:@"buttonCell"];
    
    //按钮圆角
    self.nextBtn.layer.cornerRadius = 7.0f;
    
    //容器视图圆角
    self.containerView.layer.borderWidth = 1.0f;
    self.containerView.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
    self.containerView.layer.cornerRadius = 7.0f;
    
    self.btnCollectionView.allowsMultipleSelection = self.isMultipleSelection;
}

/**
 *  设置界面的数据
 */
-(void)setDatasForUI
{
    //设置页面序号
    NSString *pageNumStr = [NSString stringWithFormat:@"%d/%d",(int)self.eq_id,(int)self.dataProvider.count];
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
    
    self.qModel = self.dataProvider[self.eq_id - 1];
    self.navigationItem.title = self.qModel.eq_subtitle;
    
    self.qModel_1 = [self.qModel.questions firstObject];
    self.titleLb.text = self.qModel_1.q_title;
    self.subtitleLb.text = self.qModel_1.q_subtitle;
    
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:self.qModel_1.q_logo_url] placeholderImage:[UIImage imageNamed:@"head"]];
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

#pragma mark - 属性的setter方法和getter方法

-(NSMutableArray *)selectedIdxArray
{
    if (!_selectedIdxArray) {
        _selectedIdxArray = [[NSMutableArray alloc] init];
    }
    return _selectedIdxArray;
}

-(CGFloat)btnHeight
{
    if (_btnHeight <= 0) {
        //默认高度是45
        _btnHeight = 45;
    }
    
    return _btnHeight;
}

/**
 *  设置按钮高度
 */
-(void)setBtnHeight:(CGFloat)btnHeight
{
    _btnHeight = btnHeight;
    [self setCollectionViewHeight];
}

/**
 *  设置数据源
 */
-(void)setDatas:(NSArray *)datas
{
    _datas = datas;
    
    self.selectedIdxArray = nil;
    
    [self setCollectionViewHeight];
    
}

/**
 *  设置是一排按钮还是两排按钮
 */
-(void)setIsTwo:(BOOL)isTwo
{
    _isTwo = isTwo;
    
    [self setCollectionViewHeight];
}

/**
 *  设置是否允许多选
 */
-(void)setIsMultipleSelection:(BOOL)isMultipleSelection
{
    _isMultipleSelection = isMultipleSelection;
    
    self.btnCollectionView.allowsMultipleSelection = self.isMultipleSelection;
    
    self.selectedIdxArray = nil;
    
    [self.btnCollectionView reloadData];
}

#pragma mark - 协议方法

#pragma mark UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ButtonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"buttonCell" forIndexPath:indexPath];
    OptionModel *optionmode = self.datas[indexPath.row];
    
    cell.titleLb .text = optionmode.qo_content;
    cell.selected = [self.selectedIdxArray containsObject:indexPath];
    return cell;
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isTwo) {
        return CGSizeMake(floor((collectionView.bounds.size.width - btnHorizSpace) / 2), self.btnHeight);
    }
    
    return CGSizeMake(floor(collectionView.bounds.size.width), self.btnHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (self.qModel_1.q_rule) {
    
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
    
    if (![self.selectedIdxArray containsObject:indexPath]) {
        [self.selectedIdxArray addObject:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedIdxArray removeObject:indexPath];
}

#pragma mark - 事件方法
/**
 *  下一步
 */
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

/**
 *  设置答案
 */
-(void)setAnswer
{
    //获取选中的数据
    NSMutableArray *selectedDatas = [[NSMutableArray alloc] init];
    for (NSIndexPath *idx in self.selectedIdxArray) {
        
        OptionModel *option = self.datas[idx.row];
        [selectedDatas addObject:option.qo_id];
    }
    
    //创建答案
    NSMutableDictionary *answerDict = [[NSMutableDictionary alloc] init];
    [answerDict setValue:self.qModel_1.q_id forKey:@"q_id"];
    [answerDict setValue:self.qModel_1.q_type forKey:@"q_type"];
    
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
 *  跳转到下一级
 */
-(void)toNextVC
{
    NSInteger nextQuestionId = self.eq_id + 1;
    if (nextQuestionId >= 4 && nextQuestionId <= 16 && nextQuestionId != 10) {
        QuestionBtnViewController *nextQuestionBtnVC = [[QuestionBtnViewController alloc] init];
        nextQuestionBtnVC.dataProvider = self.dataProvider;
        nextQuestionBtnVC.eq_id = nextQuestionId;
        nextQuestionBtnVC.exam_id = self.exam_id;
        nextQuestionBtnVC.answerProvider = self.answerProvider;
        [self.navigationController pushViewController:nextQuestionBtnVC animated:YES];
    }else if (nextQuestionId == 10){
        QuestionThreeController *nextQuestionThreeVC = [[QuestionThreeController alloc] init];
        nextQuestionThreeVC.dataProvider = self.dataProvider;
        nextQuestionThreeVC.answerProvider = self.answerProvider;
        nextQuestionThreeVC.exam_id = self.exam_id;
        [self.navigationController pushViewController:nextQuestionThreeVC animated:YES];
    }else if (nextQuestionId == 17){
        QuestionResultController *vc = [[QuestionResultController alloc] init];
        vc.answerProvider = self.answerProvider;
        vc.exam_id = self.exam_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 内部方法
/**
 *  设置CollectionView的实际高度
 */
-(void)setCollectionViewHeight
{
    CGFloat h = 0;
    if (self.datas.count != 0) {
        //根据按钮个数计算整个集合视图的高度
        if (!self.isTwo) {
            h = self.datas.count * self.btnHeight + (self.datas.count - 1) * btnVertSpace;
        }else{
            h = ceil((self.datas.count / 2.0)) * self.btnHeight + ceil((self.datas.count - 1) / 2.0) * btnVertSpace;
        }
    }
    
    self.collectionViewHeightCons.constant = h;
    
    [self.btnCollectionView reloadData];
}

/**
 *  解析规则
 *
 *  @param rule 规则字符串
 *
 *  @return 返回一个数组,数组元素也是一个数组,表示一组可同时存在的选项,不同组选项之间不共存
 */
-(NSArray *)analyzeRules:(NSString *)rule
{
#define option1 1
#define option2 2
    
    NSMutableArray *options_one = [[NSMutableArray alloc] init];
    NSMutableArray *options_two = [[NSMutableArray alloc] init];
    
    NSRange range = NSMakeRange(0, 1);
    //当前选项id
    __block NSMutableString *optionId;
    //当前选项属于哪一组
    __block NSInteger whichOption = option1;
    
    void(^chooseOptionsBlock)() = ^{
        if (optionId) {
            if (option1 == whichOption) {
                //当前选项id存在且属于第一组
                [options_one addObject:optionId];
            }else{
                [options_two addObject:optionId];
            }
        }
    };
    //通过循环对选项进行分组
    for (int i = 0; i < rule.length; i++) {
        range.location = i;
        //获取单个字符
        NSString *tempStr = [rule substringWithRange:range];
        if ([tempStr isEqualToString:@"+"]) {
            chooseOptionsBlock();
            optionId = [[NSMutableString alloc] init];
            whichOption = option1;
        }else if ([tempStr isEqualToString:@"_"]){
            chooseOptionsBlock();
            optionId = [[NSMutableString alloc] init];
            whichOption = option2;
        }else{
            [optionId appendString:tempStr];
        }
        
        if (i == rule.length -1) {
            chooseOptionsBlock();
        }
    }
    
    return @[options_one,options_two];
    
#undef option1
#undef option2
}


@end
