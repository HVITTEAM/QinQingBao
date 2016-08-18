//
//  InfoValue1Cell.h
//  QinQingBao
//
//  Created by shi on 16/8/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoValue1Cell : UITableViewCell

+(instancetype)createCellWithTableView:(UITableView *)tableView;

-(void)setTitle:(NSString *)title value:(NSString *)value;

@end
