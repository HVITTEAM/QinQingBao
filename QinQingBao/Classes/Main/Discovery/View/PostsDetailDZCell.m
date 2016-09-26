//
//  PostsDetailDZCell.m
//  QinQingBao
//
//  Created by shi on 16/9/20.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "PostsDetailDZCell.h"
#import "DetailPostsModel.h"

@interface PostsDetailDZCell ()

@property (weak, nonatomic) IBOutlet UILabel *zanLb;

@property (weak, nonatomic) IBOutlet UILabel *zanNumLb;

@property (weak, nonatomic) IBOutlet UIView *zanBackgroundView;

@property (assign, nonatomic) BOOL isDianZan;

@end

@implementation PostsDetailDZCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString *dzCellId = @"postsDetailDZCell";
    PostsDetailDZCell *cell = [tableView dequeueReusableCellWithIdentifier:dzCellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PostsDetailDZCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.zanBackgroundView.layer.cornerRadius = self.zanBackgroundView.width / 2;
    
}

- (void)setPostsDetailData:(DetailPostsModel *)postsDetailData
{
    _postsDetailData = postsDetailData;
    
    self.zanNumLb.text = postsDetailData.count_recommend;
    if ([postsDetailData.is_recommend isEqualToString:@"0"]) {
        self.zanLb.text = @"点赞";
        self.zanBackgroundView.backgroundColor = HMColor(251, 176, 51);
    }else{
        self.zanLb.text = @"已点赞";
        self.zanBackgroundView.backgroundColor = [HMColor(251, 176, 51) colorWithAlphaComponent:0.6];
    }
}

- (IBAction)dianZanAction:(id)sender {
    
    if (self.dianZanBlock) {
        self.dianZanBlock();
    }
}

@end
