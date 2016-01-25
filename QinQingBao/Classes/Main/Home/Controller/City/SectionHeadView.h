//
//  SectionHeadView.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/23.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionHeadView : UIView

- (id)initWithFrame:(CGRect)frame expanded:(BOOL)expanded;

-(void)setTitle:(NSString *)title indexSection:(NSInteger)indexSection;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger indexSection;


@property (nonatomic, copy) void (^expandedClick)(NSInteger indexSection);

@end
