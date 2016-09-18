//
//  OthermsgCell.h
//  QinQingBao
//
//  Created by 董徐维 on 16/9/11.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OthermsgCell : UITableViewCell
+ (OthermsgCell*) othermsgCell;

-(void)initWithContent:(NSString *)content icon:(NSString *)icon;
@end
