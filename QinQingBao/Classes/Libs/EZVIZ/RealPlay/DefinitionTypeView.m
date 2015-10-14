//
//  DefinitionTypeView.m
//  QinQingBao
//
//  Created by 董徐维 on 15/10/13.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "DefinitionTypeView.h"

@interface DefinitionTypeView ()

@end

@implementation DefinitionTypeView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)btnClickHandler:(id)sender {
    UIButton *btn = (UIButton*)sender;
    [self.delegate definitiontypeSelectedHandler:btn.tag];
}
@end
