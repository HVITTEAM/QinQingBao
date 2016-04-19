//
//  ParagraphTextCell.h
//  QinQingBao
//
//  Created by 董徐维 on 16/4/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParagraphTextCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextView *textLab;
+ (ParagraphTextCell*) paragraphTextCell;


@property (strong, nonatomic) IBOutlet UILabel *titleLab;
-(void)setTitle:(NSString *)title withValue:(NSString *)value;
@property (nonatomic, copy) NSString *textValue;
@end
