//
//  HomeSettlementCell.m
//  QinQingBao
//
//  Created by shi on 16/5/5.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "HomeSettlementCell.h"
#import "OrderModel.h"
#import "TQStarRatingView.h"

@interface HomeSettlementCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@property (weak, nonatomic) IBOutlet UILabel *stateLb;

@property (weak, nonatomic) IBOutlet UILabel *priceLb;

@property (weak, nonatomic) IBOutlet UILabel *customerLb;

@property (weak, nonatomic) IBOutlet UILabel *technicianLb;

@property (weak, nonatomic) IBOutlet UILabel *timeLb;

@property (weak, nonatomic) IBOutlet UIView *evaluateView;

@property (weak, nonatomic) IBOutlet UIButton *settlemenBtn;

@property (weak, nonatomic) IBOutlet UILabel *scoreLb;

@property (weak, nonatomic) IBOutlet TQStarRatingView *startView;

@end

@implementation HomeSettlementCell

+(instancetype)createHomeSettlementCellWithTableView:(UITableView *)tableview
{
    static NSString *cellId = @"homeSettlementCell";
    HomeSettlementCell *cell = [tableview dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeSettlementCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.settlemenBtn.layer.borderColor = HMColor(200, 200, 200).CGColor;
    self.settlemenBtn.layer.cornerRadius = 8;
    self.settlemenBtn.layer.borderWidth = 1;
}

-(void)setItem:(OrderModel *)item
{
    //    _item = item;
    
    self.titleLb.text = item.icontent;
    self.stateLb.text = [self getStatusByStatus:[item.status intValue] payStatus:[item.pay_staus intValue]];
    self.customerLb.text = item.wname;
    self.technicianLb.text = item.orgname;
    
    NSString *priceStr = item.wprice;
    if ([priceStr isEqualToString:@"0"]|| [priceStr isEqualToString:@"0.00"]) {
        priceStr = @"面议";
    }
    self.priceLb.text = priceStr;
    
    NSDate *tempDate = [self.formatterIn dateFromString:item.wtime];
    NSString *serviceTimeStr = [self.formatterOut stringFromDate:tempDate];
    self.timeLb.text = serviceTimeStr;
    
    self.startView.userInteractionEnabled = NO;
    
    float score = [item.wgrade floatValue];
    [self.startView setScore:score/5 withAnimation:NO];
    self.scoreLb.text = [NSString stringWithFormat:@"%@分",item.wgrade];
    
}

-(NSString *)getStatusByStatus:(int)status payStatus:(int)payStaus
{
    self.settlemenBtn.hidden = NO;
    NSString *str;
    if (status >=0 && status <= 9)
    {
        str = @"待接单";
        self.stateLb.textColor = [UIColor orangeColor];
        //[self.deleteBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    }
    else if (status >= 10 && status <=19)
    {
        str = @"已接单";
        self.stateLb.textColor = [UIColor orangeColor];
        //[self.deleteBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        //self.deleteBtn.hidden = YES;
    }
    else if (status >= 20 && status <= 29)
    {
        str = @"";
        //self.deleteBtn.hidden = YES;
    }
    else if (status >= 30 && status <= 39)
    {
        str = @"服务完成";
        self.stateLb.textColor = [UIColor orangeColor];
        //[self.deleteBtn setTitle:@"去结算" forState:UIControlStateNormal];
    }
    else if (status >= 40 && status <= 49)
    {
        if (payStaus == 1) {
            str = @"已支付";
            self.settlemenBtn.hidden = YES;
        }else{
            str = @"服务完成";
            self.stateLb.textColor = [UIColor orangeColor];
            //[self.deleteBtn setTitle:@"去结算" forState:UIControlStateNormal];
        }
        
        self.stateLb.textColor = [UIColor orangeColor];
    }
    else if (status >= 50 && status <= 59)
    {
        str = @"已取消";
        self.stateLb.textColor = MTNavgationBackgroundColor;
        self.settlemenBtn.hidden = YES;
        
    }
    else if (status >= 60 && status <= 69)
    {
        str = @"已拒单";
        self.stateLb.textColor = MTNavgationBackgroundColor;
        self.settlemenBtn.hidden = YES;
    }
    else if ( status >=80 && status <= 99)
    {
        str = @"完成";
        self.stateLb.textColor = MTNavgationBackgroundColor;
        self.settlemenBtn.hidden = YES;
    }
    else if (status >=100 && status <= 109)
    {
        str = @"投诉中";
        self.stateLb.textColor = [UIColor orangeColor];
        //self.deleteBtn.hidden = YES;
    }
    else if ( status >=110 && status <= 119)
    {
        str = @"";
        self.stateLb.textColor = [UIColor orangeColor];
        //self.deleteBtn.hidden = YES;
    }
    
    return str;
}

-(void)setIsShowEvaluate:(BOOL)isShowEvaluate
{
    _isShowEvaluate = isShowEvaluate;
    
    self.evaluateView.hidden = !isShowEvaluate;
    self.settlemenBtn.hidden = isShowEvaluate;
}

- (IBAction)tapSettlementBtnAction:(UIButton *)sender
{
    if (self.cellButtonTapCallBack) {
        self.cellButtonTapCallBack(sender);
    }
}

@end
