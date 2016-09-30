//
//  SendMsgViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 16/9/11.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BBSPersonalModel;

@interface SendMsgViewController : UIViewController

/** 对方名字 */
@property (strong, nonatomic) NSString *otherName;

/** 对方id */
@property (strong, nonatomic) NSString *authorid;

@end
