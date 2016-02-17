//
//  DiscountCell.m
//  QinQingBao
//
//  Created by shi on 16/1/26.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#define kHeadAreaHeight 44
#define kMarginToBottom 10

#import "DiscountCell.h"
#import "CommodityCell.h"
#import "GroupbuyMode.h"

static NSString *commodityCellId = @"commodityCell";

@interface DiscountCell ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *goodsCollectionView;         //商品CollectionView

@property(strong,nonatomic)UICollectionViewFlowLayout *flowLayout;

@property (weak, nonatomic) IBOutlet UIImageView *titleIconImgView;                 //标题图片

@property (weak, nonatomic) IBOutlet UILabel *hoursLb;                      //到计时剩余小时

@property (weak, nonatomic) IBOutlet UILabel *minutesLb;                   //到计时剩余分钟

@property (weak, nonatomic) IBOutlet UILabel *secondsLb;                   //到计时剩余秒

@property (weak, nonatomic) IBOutlet UIView *hoursView;

@property (weak, nonatomic) IBOutlet UIView *minutesView;

@property (weak, nonatomic) IBOutlet UIView *secondView;

@end

@implementation DiscountCell

-(DiscountCell *)initDiscountCellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)idx
{
    static NSString *discountCellId = @"discountCell";
    DiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:discountCellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DiscountCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib
{
    self.hoursView.layer.cornerRadius = 5.0f;
    self.hoursView.layer.masksToBounds = YES;
    self.hoursView.layer.borderColor = HMColor(97, 97, 97).CGColor;
    self.hoursView.layer.borderWidth = 0.5;
    
    self.minutesView.layer.cornerRadius = 5.0f;
    self.minutesView.layer.masksToBounds = YES;
    self.minutesView.layer.borderColor = HMColor(97, 97, 97).CGColor;
    self.minutesView.layer.borderWidth = 0.5;
    
    self.secondView.layer.cornerRadius = 5.0f;
    self.secondView.layer.masksToBounds = YES;
    self.secondView.layer.borderColor = HMColor(97, 97, 97).CGColor;
    self.secondView.layer.borderWidth = 0.5;
    
    //创建一个FlowLayout布局对象
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout.minimumInteritemSpacing = 10;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0,10,0,10);
    
    //设置UICollectionView
    self.goodsCollectionView.collectionViewLayout = self.flowLayout;
    self.goodsCollectionView.backgroundColor = [UIColor clearColor];
    self.goodsCollectionView.showsHorizontalScrollIndicator = NO;
    self.goodsCollectionView.delegate = self;
    self.goodsCollectionView.dataSource = self;

    //注册 cell
    UINib *nib = [UINib nibWithNibName:@"CommodityCell" bundle:nil];
    [self.goodsCollectionView registerNib:nib forCellWithReuseIdentifier:commodityCellId];
    
    //设置标题图片(钜惠专区)
    self.titleIconImgView.image = [UIImage imageNamed:@"superseller.png"];
    
}

-(void)setGoodsDatas:(NSMutableArray *)goodsDatas
{
    _goodsDatas = goodsDatas;
    [self.goodsCollectionView reloadData];
}

-(void)setHours:(NSString *)hours
{
    self.hoursLb.text = hours;
}

-(void)setMinutes:(NSString *)minutes
{
    self.minutesLb.text = minutes;
}

-(void)setSeconds:(NSString *)seconds
{
    self.secondsLb.text = seconds;
}

#pragma mark -- 协议方法 --
#pragma mark  UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.goodsDatas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CommodityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:commodityCellId
                                                                    forIndexPath:indexPath];
    GroupbuyMode *model = self.goodsDatas[indexPath.row];
    cell.commodityName = model.goods_name;
    cell.oldprice = model.goods_price;
    cell.newprice = model.groupbuy_price;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/shop/%@%@/%@",URL_Local,self.intermediateImageUrl,model.store_id,model.groupbuy_image1];
    NSURL *url = [[NSURL alloc] initWithString:urlStr];
    
    [cell.commodityImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholderImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];

    return cell;
}

#pragma mark UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //设置 cell 大小，一行显示2.5个 cell
    CGFloat interspace = self.flowLayout.minimumInteritemSpacing;
    CGFloat itemWidth = floor((MTScreenW - 2 * interspace)/2.5);
    CGFloat itemHeight = self.height - kHeadAreaHeight - kMarginToBottom - 4;
    
    return CGSizeMake(itemWidth, itemHeight);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GroupbuyMode *model = self.goodsDatas[indexPath.row];
    if ([self.delegate respondsToSelector:(@selector(discountCell:goodsModel:))]) {
        [self.delegate discountCell:self goodsModel:model];
    }
}

#pragma mark -- 私有方法 --
/**
 *  更多按钮(右箭头按钮)被点击
 */
- (IBAction)enterMoreCommoditys:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(discountCell:moreBtnClicked:)]) {
        [self.delegate discountCell:self moreBtnClicked:sender];
    }
}



@end
