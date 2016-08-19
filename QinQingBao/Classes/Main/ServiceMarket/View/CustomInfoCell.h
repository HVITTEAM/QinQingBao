//
//  CustomInfoCell.h
//  QinQingBao
//
//  Created by shi on 16/7/4.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MarketCustomInfo;

@interface CustomInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameTitleLb;

@property (weak, nonatomic) IBOutlet UILabel *nameLb;

@property (weak, nonatomic) IBOutlet UILabel *phoneNumLb;

@property (weak, nonatomic) IBOutlet UILabel *emailLb;

@property (weak, nonatomic) IBOutlet UILabel *addressLb;

@property (weak, nonatomic) IBOutlet UILabel *sexLb;

@property (weak, nonatomic) IBOutlet UILabel *birthdayLb;

@property (weak, nonatomic) IBOutlet UILabel *heightLb;

@property (weak, nonatomic) IBOutlet UILabel *weightLb;

@property (weak, nonatomic) IBOutlet UILabel *womanSpecial;

@property (weak, nonatomic) IBOutlet UILabel *caseHistoryLb;

@property (weak, nonatomic) IBOutlet UILabel *medicationLb;

@property (assign,nonatomic)BOOL isExtend;

+(instancetype)createCellWithTableView:(UITableView *)tableView;

-(void)setupCellHeight;

-(void)setdataWithCustomInfo:(MarketCustomInfo *)aCustomInfo;

@end
