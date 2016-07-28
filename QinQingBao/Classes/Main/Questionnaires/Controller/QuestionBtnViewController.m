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
    self.orderNumberLb.text = [NSString stringWithFormat:@"%d/%d",(int)self.eq_id,(int)self.dataProvider.count];
    
    self.qModel = self.dataProvider[self.eq_id - 1];
    self.navigationItem.title = self.qModel.eq_title;
    
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
    //14题是有条件多选,"q_rule": "+82+83+85_84"
    if ([self.qModel.eq_id integerValue] == 14) {
        OptionModel *optionmode = self.datas[indexPath.row];
        if ([optionmode.qo_id integerValue] == 84) {
            for (NSIndexPath *idx in self.selectedIdxArray) {
                [collectionView deselectItemAtIndexPath:idx animated:YES];
            }
            [self.selectedIdxArray removeAllObjects];
        }else{
            for (NSIndexPath *idx in self.selectedIdxArray) {
                OptionModel *optionmode = self.datas[idx.row];
                if ([optionmode.qo_id integerValue] == 84) {
                    [collectionView deselectItemAtIndexPath:idx animated:YES];
                    [self.selectedIdxArray removeObject:idx];
                }
                
            }
        }
    }
    
    [self.selectedIdxArray addObject:indexPath];
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
    
//    [UIView animateWithDuration:0.3 animations:^{
//        [self.view layoutIfNeeded];
//    }];
    [self.btnCollectionView reloadData];
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
    if (self.isMultipleSelection) {
        [answerDict setValue:selectedDatas forKey:@"qa_detail"];
    }else{
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

//        NSLog(@"-------%@",self.answerProvider);
}

/**
 *  跳转到下一级
 */
-(void)toNextVC
{
    NSInteger nextQuestionId = self.eq_id + 1;
    if (nextQuestionId >= 4 && nextQuestionId < 15 && nextQuestionId != 10) {
        QuestionBtnViewController *nextQuestionBtnVC = [[QuestionBtnViewController alloc] init];
        nextQuestionBtnVC.dataProvider = self.dataProvider;
        nextQuestionBtnVC.eq_id = nextQuestionId;
        nextQuestionBtnVC.answerProvider = self.answerProvider;
        [self.navigationController pushViewController:nextQuestionBtnVC animated:YES];
    }else if (nextQuestionId == 10){
        QuestionThreeController *nextQuestionThreeVC = [[QuestionThreeController alloc] init];
        nextQuestionThreeVC.dataProvider = self.dataProvider;
        nextQuestionThreeVC.answerProvider = self.answerProvider;
        [self.navigationController pushViewController:nextQuestionThreeVC animated:YES];
    }else if (nextQuestionId == 15){
        QuestionResultController *vc = [[QuestionResultController alloc] init];
        vc.answerProvider = self.answerProvider;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
