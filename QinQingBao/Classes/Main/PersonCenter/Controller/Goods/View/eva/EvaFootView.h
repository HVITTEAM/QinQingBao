//
//  EvaFootView.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/23.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvaFootView : UITableViewCell
{
    float maxStar1;
    float maxStar2;
    float maxStar3;
}

+(EvaFootView *) evaFootView;
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIView *view3;

- (IBAction)star1ClickeHandler:(id)sender;

- (IBAction)star2ClickeHandler:(id)sender;

- (IBAction)star3ClickeHandler:(id)sender;

-(NSString *)getEva;
@end
