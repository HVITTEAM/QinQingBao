//
//  BillCell.m
//  QinQingBao
//
//  Created by shi on 16/3/22.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "BillCell.h"
#import "WorkPicModel.h"

#define kImageMargin 10
#define kImageToSuperMargin 20

@interface BillCell ()

@property(strong,nonatomic)NSMutableArray *billImageViewArray;

@property(strong,nonatomic)UIView *imgContainer;

@property(assign,nonatomic)CGFloat cellHeight;

@end

@implementation BillCell

+(instancetype)createBillCellWithTableView:(UITableView *)tableview
{
    static NSString *billCellId = @"billCell";
    BillCell *cell = [tableview dequeueReusableCellWithIdentifier:billCellId];
    if (!cell) {
        cell = [[BillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:billCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

-(NSMutableArray *)billImageViewArray
{
    if (!_billImageViewArray) {
        _billImageViewArray = [[NSMutableArray alloc] init];
    }
    return _billImageViewArray;
}

-(void)setDataWithWorkPicModel:(WorkPicModel *)workPicModel
{
    NSInteger imageCount = workPicModel.pic_info.count;
    
    NSInteger oldNum = self.billImageViewArray.count;
    if (oldNum <= imageCount) {
        for (int i = 0; i < imageCount - oldNum; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [self.billImageViewArray addObject:imageView];
            [self.contentView addSubview:imageView];
            imageView.backgroundColor = HMColor(199, 178, 153);
            imageView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClicked:)];
            recognizer.numberOfTapsRequired = 1;
            recognizer.numberOfTouchesRequired = 1;
            [imageView addGestureRecognizer:recognizer];
        }
    }else{
        for (int i = 0; i < oldNum - imageCount; i++) {
            UIImageView *imageView = [self.billImageViewArray lastObject];
            [imageView removeFromSuperview];
            [self.billImageViewArray removeLastObject];
        }
    }
    
    CGFloat imageWidth = (MTScreenW - kImageToSuperMargin * 2 - kImageMargin * 4 )/ 5;
    
    for (int i = 0; i < self.billImageViewArray.count; i++) {
        UIImageView *imageView = self.billImageViewArray[i];
        imageView.tag = i;
        NSString *urlStr = [NSString stringWithFormat:@"%@/shop/%@%@",URL_Local,workPicModel.url,workPicModel.pic_info[i]];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"placeholderImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        if (i < 5) {
            imageView.frame = CGRectMake(kImageToSuperMargin + i * (imageWidth + kImageMargin), kImageMargin, imageWidth, imageWidth);
        }else {
            imageView.frame = CGRectMake(kImageToSuperMargin + (i - 5) * (imageWidth + kImageMargin), kImageMargin * 2 + imageWidth, imageWidth, imageWidth);
        }
    }
    
    self.cellHeight =CGRectGetMaxY(((UIImageView *)[self.billImageViewArray lastObject]).frame) + 10;

}

-(CGFloat)getCellHeight
{
    return self.cellHeight;
}

-(void)imageViewClicked:(UITapGestureRecognizer *)recognizer
{
    UIImageView *imgeView = (UIImageView *)[recognizer view];
    if ([self.delegate respondsToSelector:@selector(BillCell:clickedImageViewInIndex:)]) {
        [self.delegate BillCell:self clickedImageViewInIndex:imgeView.tag];
    }
}

@end
