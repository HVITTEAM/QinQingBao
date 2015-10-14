//
//  DefinitionTypeView.h
//  QinQingBao
//
//  Created by 董徐维 on 15/10/13.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol definitiontypeSelectedDelegate <NSObject>

- (void)definitiontypeSelectedHandler:(NSInteger)type;
@end


@interface DefinitionTypeView : UIViewController
- (IBAction)btnClickHandler:(id)sender;

@property (nonatomic, assign) id<definitiontypeSelectedDelegate> delegate;

@end
