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
@property (weak, nonatomic) IBOutlet UIImageView *vIconView;

@end

@implementation PostsDetailUserCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString *detailUserId = @"postsDetailUserCell";
    PostsDetailUserCell *cell = [tableView dequeueReusableCellWithIdentifier:detailUserId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PostsDetailUserCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage)];
    [self.portraitView addGestureRecognizer:singleTap];
    
    
    self.attentionBtn.layer.cornerRadius = 3;
    self.attentionBtn.layer.borderWidth = 1.0f;
    self.attentionBtn.layer.borderColor = HMColor(251, 176, 59).CGColor;
    
    self.tagLb.layer.cornerRadius = 2;
    self.tagLb.layer.masksToBounds = YES;
    
    self.nameLb.text = nil;
    self.tagLb.text = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.portraitView.layer.cornerRadius = self.portraitView.width / 2;
    self.portraitView.layer.masksToBounds = YES;
    self.portraitView.userInteractionEnabled=YES;
}

- (void)setPostsDetailData:(DetailPostsModel *)postsDetailData
{
    _postsDetailData = postsDetailData;
    
    if (!postsDetailData) {
        return;
    }
    
    self.vIconView.hidden = postsDetailData.grouptitle.length>0 ? NO : YES;
    
    // 不能关注自己
    if ([SharedAppUtil defaultCommonUtil].bbsVO && [[SharedAppUtil defaultCommonUtil].bbsVO.BBS_Member_id isEqualToString:self.postsDetailData.authorid])
        self.attentionBtn.hidden = YES;
    
    [self.portraitView sd_setImageWithURL:[NSURL URLWithString:self.postsDetailData.avatar] placeholderImage:[UIImage imageNamed:@"pc_user"]];
    
    self.nameLb.text = postsDetailData.author;
    
    if (postsDetailData.grouptitle.length > 0) {
        self.tagLb.hidden = NO;
        self.tagLb.text = [NSString stringWithFormat:@"%@ ",postsDetailData.grouptitle];
    }else{
        self.tagLb.hidden = YES;
    }
    
    if ([postsDetailData.is_home_friend isEqualToString:@"0"]) {
        [self.attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
    }else{
        [self.attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
    }
    
}

- (IBAction)tapAttentionBtn:(UIButton *)sender
{
    if (self.attentionBlock) {
        self.attentionBlock();
    }
}

- (void)onClickImage
{
    if (self.portraitClickBlock) {
        self.portraitClickBlock(self.postsDetailData.authorid);
    }
}

@end
