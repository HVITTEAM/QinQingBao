//
//  ScrollMenuView.m
//  Scroll
//
//  Created by shi on 16/9/10.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "ScrollMenuView.h"
#import "ScrollMenuLayout.h"

NSString *const KScrollMenuTitle = @"scrollMenuTitle";
NSString *const KScrollMenuImg   = @"scrollMenuImg";

static NSString *scrollMenuCellId = @"scrollMenuCell";

@interface ScrollMenuView ()<UIScrollViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (strong, nonatomic)UICollectionView *collectionView;

@property (strong, nonatomic)ScrollMenuLayout *layout;

@property (strong, nonatomic)UIPageControl *pageControl;

@end

@implementation ScrollMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.layout = [[ScrollMenuLayout alloc] init];
        //设置默认值
        self.layout.row = 1;
        self.layout.col = 4;
        self.layout.margin = UIEdgeInsetsMake(0, 0, 0, 0);
        self.layout.rowSpace = 0;
        self.layout.colSpace = 0;
    
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:self.layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.pagingEnabled = YES;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        
        UINib *nib = [UINib nibWithNibName:@"ScrollMenuCell" bundle:nil];
        [self.collectionView registerNib:nib forCellWithReuseIdentifier:scrollMenuCellId];
        
        self.collectionView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.collectionView];
    
        self.pageControl = [[UIPageControl alloc] init];
        self.pageControl.currentPage = 0;
        self.pageControl.hidesForSinglePage = YES;
        self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1.0];
        self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:198.0/255 green:156.0/255 blue:109.0/255 alpha:1.0];
        [self addSubview:self.pageControl];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
     NSInteger pageNum = ceil(self.datas.count * 1.0 / (self.row * self.col));
    if (self.shouldShowIndicator) {
        self.collectionView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 30);
        
        self.pageControl.numberOfPages = pageNum;
        self.pageControl.frame = CGRectMake(0, self.bounds.size.height - 30, self.bounds.size.width, 30);
        
    }else{
        self.collectionView.frame = self.bounds;
    }
}

- (void)setRow:(NSInteger)row
{
    _row = row;
    self.layout.row = row;
}

- (void)setCol:(NSInteger)col
{
    _col = col;
    self.layout.col = col;
    
}

- (void)setMargin:(UIEdgeInsets)margin
{
    _margin = margin;
    self.layout.margin = margin;
}

- (void)setRowSpace:(CGFloat)rowSpace
{
    _rowSpace = rowSpace;
    self.layout.rowSpace = rowSpace;
}

- (void)setColSpace:(CGFloat)colSpace
{
    _colSpace = colSpace;
    self.layout.colSpace = colSpace;
}

- (void)setDatas:(NSArray<NSDictionary<NSString *,NSString *> *> *)datas
{
    _datas = datas;
    [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:scrollMenuCellId forIndexPath:indexPath];
    
    NSDictionary *dict = self.datas[indexPath.row];
    
    UILabel *lb = (UILabel *)[cell viewWithTag:16];
    lb.text = dict[KScrollMenuTitle];
    
    UIImageView *imgv = (UIImageView *)[cell viewWithTag:15];
    NSString *imgName = dict[KScrollMenuImg];
    if (imgName) {
        if ([imgName hasPrefix:@"http://"]) {
            NSURL *url = [[NSURL alloc] initWithString:imgName];
            [imgv sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"ScrollMenuIcon.png"]];

        }else{
            imgv.image = [UIImage imageNamed:imgName]?:[UIImage imageNamed:@"ScrollMenuIcon.png"];
        }
    }else{
        imgv.image = [UIImage imageNamed:@"ScrollMenuIcon.png"];
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tapScrollMenuItemCallBack) {
        self.tapScrollMenuItemCallBack(indexPath.row);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger idx = (int)(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5);
    self.pageControl.currentPage = idx;
}


@end
