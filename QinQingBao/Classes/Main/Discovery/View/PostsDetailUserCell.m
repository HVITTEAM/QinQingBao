//
//  PostsDetailUserCell.m
//  QinQingBao
//
//  Created by shi on 16/9/19.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "PostsDetailUserCell.h"
#import "DetailPostsModel.h"

@interface PostsDetailUserCell ()

@property (weak, nonatomic) IBOutlet UIImageView *portraitView;

@property (weak, nonatomic) IBOutlet UILabel *nameLb;

@property (weak, nonatomic) IBOutlet UILabel *tagLb;

@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;

@end

@implementation PostsDetailUserCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString *detailUserId = @"postsDetailUserCell";
    PostsDetailUserCell *cell = [tableView dequeueReusableCellWithIdentifier:detailUserId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PostsDetailUserCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.attentionBtn.layer.cornerRadius = 5;
    self.attentionBtn.layer.borderWidth = 1.0f;
    
    self.tagLb.layer.cornerRadius = 4;
    self.tagLb.layer.masksToBounds = YES;
    
    self.nameLb.text = nil;
    self.tagLb.text = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.tagLb sizeToFit];
    self.tagLb.frame = CGRectMake(self.tagLb.frame.origin.x, self.tagLb.frame.origin.y - 1, self.tagLb.frame.size.width + 4, self.tagLb.frame.size.height + 2);
}

- (void)setPostsDetailData:(DetailPostsModel *)postsDetailData
{
    _postsDetailData = postsDetailData;
    
    [self.portraitView sd_setImageWithURL:[NSURL URLWithString:self.postsDetailData.avatar] placeholderImage:[UIImage imageNamed:@"pc_user"]];
    
    self.nameLb.text = postsDetailData.author;
    self.tagLb.text = @"无敌";
    if ([postsDetailData.is_home_friend isEqualToString:@"0"]) {
        [self.attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
        [self.attentionBtn setTitleColor:HMColor(251,176,59) forState:UIControlStateNormal];
        self.attentionBtn.layer.borderColor = HMColor(251,176,59).CGColor;
    }else{
        [self.attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
        [self.attentionBtn setTitleColor:HMColor(153, 153, 153) forState:UIControlStateNormal];
        self.attentionBtn.layer.borderColor = HMColor(153, 153, 153).CGColor;
    }
}

@end
