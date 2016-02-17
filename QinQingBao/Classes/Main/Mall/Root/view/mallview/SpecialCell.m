//
//  SpecialCell.m
//  QinQingBao
//
//  Created by shi on 16/2/1.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "SpecialCell.h"
#import "SpecialModel.h"

@interface SpecialCell ()<UIScrollViewDelegate>
{
    NSMutableArray *_specialArray;
}

@property(strong,nonatomic)UIScrollView *scrollView;                        //滚动用的scrollView

@property(strong,nonatomic)UIPageControl *pageControl;                      //滚动用的scrollView

@property(strong,nonatomic)NSMutableArray *specialImageViewArray;           //添加的ImageView的数组

@property(assign,nonatomic)NSInteger currentIndex;                        

@end

@implementation SpecialCell

-(SpecialCell *)initSpecialCellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)idx
{
    static NSString *specialCellId = @"specialCell";
    SpecialCell *cell = [tableView dequeueReusableCellWithIdentifier:specialCellId];
    if (!cell) {
        cell = [[SpecialCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:specialCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIScrollView *tempScrollview = [[UIScrollView alloc] init];
        tempScrollview.pagingEnabled = YES;
        tempScrollview.delegate = cell;
        [cell addSubview:tempScrollview];
        cell.scrollView = tempScrollview;
        
        cell.pageControl = [[UIPageControl alloc] init];
        [cell addSubview:cell.pageControl];
        
        cell.clipsToBounds = YES;
        
    }
    return cell;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = CGSizeMake(self.width * self.specialImageViewArray.count, self.height);
    self.scrollView.contentOffset = CGPointMake(self.width, 0);
    
    for (int i = 0;i < self.specialImageViewArray.count; i++) {
        UIImageView *imgView = self.specialImageViewArray[i];
        imgView.frame = CGRectMake(i * self.width, 0, self.width, self.height);
    }
    self.pageControl.frame = CGRectMake(0, self.height - 20, self.width, 20);
}

-(NSMutableArray *)specialImageViewArray
{
    if (!_specialImageViewArray) {
        _specialImageViewArray = [[NSMutableArray alloc] init];
    }
    return _specialImageViewArray;
}

-(void)setSpecialArray:(NSMutableArray *)specialArray
{
    _specialArray = specialArray;
    
    if (_specialArray.count == 0) {
        return;
    }
    //将原先的UIImageView删除
    [self.specialImageViewArray removeAllObjects];
    NSArray *subImageviewArray = self.scrollView.subviews;
    for (UIImageView *imgview in subImageviewArray) {
        [imgview removeFromSuperview];
    }
    
    //创建UIImageView
    for (int i = 0; i < _specialArray.count + 2; i++) {
        //创建图片view
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.userInteractionEnabled = YES;
        [self.specialImageViewArray addObject:imgView];
        [self.scrollView addSubview:imgView];
        
        //添加单击手势
        UITapGestureRecognizer *gestureRe = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTaped:)];
        gestureRe.numberOfTapsRequired = 1;
        gestureRe.numberOfTouchesRequired = 1;
        [imgView addGestureRecognizer:gestureRe];
        
        //加载图片
        SpecialModel *model = _specialArray[0];
        if (i == 0) {
            model = [_specialArray lastObject];
        }else if (i == _specialArray.count + 1){
            model = [_specialArray firstObject];
        }else{
            int n = i - 1;
            model = _specialArray[n];
        }
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/shop/%@%@",URL_Local,self.intermediateImageUrl,model.image];
        NSURL *url = [[NSURL alloc] initWithString:urlStr];
        [imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholderImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
    }
    self.pageControl.numberOfPages = self.specialArray.count;
}

#pragma mark -- 协议方法 --
#pragma mark  UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger idx = (scrollView.contentOffset.x+0.5)/self.scrollView.bounds.size.width -1;
    if (idx < 0) {
        idx = 0;
    }
    self.pageControl.currentPage = idx;
    self.currentIndex = idx;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.scrollView.contentOffset.x == 0) {
        //因为总共有self.imageViewArray.count+2张
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * (self.specialImageViewArray.count - 2), 0);
    }else if (self.scrollView.contentOffset.x == self.scrollView.frame.size.width * (self.specialImageViewArray.count -1)) {
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    }

}

/**
 *  专题图片被点击
 */
-(void)imageViewTaped:(UITapGestureRecognizer *)recognizer
{
    if ([self.delegate respondsToSelector:@selector(specialCell:specialTappedOfModel:)]) {
        [self.delegate specialCell:self specialTappedOfModel:self.specialArray[self.currentIndex]];
    }
    
}

@end
