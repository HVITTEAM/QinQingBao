//
//  NotificationCell.m
//  QinQingBao
//
//  Created by shi on 16/6/1.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "NotificationCell.h"
#import "PushMsgModel.h"

@interface NotificationCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@property (weak, nonatomic) IBOutlet UILabel *contentLb;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation NotificationCell

+(instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"notificationCell";
    NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NotificationCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentLb.text = nil;
    self.titleLb.text = nil;
    
    self.containerView.layer.cornerRadius = 8.0f;
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.borderColor = HMColor(230, 230, 230).CGColor;
    self.containerView.layer.borderWidth = 1.0f;
}

-(void)setDataWithModel:(PushMsgModel *)model
{
    self.titleLb.text = @"温馨提示";

    if (model.msg_title) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 4;
        NSDictionary *attr = @{
                               NSFontAttributeName:[UIFont systemFontOfSize:14],
                               NSForegroundColorAttributeName:HMColor(102, 102, 102),
                               NSParagraphStyleAttributeName:paragraphStyle
                               };
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:model.msg_title attributes:attr];
        self.contentLb.attributedText = attrStr;
    }
    
    //计算高度
    self.contentLb.preferredMaxLayoutWidth = MTScreenW - 52;
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
    CGFloat cellHeight = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    self.height = cellHeight;
}

@end
