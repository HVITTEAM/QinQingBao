//
//  SearchViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/11.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "SearchViewController.h"
#import "GoodsTableViewController.h"

@interface SearchViewController ()<UITextFieldDelegate>
{
    NSMutableArray *data;
    
    UILabel *nonelab;
}
@end

@implementation SearchViewController

-(instancetype)init
{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    data = [ArchiverCacheHelper getLocaldataBykey:Search_Archiver_Key filePath:Search_Archiver_Path];
    if (data == nil)
        data = [[NSMutableArray alloc] init];
    else if (data.count >0)
    {
        self.collectView.hidden = NO;
        nonelab.hidden = YES;
    }
    [self.collectView reloadData];
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [super viewDidLoad];
    
    [self initCollectionView];
    
    UITextField *text = [[UITextField alloc] init];
    text.layer.cornerRadius = 3;
    text.returnKeyType = UIReturnKeySearch;
    text.textColor = [UIColor colorWithRGB:@"333333"];
    text.font = [UIFont systemFontOfSize:14];
    text.tintColor = [UIColor darkGrayColor];
    text.alpha = 0.9;
    text.delegate = self;
    text.text= @"    铁皮枫斗";
    text.backgroundColor = [UIColor whiteColor];
    text.width = MTScreenW *0.7;
    text.height = 30;
    self.navigationItem.titleView = text;
    [text becomeFirstResponder];
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search.png"]];
    img.frame = CGRectMake(10, 12, 16, 16);
    [self.view addSubview:img];
    
    UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(MTScreenW - 30, 10, 16, 16)];
    [deleteBtn addTarget:self action:@selector(deleteHistory) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"rabige.png"] forState:UIControlStateNormal];
    [self.view addSubview:deleteBtn];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 100, 20)];
    lab.text = @"搜索历史";
    lab.font = [UIFont systemFontOfSize:13];
    lab.textColor = [UIColor colorWithRGB:@"333333"];
    [self.view addSubview:lab];
    
    [self.collectView registerNib:[UINib nibWithNibName:@"HistoryViewCell" bundle:nil] forCellWithReuseIdentifier:@"HistoryViewCell"];
    [self.collectView reloadData];
    
    if (data.count == 0)
    {
        if (nonelab == nil)
            nonelab = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, MTScreenW, 20)];
        nonelab.textAlignment = NSTextAlignmentCenter;
        nonelab.text = @"暂无搜索历史";
        nonelab.font = [UIFont systemFontOfSize:13];
        nonelab.textColor = [UIColor colorWithRGB:@"333333"];
        [self.view addSubview:nonelab];
        self.collectView.hidden = YES;
    }
}

/*
 *  初始化服务类别列表
 */
-(void)initCollectionView
{
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    self.collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 30, MTScreenW - 20, MTScreenH - 20) collectionViewLayout:flowLayout];
    self.collectView.backgroundColor = [UIColor whiteColor];
    [self.collectView registerNib:[UINib nibWithNibName:@"SQCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"MTCommonCollecttionCell"];
    self.collectView.delegate = self;
    self.collectView.dataSource = self;
    [self.view addSubview:self.collectView];
}

#pragma mark deleteHistory

-(void)deleteHistory
{
    //保存记录
    [data removeAllObjects];
    [ArchiverCacheHelper saveNSMutableArrayToLoacl:data key:Search_Archiver_Key filePath:Search_Archiver_Path];
    [self.collectView reloadData];

    self.collectView.hidden = YES;
    
    if (nonelab == nil)
        nonelab = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, MTScreenW, 20)];
    nonelab.textAlignment = NSTextAlignmentCenter;
    nonelab.text = @"暂无搜索历史";
    nonelab.font = [UIFont systemFontOfSize:13];
    nonelab.textColor = [UIColor colorWithRGB:@"333333"];
    nonelab.hidden = NO;
    [self.view addSubview:nonelab];
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //收起键盘 字符串去首尾空格
    [textField resignFirstResponder];
    NSString *str = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //保存记录
    [data addObject:str];
    [ArchiverCacheHelper saveNSMutableArrayToLoacl:data key:Search_Archiver_Key filePath:Search_Archiver_Path];
    
    //跳转界面
    GoodsTableViewController *vc = [[GoodsTableViewController alloc] init];
    vc.keyWords = str;
    [self.navigationController pushViewController:vc animated:YES];
    return YES;
}

#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return data.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 10);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HistoryViewCell" forIndexPath:indexPath];
    cell.keyword = data[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_cell == nil) {
        _cell = [[NSBundle mainBundle]loadNibNamed:@"HistoryViewCell" owner:nil options:nil][0];
    }
    _cell.keyword = data[indexPath.row];
    return [_cell sizeForCell];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转界面
    GoodsTableViewController *vc = [[GoodsTableViewController alloc] init];
    vc.keyWords = data[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
