//
//  PromptCell.m
//  QinQingBao
//
//  Created by shi on 16/6/21.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "MarketPromptCell.h"

@interface MarketPromptCell ()

@property (strong,nonatomic)UILabel *contentLb;

@end

@implementation MarketPromptCell

+(instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"promptCell";
    MarketPromptCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[MarketPromptCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *lb = [[UILabel alloc] init];
        lb.numberOfLines = 0;
        lb.font = [UIFont systemFontOfSize:14];
        lb.textColor = [UIColor darkGrayColor];
        [cell.contentView addSubview:lb];
        cell.contentLb = lb;
    
    }
    return cell;
}

-(void)setContentStr:(NSString *)contentStr
{
    if (!contentStr || contentStr.length == 0) {
        self.height = 0;
        self.contentLb.text = nil;
        self.contentLb.attributedText = nil;
    }
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 5.0f;
    NSDictionary *attr = @{
                            NSParagraphStyleAttributeName : paragraph,
                            NSFontAttributeName : [UIFont systemFontOfSize:14]
                          };
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:contentStr attributes:attr];
    self.contentLb.attributedText = str;
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(MTScreenW - 25, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    self.contentLb.frame = CGRectMake(15, 10, size.width, size.height);
    self.height = size.height + 20;
}


@end
