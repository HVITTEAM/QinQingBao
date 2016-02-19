//
//  ScanCodesViewController.h
//  ScanCode
//
//  Created by shi on 16/2/17.
//  Copyright © 2016年 finefor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanCodesViewController : UIViewController

@property (nonatomic, copy) void (^getcodeClick)(NSString *codeStr);

@end
