//
//  ServicePhoneCell.m
//  QinQingBao
//
//  Created by 董徐维 on 15/12/28.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "ServicePhoneCell.h"

@implementation ServicePhoneCell

+(ServicePhoneCell *) servicePhoneCell
{
    ServicePhoneCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"ServicePhoneCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    self.contentView.backgroundColor = HMGlobalBg;
    
    UIButton *btn = [self viewWithTag:100];
    [btn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)call
{
    NSURL *url  = [NSURL URLWithString:@"telprompt://0573-96345"];
    [[UIApplication sharedApplication] openURL:url];
}
@end
