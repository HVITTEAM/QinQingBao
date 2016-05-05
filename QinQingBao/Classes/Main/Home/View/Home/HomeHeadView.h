//
//  HomeHeadView.h
//  QinQingBao
//
//  Created by 董徐维 on 16/5/5.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeHeadView : UIView
@property (strong, nonatomic) IBOutlet UIScrollView *imagePlayer;

@property (nonatomic, retain)  NSMutableArray *slideImages;

@property (nonatomic, retain)  NSMutableArray *advArr;

- (IBAction)masageHandler:(id)sender;
-(void)initImagePlayer;

@property (nonatomic, retain) UINavigationController *nav;
@end
