//
//  NewsCell.m
//  QinQingBao
//
//  Created by shi on 16/5/31.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "NewsCell.h"
#import "EventMsgModel.h"

@interface NewsCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@property (weak, nonatomic) IBOutlet UILabel *timeLb;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *descLb;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation NewsCell

+(instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"newsCell";
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.titleLb.text =nil;
    self.timeLb.text = nil;
    self.descLb.text = nil;
    
    self.containerView.layer.cornerRadius = 8.0f;
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.borderColor = HMColor(230, 230, 230).CGColor;
    self.containerView.layer.borderWidth = 1.0f;
}

-(void)setDataWithMode:(EventMsgModel *)model
{
    self.titleLb.text = model.msg_title;
    self.timeLb.text = [model.s_create_time substringWithRange:NSMakeRange(5, 5)];
    self.descLb.text = model.abstract;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_ImgArticle,model.detail_url];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"advplaceholderImage"]];
    
    //计算高度
    self.width = MTScreenW;
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
    CGFloat h = CGRectGetMaxY(self.containerView.frame) + 10;
    self.height = h;
}

@end
