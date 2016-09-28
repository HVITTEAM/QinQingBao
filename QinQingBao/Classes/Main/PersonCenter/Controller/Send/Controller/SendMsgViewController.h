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

@property (strong, nonatomic) BBSPersonalModel *otherInfo;

@property (strong, nonatomic) NSString *authorid;

@end
