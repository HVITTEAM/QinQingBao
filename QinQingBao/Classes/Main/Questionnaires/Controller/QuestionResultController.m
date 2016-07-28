//
//  QuestionResultController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/7/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "QuestionResultController.h"
#import "RadianView.h"

@interface QuestionResultController ()
@property (strong, nonatomic) IBOutlet RadianView *circleView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *vheight;
@property (strong, nonatomic) IBOutlet UIScrollView *bgview;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *lab1;
@property (strong, nonatomic) IBOutlet UILabel *lab2;
@property (strong, nonatomic) IBOutlet UILabel *lab3;
@property (strong, nonatomic) IBOutlet UIButton *btn1;
@property (strong, nonatomic) IBOutlet UIButton *btn2;
- (IBAction)btn1Handler:(id)sender;
- (IBAction)btn2Handler:(id)sender;

@end

@implementation QuestionResultController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.circleView.upperCircleColor = [UIColor orangeColor];
    self.circleView.lowerCircleColor = [UIColor lightGrayColor];
    self.circleView.lineWidth = 12;
    self.circleView.lineThick = 1.5;
    self.circleView.lineSpace = 5;
    self.circleView.percentValue = 19;
    
    self.btn1.layer.cornerRadius = 8;
    self.btn2.layer.cornerRadius = 8;
    
    self.contentView.layer.cornerRadius = 10;
    
    self.lab1.text = @"中新网北京7月14日电 （记者 李金磊）今年养老金上调何时到位，是当前退休人员普遍关心的问题。中新网（微信公众号：cns2012）记者梳理发现，目前上海已率先提高养老金并进行了发放，北京、天津、浙江等地则透露了发放的时间表，预计9月底发放到位。";
    self.lab2.text = @"中新网北京7月14日电 （记者 李金磊）今年养老金上调何时到位，是当前退休人员普遍关心的问题。中新网（微信公众号：cns2012）记者梳理发现，目前上海已率先提高养老金并进行了发放，北京、天津、浙江等地则透露了发放的时间表，预计9月底发放到位。";
    self.lab3.text = @"中新网北京7月14日电 （记者 李金磊）今年养老金上调何时到位，是当前退休人员普遍关心的问题。中新网（微信公众号：cns2012）记者梳理发现，目前上海已率先提高养老金并进行了发放，北京、天津、浙江等地则透露了发放的时间表，预计9月底发放到位。";
    
    CGRect rc = [self.contentView convertRect:self.lab3.frame toView:self.bgview];
    self.vheight.constant  = rc.origin.y;
    
    [self getResult];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    [self.bgview setContentSize:CGSizeMake(MTScreenW - 20,CGRectGetMaxY(self.contentView.frame))];
}

- (IBAction)btn1Handler:(id)sender {
}

- (IBAction)btn2Handler:(id)sender {
}

-(void)getResult
{
    NSMutableDictionary *resultdict = [[NSMutableDictionary alloc] init];
    [resultdict setObject:self.exam_id forKey:@"exam_id"];
    [resultdict setObject:self.answerProvider forKey:@"qitem"];
    NSLog(@"%@",resultdict);
    NSString *dictstr = [self dictionaryToJson:[resultdict copy]];
    NSString * encodingString = [dictstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

}

//词典转换为字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
@end
