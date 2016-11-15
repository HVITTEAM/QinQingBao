//
//  ArchivesCell.m
//  QinQingBao
//
//  Created by shi on 2016/11/7.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ArchivesCell.h"
#import "RelativesCell.h"
#define kScaleOfScreen (MTScreenW / 320)

@interface ArchivesCell ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

/**无数据时候的提示label*/
@property (weak, nonatomic) IBOutlet UILabel *placeholdLb;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scanIconWidthCon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionRightMarginCon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionLeftMarginCon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMarginCon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMarginCon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *placeholdLbCon;

@end

@implementation ArchivesCell

@synthesize relativesArr = _relativesArr;

+ (instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"archivesCell";
    ArchivesCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ArchivesCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

#pragma mark - 重写父类方法
- (void)awakeFromNib {
    [super awakeFromNib];

    UINib *nib = [UINib nibWithNibName:@"RelativesCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"relativesCell"];
    
    self.placeholdLb.text = @"暂无健康档案资料您,\n\n可新建或绑定亲友健康档案";
}

- (void)updateConstraints
{
    self.scanIconWidthCon.constant = kScaleOfScreen * 40;
    self.collectionLeftMarginCon.constant = 0;
    self.collectionRightMarginCon.constant = kScaleOfScreen * 15;
    self.leftMarginCon.constant = kScaleOfScreen * 15;
    self.rightMarginCon.constant = kScaleOfScreen * 15;
    self.placeholdLbCon.constant = kScaleOfScreen * (15 * 3 + 40 * 3);
    
    [super updateConstraints];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(40 * kScaleOfScreen, self.height - 1);
    self.collectionView.contentInset = UIEdgeInsetsMake(0, kScaleOfScreen * 15, 0, 0);
    layout.minimumLineSpacing = (MTScreenW - kScaleOfScreen * (15 * 4 + 40 * 5)) / 3 - 1;
}

#pragma mark - getter/setter
- (NSMutableArray *)relativesArr
{
    if (!_relativesArr) {
        _relativesArr = [[NSMutableArray alloc] init];
    }
    
    return _relativesArr;
}

- (void)setRelativesArr:(NSMutableArray *)relativesArr
{
    _relativesArr = relativesArr;
    
    if (relativesArr.count != 0) {
        self.placeholdLb.hidden = YES;
    }else{
        self.placeholdLb.hidden = NO;
    }
    
    [self.collectionView reloadData];
}

#pragma mark - 协议方法
#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.relativesArr.count == 0) {
        return 4;
    }
    return self.relativesArr.count + 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RelativesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"relativesCell" forIndexPath:indexPath];
    
    if (self.relativesArr.count == 0 || indexPath.row == self.relativesArr.count) {
        cell.titleLb.text = @"新增";
        cell.imgView.image = [UIImage imageNamed:@"placeholder-3"];
        cell.titleLb.textColor = [UIColor colorWithRGB:@"999999"];
        //不显示描边
        cell.showBorderLine = NO;
        
    }else{
        cell.titleLb.text = @"张三李四";
        [cell.imgView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"placeholder-0"]];
        cell.titleLb.textColor = [UIColor colorWithRGB:@"666666"];
        
        //设置描边
        cell.showBorderLine = self.showBorderLine;
    }

    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.relativesArr.count == 0 || indexPath.row == self.relativesArr.count) {
        if (self.addNewArchivesBlock) {
            self.addNewArchivesBlock();
        }
    }else{
        if (self.tapArchiveBlock) {
            self.tapArchiveBlock(indexPath.row);
        }
    }
}

#pragma mark - 公有方法
+ (NSInteger) cellHeight
{
    return kScaleOfScreen * 40 + 10 + 10 + 10 + 15;
}

#pragma mark - 事件方法
/**
 *  点击扫码
 */
- (IBAction)scanCodeAction:(id)sender
{
    if (self.scanBlock) {
        self.scanBlock();
    }
}

@end

