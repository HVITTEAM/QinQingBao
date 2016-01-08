//
//  MTShoppingCarCell.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/7.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTShoppIngCarModel.h"
#import "MTChangeCountView.h"

@protocol MTShoppingCarCellDelegate ;

@interface MTShoppingCarCell : UITableViewCell


@property(nonatomic,strong)MTShoppIngCarModel *model;
@property(nonatomic,assign)NSInteger choosedCount;
@property(nonatomic,assign)NSInteger row;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)BOOL isEdit;

@property(nonatomic,weak)id<MTShoppingCarCellDelegate> delegate;


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier tableView:(UITableView *)tableView;

+(CGFloat)getHeight;
@end


@protocol MTShoppingCarCellDelegate <NSObject>

-(void)singleClick:(MTShoppIngCarModel *)models row:(NSInteger )row;

@end