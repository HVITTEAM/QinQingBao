//
//  LogisticNotificationCell.m
//  QinQingBao
//
//  Created by shi on 16/6/1.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "LogisticNotificationCell.h"
#import "PushMsgModel.h"

@interface LogisticNotificationCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@property (weak, nonatomic) IBOutlet UILabel *timeLb;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *descLb;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation LogisticNotificationCell

+(instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"logisticNotificationCell";
    LogisticNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LogisticNotificationCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.titleLb.text = nil;
    self.timeLb.text = nil;
    self.descLb.text = nil;
    
    self.containerView.layer.cornerRadius = 8.0f;
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.borderColor = HMColor(230, 230, 230).CGColor;
    self.containerView.layer.borderWidth = 1.0f;
}

-(void)setDataWithModel:(PushMsgModel *)model
{
    self.titleLb.text = model.msg_title;
    self.timeLb.text = [model.create_time substringWithRange:NSMakeRange(5, 5)];
    self.descLb.text = model.msg_content;
    if (model.goods_fimg) {
        NSURL *url = [[NSURL alloc] initWithString:model.goods_fimg];
        [self.imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    }else self.imgView = nil;
}

@end
