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
#import "ButtonCell.h"
#import "QuestionThreeController.h"

@interface QuestionBtnViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightCons;

@property (weak, nonatomic) IBOutlet UICollectionView *btnCollectionView;

@property (strong, nonatomic)NSMutableArray *selectedIdxArray;

@end

@implementation QuestionBtnViewController

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
    
    //--------------测试数据,模拟网络取数据,3秒后刷新 ----------------------------------------//
//    dispatch_time_t time_t = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC));
//    dispatch_after(time_t, dispatch_get_main_queue(), ^{
//        
//        self.datas = @[@"a0",@"a1",@"a2",@"a3"];
//    });
    
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
    cell.titleLb .text = self.datas[indexPath.row];
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
    [self.selectedIdxArray addObject:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedIdxArray removeObject:indexPath];
}

- (IBAction)nextBtnClicke:(id)sender
{
//    //获取选中的数据
//    NSMutableArray *selectedDatas = [[NSMutableArray alloc] init];
//    for (NSIndexPath *idx in self.selectedIdxArray) {
//        [selectedDatas addObject:self.datas[idx.row]];
//    }
//    
//    
//
//    NSLog(@"%@",selectedDatas);
    
    QuestionThreeController *vc = [[QuestionThreeController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
    [self.btnCollectionView reloadData];
}

@end
