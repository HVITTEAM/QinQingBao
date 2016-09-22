//
//  MyRelationViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 16/9/20.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyRelationViewController : UITableViewController


// 1 代表我的关注 2 代表我的粉丝
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *uid;

@end
