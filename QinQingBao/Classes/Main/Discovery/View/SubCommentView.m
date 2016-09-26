//
//  SubCommentView.m
//  QinQingBao
//
//  Created by shi on 16/9/26.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "SubCommentView.h"
#define kMargin 5

@implementation SubCommentView

+ (SubCommentView *)createSubCommentView
{
    SubCommentView *v = [[SubCommentView alloc] init];
    
    return v;
}

- (instancetype)init
{
    if (self=[super init]) {
        //姓名
        UILabel *nameLb = [[UILabel alloc] init];
        nameLb.textColor = HMColor(153, 153, 153);
        nameLb.font = [UIFont systemFontOfSize:13];
        [self addSubview:nameLb];
        
        self.clipsToBounds = YES;
        
        self.nameLb = nameLb;
        
        //内容
        UILabel * commentLb= [[UILabel alloc] init];
        commentLb.numberOfLines = 0;
        [self addSubview:commentLb];
        self.commentLb = commentLb;
        
        self.backgroundColor = HMColor(251, 248, 245);
        self.layer.borderColor = HMColor(240, 234, 229).CGColor;
        
    }
    
    return self;
}

- (void)setItemData:(CommentContentModel *)itemData
{
    _itemData = itemData;
    self.nameLb.text = itemData.oldauthor;
    
    
    if (itemData.oldcommon) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 4;
        NSDictionary *attrDict1 = @{
                                    NSFontAttributeName:[UIFont systemFontOfSize:13],
                                    NSForegroundColorAttributeName:HMColor(153, 153, 153),
                                    NSParagraphStyleAttributeName:paragraph
                                    };
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:itemData.oldcommon attributes:attrDict1];
        self.commentLb.attributedText = attrStr;

    }
}

- (CGSize)getSizeByWidth:(CGFloat)viewWidth
{
    [self.nameLb sizeToFit];
    self.nameLb.frame = CGRectMake(kMargin, 5, self.nameLb.frame.size.width, self.nameLb.frame.size.height);
    
    CGSize contentSize = [self.commentLb sizeThatFits:CGSizeMake(viewWidth - 2 * kMargin, MAXFLOAT)];
    self.commentLb.frame = CGRectMake(kMargin, CGRectGetMaxY(self.nameLb.frame)+5, contentSize.width, contentSize.height);

    return CGSizeMake(viewWidth, CGRectGetMaxY(self.commentLb.frame) + 5);
}

@end
