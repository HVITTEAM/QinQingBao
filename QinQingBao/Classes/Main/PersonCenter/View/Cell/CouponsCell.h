//
//  CouponsCell.h
//  QinQingBao
//
//  Created by 董徐维 on 15/8/26.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponsModel.h"

@interface CouponsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *priceLab;
@property (strong, nonatomic) IBOutlet UILabel *endtimeLab;
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UILabel *limitLab;


@property (strong, nonatomic) IBOutlet UIView *bgView;
- (IBAction)clickHandler:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *selectBtn;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *left;
-(void)setBtnSelected:(BOOL)selected;

@property (nonatomic, retain) CouponsModel *couponsModel;
+ (CouponsCell*) couponsCell;
@end
