//
//  PrivateLetterCell.m
//  QinQingBao
//
//  Created by shi on 16/9/28.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "PrivateLetterCell.h"

@interface PrivateLetterCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@property (weak, nonatomic) IBOutlet UILabel *contentLb;

@property (weak, nonatomic) IBOutlet UILabel *timeLb;

@property (weak, nonatomic) IBOutlet UIImageView *noReadIcon;

@end

@implementation PrivateLetterCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString *privateLetterId = @"privateLetterCell";
    PrivateLetterCell *cell = [tableView dequeueReusableCellWithIdentifier:privateLetterId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PrivateLetterCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconView.layer.cornerRadius = 40 / 2;
    self.iconView.layer.masksToBounds = YES;
}

- (void)setItem:(AllpriletterModel *)item
{
    _item = item;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:item.avatar] placeholderImage:[UIImage imageNamed:@"pc_user"]];
    self.titleLb.text = item.author;
    self.contentLb.text = item.message;
    
    self.timeLb.text = [item.lastdateline substringWithRange:NSMakeRange(0, 16)];
    
    if (item.no_read.length > 0 && ![item.no_read isEqualToString:@"0"]) {
        self.noReadIcon.hidden = NO;
    }else{
        self.noReadIcon.hidden = YES;
    }
    
}

@end
