//
//  SubCommentView.h
//  QinQingBao
//
//  Created by shi on 16/9/26.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentContentModel.h"

@interface SubCommentView : UIView

@property (strong, nonatomic) UILabel *nameLb;

@property (strong, nonatomic) UILabel *commentLb;

+ (SubCommentView *)createSubCommentView;

@property (strong, nonatomic) CommentContentModel *itemData;

- (CGSize)getSizeByWidth:(CGFloat)viewWidth;

@end
