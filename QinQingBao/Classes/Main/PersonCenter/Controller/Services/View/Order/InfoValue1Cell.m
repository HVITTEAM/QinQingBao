//
//  InfoValue1Cell.m
//  QinQingBao
//
//  Created by shi on 16/8/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "InfoValue1Cell.h"

@interface InfoValue1Cell ()

@property(strong,nonatomic)UILabel *titleLb;

@property(strong,nonatomic)UILabel *contentLb;

@end

@implementation InfoValue1Cell

+(instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString *cellid = @"infoValue1Cell";
    InfoValue1Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[InfoValue1Cell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *tempLb = [[UILabel alloc] init];
        tempLb.textColor = HMColor(51, 51, 51);
        tempLb.font = [UIFont systemFontOfSize:15];
        [cell addSubview:tempLb];
        cell.titleLb = tempLb;
        
        tempLb = [[UILabel alloc] init];
        tempLb.textColor = HMColor(51, 51, 51);
        tempLb.font = [UIFont systemFontOfSize:15];
        tempLb.numberOfLines = 0;
        [cell addSubview:tempLb];
        cell.contentLb = tempLb;
        
    }
    return cell;
}

-(void)setTitle:(NSString *)title value:(NSString *)value
{
    self.titleLb.text = title;
    [self.titleLb sizeToFit];
    self.titleLb.frame = CGRectMake(20, 15, self.titleLb.width, self.titleLb.height);
    
    CGFloat h = 0;
    
    if (value) {
        NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
        para.lineSpacing = 4;
        
        NSDictionary *dict = @{
                               NSForegroundColorAttributeName:HMColor(51, 51, 51),
                               NSFontAttributeName : [UIFont systemFontOfSize:15],
                               NSParagraphStyleAttributeName:para
                               };
        
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:value attributes:dict];
        CGSize size = [attrStr boundingRectWithSize:CGSizeMake(MTScreenW - 130, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        self.contentLb.bounds = CGRectMake(0, 0, size.width, size.height);
        self.contentLb.attributedText = attrStr;
        [self.contentLb sizeToFit];
        self.contentLb.frame = CGRectMake(MTScreenW - self.contentLb.width - 20, 15, self.contentLb.width, self.contentLb.height);
        h = size.height;
    }

    self.height = h + 15 + 10 > 45 ? h + 15 + 10 : 45;
}

@end
