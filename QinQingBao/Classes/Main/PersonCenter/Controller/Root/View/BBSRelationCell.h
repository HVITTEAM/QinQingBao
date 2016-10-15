//
//  BBSRelationCell.h
//  QinQingBao
//
//  Created by 董徐维 on 16/9/21.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBSRelationModel.h"

@interface BBSRelationCell : UITableViewCell
+(BBSRelationCell *)BBSRelationCell;
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *groupTitleLab;
@property (strong, nonatomic) IBOutlet UIButton *btn;
@property (strong, nonatomic) IBOutlet UIImageView *headImg;

- (IBAction)clickHandler:(id)sender;

@property (nonatomic, retain) BBSRelationModel *item;

@property (nonatomic, copy) NSString *owerId;


// type 1为加关注 0为删除关注
@property (nonatomic, copy) void (^relationChangeBlock)(NSString *targetUId ,NSInteger type);

@end
