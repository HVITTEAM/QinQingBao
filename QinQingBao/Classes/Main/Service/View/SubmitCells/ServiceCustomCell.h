//
//  ServiceCustomCell.h
//  QinQingBao
//
//  Created by 董徐维 on 15/9/14.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FamilyModel.h"

@interface ServiceCustomCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *phoneLab;
@property (strong, nonatomic) IBOutlet UILabel *sexLab;
@property (strong, nonatomic) IBOutlet UILabel *ageLab;
@property (strong, nonatomic) IBOutlet UITextView *addressLab;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *addressWidth;
- (IBAction)changeAddressHandler:(id)sender;

-(void)setdataWithItem:(FamilyModel *)item;

+ (ServiceCustomCell*) serviceCustomCell;

@property (nonatomic, copy) void (^changeAddressClick)(UIButton *btn);

@end
