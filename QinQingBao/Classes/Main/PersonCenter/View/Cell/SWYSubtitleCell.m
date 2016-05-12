//
//  SWYSubtitleCell.m
//  QinQingBao
//
//  Created by shi on 16/5/6.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "SWYSubtitleCell.h"

@implementation SWYSubtitleCell

+(instancetype)createSWYSubtitleCellWithTableView:(UITableView *)tableView
{
    static NSString *subtitleCellId = @"SWYSubtitleCell";
    SWYSubtitleCell *cell = [tableView dequeueReusableCellWithIdentifier:subtitleCellId];
    if (!cell) {
        cell = [[SWYSubtitleCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:subtitleCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect oldImageViewFrame = self.imageView.frame;
    CGFloat imageViewWidth = self.bounds.size.height - 30;
    self.imageView.frame = CGRectMake(oldImageViewFrame.origin.x, 15, imageViewWidth, imageViewWidth);
    
    if (self.showCorner) {
        self.imageView.layer.cornerRadius = imageViewWidth / 2;
        self.imageView.layer.masksToBounds = YES;
    }
    
    self.textLabel.frame = CGRectMake(CGRectGetMaxY(self.imageView.frame) + 15, self.textLabel.frame.origin.y - 4, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
    
    self.detailTextLabel.frame = CGRectMake(CGRectGetMaxY(self.imageView.frame) +15, self.detailTextLabel.frame.origin.y + 4, self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height);
}


@end
