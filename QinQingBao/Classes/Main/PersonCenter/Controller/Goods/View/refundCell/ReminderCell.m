//
//  ReminderCell.m
//  QinQingBao
//
//  Created by shi on 16/2/25.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ReminderCell.h"

@interface ReminderCell ()

@property (weak, nonatomic) IBOutlet UILabel *reminderContent;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@end

@implementation ReminderCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setContentStr:(NSString *)contentStr
{
    _contentStr = contentStr;
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 7;
    
    NSDictionary *attrDict = @{
                               NSParagraphStyleAttributeName:paragraph,
                               NSForegroundColorAttributeName:HMColor(115, 72, 38),
                               NSFontAttributeName:[UIFont systemFontOfSize:13]
                               };
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:contentStr attributes:attrDict];
    self.reminderContent.attributedText = attrString;
    
    CGSize size = [attrString boundingRectWithSize:CGSizeMake(MTScreenW - 35, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.height = size.height + 55;
}

@end
