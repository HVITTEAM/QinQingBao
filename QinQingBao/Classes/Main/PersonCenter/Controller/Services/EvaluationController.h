//
//  EvaluationController.h
//  QinQingBao
//
//  Created by 董徐维 on 15/9/10.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderItem.h"

@interface EvaluationController : UIViewController
@property (strong, nonatomic) IBOutlet UITextView *evaContentText;
@property (strong, nonatomic) IBOutlet UIButton *star1;
@property (strong, nonatomic) IBOutlet UIButton *star2;
@property (strong, nonatomic) IBOutlet UIButton *star3;
@property (strong, nonatomic) IBOutlet UIButton *star4;
@property (strong, nonatomic) IBOutlet UIButton *star5;
@property (strong, nonatomic) IBOutlet UILabel *starLabel;
- (IBAction)starClickeHandler:(id)sender;
- (IBAction)subBtnClickHandler:(id)sender;

@property (nonatomic, retain) OrderItem *orderItem;
@end
