//
//  PostsCommentCell.m
//  QinQingBao
//
//  Created by shi on 16/9/20.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "PostsCommentCell.h"
#import "SubCommentView.h"

#define kMargin 10

@interface PostsCommentCell ()

@property (strong, nonatomic) UIImageView *portraitView;

@property (strong, nonatomic) UILabel *nameLb;

@property (strong, nonatomic) UILabel *timeLb;

@property (strong, nonatomic) UILabel *contentLb;

@property (strong, nonatomic) UIButton *zanNumBtn;

@property (strong, nonatomic) UIButton *authorBtn;

@property (strong, nonatomic) SubCommentView *commentView;

@end

@implementation PostsCommentCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString *commentCellId = @"postsCommentCell";
    PostsCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellId];
    if (!cell) {
        cell = [[PostsCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setupUserInfoView];
    }
    
    return cell;
}


- (void)setCommentModel:(CommentModel *)commentModel
{
    _commentModel = commentModel;
    
    self.authorBtn.hidden = [commentModel.is_host integerValue] == 0;
    [self.portraitView sd_setImageWithURL:[NSURL URLWithString:commentModel.avatar] placeholderImage:[UIImage imageNamed:@"pc_user"]];
    
    self.nameLb.text = commentModel.author;
    self.timeLb.text = commentModel.dateline;

    if (commentModel.commen.newcommon) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 3;
        NSDictionary *attrDict1 = @{
                                    NSFontAttributeName:[UIFont systemFontOfSize:14],
                                    NSForegroundColorAttributeName:HMColor(53, 53, 53),
                                    NSParagraphStyleAttributeName:paragraph
                                    };
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:commentModel.commen.newcommon attributes:attrDict1];
        self.contentLb.attributedText = attrStr;
        
    }
    
    [self.zanNumBtn setTitle:[NSString stringWithFormat:@"%@赞",commentModel.support] forState:UIControlStateNormal];
    
    self.portraitView.frame = CGRectMake(kMargin, 10, 40, 40);
    self.portraitView.layer.cornerRadius= 20;
    self.portraitView.layer.masksToBounds = YES;
    [self.nameLb sizeToFit];
    self.nameLb.frame = CGRectMake(CGRectGetMaxX(self.portraitView.frame)+10, 12, CGRectGetWidth(self.nameLb.frame), CGRectGetHeight(self.nameLb.frame));
    
    [self.authorBtn sizeToFit];
    self.authorBtn.frame = CGRectMake(CGRectGetMaxX(self.nameLb.frame)+10, 12, CGRectGetWidth(self.authorBtn.frame), 18);
    
    [self.timeLb sizeToFit];
    self.timeLb.frame = CGRectMake(CGRectGetMinX(self.nameLb.frame), CGRectGetMaxY(self.nameLb.frame)+5, CGRectGetWidth(self.timeLb.frame), CGRectGetHeight(self.timeLb.frame));
    [self.zanNumBtn sizeToFit];
    CGFloat w = CGRectGetWidth(self.zanNumBtn.frame);
    self.zanNumBtn.frame = CGRectMake(MTScreenW - w - 10 - kMargin, 12, w + 10, 25);
    
    CGSize contentSize = [self.contentLb sizeThatFits:CGSizeMake(MTScreenW - self.nameLb.frame.origin.x - kMargin, MAXFLOAT)];
    if (self.contentLb.text) {
        self.contentLb.frame = CGRectMake(CGRectGetMaxX(self.portraitView.frame)+10, CGRectGetMaxY(self.portraitView.frame)+10, contentSize.width, contentSize.height);
    }else{
        self.contentLb.frame = CGRectMake(CGRectGetMaxX(self.portraitView.frame)+10, CGRectGetMaxY(self.portraitView.frame), contentSize.width, 0);
    }

    CGFloat commentWidth = MTScreenW - self.nameLb.frame.origin.x - kMargin;
    if (commentModel.commen.oldcommon) {
        self.commentView.itemData = commentModel.commen;
        CGSize sz = [self.commentView getSizeByWidth:commentWidth];
        self.commentView.frame = CGRectMake(CGRectGetMaxX(self.portraitView.frame)+10, CGRectGetMaxY(self.contentLb.frame)+10, sz.width, sz.height);
    }else{
        self.commentView.itemData = nil;
        self.commentView.frame = CGRectMake(CGRectGetMaxX(self.portraitView.frame)+10, CGRectGetMaxY(self.contentLb.frame), commentWidth, 0);
    }

    self.height = CGRectGetMaxY(self.commentView.frame) + 10;
}


/**
 *  创建用户信息部分的视图
 */
- (void)setupUserInfoView
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 1)];
    line.backgroundColor = HMColor(235, 235, 235);
    [self.contentView addSubview:line];
    
    //头像
    UIImageView *portraitView = [[UIImageView alloc] init];
    portraitView.backgroundColor = HMColor(230, 230, 230);
    self.portraitView = portraitView;
    [self.contentView addSubview:portraitView];
    
    //姓名
    UILabel *nameLb = [[UILabel alloc] init];
    nameLb.textColor = HMColor(53, 53, 53);
    nameLb.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:nameLb];
    self.nameLb = nameLb;
    
    //楼主
    UIButton *authorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    authorBtn.backgroundColor = [UIColor whiteColor];
    authorBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    authorBtn.layer.cornerRadius = 5;
    [authorBtn setTitle:@"楼主" forState:UIControlStateNormal];
    authorBtn.layer.borderWidth = 1.0f;
    authorBtn.layer.borderColor = [UIColor colorWithRGB:@"3FD0E4"].CGColor;
    authorBtn.backgroundColor = [UIColor colorWithRGB:@"3FD0E4"];

    [authorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.contentView addSubview:authorBtn];
    self.authorBtn = authorBtn;
    
    //时间
    UILabel *timeLb = [[UILabel alloc] init];
    timeLb.textColor = HMColor(153, 153, 153);
    timeLb.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:timeLb];
    self.timeLb = timeLb;
        
    //赞
    UIButton *zanNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    zanNumBtn.backgroundColor = [UIColor whiteColor];
    zanNumBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    zanNumBtn.layer.cornerRadius = 5;
    [zanNumBtn setTitle:@"赞" forState:UIControlStateNormal];
    zanNumBtn.layer.borderWidth = 1.0f;
    zanNumBtn.layer.borderColor = HMColor(247, 147, 30).CGColor;
    [zanNumBtn setTitleColor:HMColor(247, 147, 30) forState:UIControlStateNormal];
    [self.contentView addSubview:zanNumBtn];
    self.zanNumBtn = zanNumBtn;
    [self.zanNumBtn addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //评论内容
    UILabel *contentLb = [[UILabel alloc] init];
    contentLb.textColor = HMColor(53, 53, 53);
    contentLb.font = [UIFont systemFontOfSize:14];
    contentLb.numberOfLines = 0;
    [self.contentView addSubview:contentLb];
    self.contentLb = contentLb;
    
    SubCommentView *commentView = [SubCommentView createSubCommentView];
    [self.contentView addSubview:commentView];
    self.commentView = commentView;
    
}

- (void)tapBtn:(UIButton *)sender
{
    if (self.dianZanBlock) {
        self.dianZanBlock(self.indexpath);
    }
}


@end
