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
    
    CGFloat textX = 15.0f;
    if (self.imageView.image) {
        
        CGRect oldImageViewFrame = self.imageView.frame;
        CGFloat imageViewWidth = self.bounds.size.height - 30;
        self.imageView.frame = CGRectMake(oldImageViewFrame.origin.x, 15, imageViewWidth, imageViewWidth);
        
        if (self.showCorner) {
            self.imageView.layer.cornerRadius = imageViewWidth / 2;
            self.imageView.layer.masksToBounds = YES;
        }
        
        textX = CGRectGetMaxX(self.imageView.frame) + 15;
    }
    
    if (self.textLabel.text) {
        self.textLabel.frame = CGRectMake(textX, self.textLabel.frame.origin.y - 4, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
    }
    
    if (self.detailTextLabel.text) {
        self.detailTextLabel.frame = CGRectMake(textX, self.detailTextLabel.frame.origin.y + 4, self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height);
    }
}

@end
