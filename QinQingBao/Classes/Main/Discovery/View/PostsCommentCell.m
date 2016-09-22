//
//  PostsCommentCell.m
//  QinQingBao
//
//  Created by shi on 16/9/20.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "PostsCommentCell.h"

@interface PostsCommentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *portraitView;

@property (weak, nonatomic) IBOutlet UILabel *nameLb;

@property (weak, nonatomic) IBOutlet UILabel *timeLb;

@property (weak, nonatomic) IBOutlet UILabel *contentLb;

@property (weak, nonatomic) IBOutlet UIButton *zanNumBtn;

@end

@implementation PostsCommentCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString *commentCellId = @"postsCommentCell";
    PostsCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PostsCommentCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.zanNumBtn.layer.borderColor = HMColor(251,176, 59).CGColor;
    self.zanNumBtn.layer.borderWidth = 1.0f;
    self.zanNumBtn.layer.cornerRadius = 5.0f;
    
}

- (void)layoutCell
{
    self.contentLb.preferredMaxLayoutWidth = MTScreenW - 38;
    
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
    CGFloat h = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    self.height = h;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.zanNumBtn sizeToFit];
    
    self.zanNumBtn.frame = CGRectMake(self.zanNumBtn.frame.origin.x - 20, self.zanNumBtn.frame.origin.y, self.zanNumBtn.frame.size.width + 20, self.zanNumBtn.frame.size.height);
    
}

@end
