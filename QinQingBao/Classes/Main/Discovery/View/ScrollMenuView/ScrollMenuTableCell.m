//
//  ScrollMenuTableCell.m
//  Scroll
//
//  Created by shi on 16/9/10.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "ScrollMenuTableCell.h"

@interface ScrollMenuTableCell ()

@property (strong, nonatomic)ScrollMenuView *menuView;

@end

@implementation ScrollMenuTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (ScrollMenuTableCell *)createCellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"scrollMenuTableCell";
    ScrollMenuTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ScrollMenuTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        __weak typeof(cell) weakSelf = cell;
        ScrollMenuView *v = [[ScrollMenuView alloc] init];
        v.tapScrollMenuItemCallBack = ^(NSInteger idx){
            
            if (weakSelf.selectMenuItemCallBack) {
                weakSelf.selectMenuItemCallBack(idx);
            }
        };
//        v.row = 1;
//        v.col = 4;
//        v.margin = UIEdgeInsetsMake(0, 0, 0, 0);
//        v.rowSpace = 0;
//        v.colSpace = 0;
        [cell.contentView addSubview:v];
        cell.menuView = v;
    }
    
    return cell;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.menuView.frame = self.bounds;
}

- (void)setRow:(NSInteger)row
{
    _row = row;
    self.menuView.row = row;
}

- (void)setCol:(NSInteger)col
{
    _col = col;
    self.menuView.col = col;
}

- (void)setMargin:(UIEdgeInsets)margin
{
    _margin = margin;
    self.menuView.margin = margin;
}

- (void)setRowSpace:(CGFloat)rowSpace
{
    _rowSpace = rowSpace;
    self.menuView.rowSpace = rowSpace;
}

- (void)setColSpace:(CGFloat)colSpace
{
    _colSpace = colSpace;
    self.menuView.colSpace = colSpace;
}

- (void)setDatas:(NSArray *)datas
{
    _datas = datas;
    self.menuView.datas = datas;
}

- (void)setShouldShowIndicator:(BOOL)shouldShowIndicator
{
    _shouldShowIndicator = shouldShowIndicator;
    self.menuView.shouldShowIndicator = shouldShowIndicator;
}

@end
