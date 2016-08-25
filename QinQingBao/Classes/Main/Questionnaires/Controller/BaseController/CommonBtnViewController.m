//
//  QuestionThreeViewController.m
//  Healthy
//
//  Created by shi on 16/7/12.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#define btnVertSpace 10      //按钮之间的垂直间距
#define btnHorizSpace 10    //按钮之间的水平间距

#import "CommonBtnViewController.h"

@interface CommonBtnViewController ()

@end

@implementation CommonBtnViewController

@synthesize btnHeight = _btnHeight;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
    
    [self setCollectionViewHeight];
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
    
    self.orderNumberLb.text = nil;
    self.titleLb.text = nil;
    self.subtitleLb.text = nil;
    
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
//    OptionModel *optionmode = self.datas[indexPath.row];
//    
//    cell.titleLb .text = optionmode.qo_content;
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
 *  下一步,子类需重写
 */
- (IBAction)nextBtnClicke:(id)sender
{

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
 *  解析规则方法,子类可以根据自身需求选择使用或者另行创建新的解析规则方法
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
