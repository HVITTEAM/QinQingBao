//
//  BusinessInfoCell.h
//  QinQingBao
//
//  Created by 董徐维 on 15/9/6.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessInfoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *callBtn;
- (IBAction)callClickHandler:(id)sender;

@end
