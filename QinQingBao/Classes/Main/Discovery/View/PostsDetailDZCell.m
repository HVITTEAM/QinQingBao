//
//  PostsDetailDZCell.m
//  QinQingBao
//
//  Created by shi on 16/9/20.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "PostsDetailDZCell.h"

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

- (IBAction)dianZanAction:(id)sender {
    
    self.isDianZan = !self.isDianZan;
    if (self.isDianZan) {
        self.zanLb.text = @"已点赞";
        self.zanBackgroundView.backgroundColor = [HMColor(251, 176, 51) colorWithAlphaComponent:0.6];
    }else{
        self.zanLb.text = @"点赞";
        self.zanBackgroundView.backgroundColor = HMColor(251, 176, 51);
    }
}

@end
