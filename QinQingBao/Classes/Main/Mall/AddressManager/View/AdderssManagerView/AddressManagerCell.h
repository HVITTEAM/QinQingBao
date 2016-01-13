//
//  AddressManagerCell.h
//  QinQingBao
//
//  Created by Dual on 16/1/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MallAddressModel.h"

@interface AddressManagerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name; //姓名
@property (weak, nonatomic) IBOutlet UILabel *phone; //电话
@property (weak, nonatomic) IBOutlet UILabel *address; //地址
@property (weak, nonatomic) IBOutlet UILabel *chooseLable; //默认Lable
@property (weak, nonatomic) IBOutlet UIButton *rightChooseBtn; //右边选择按钮
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn; //选择按钮
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn; //删除
@property (weak, nonatomic) IBOutlet UIButton *editBtn; //编辑


@property (strong, nonatomic) UIButton *leftBtn;

@property (nonatomic ,copy) void (^clickDelete)(MallAddressModel *item);
@property (nonatomic ,copy) void (^clickEdit)(MallAddressModel *item);
@property (nonatomic ,copy) void (^clickSetDefault)(MallAddressModel *item);

- (IBAction)setDefaultaddresHandler:(id)sender;

+ (AddressManagerCell *)addressManagerCell;

@property (nonatomic, retain) MallAddressModel *item;

@end
