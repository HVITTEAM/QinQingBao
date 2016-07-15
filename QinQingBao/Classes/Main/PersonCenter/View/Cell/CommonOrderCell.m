//
//  CommonOrderCell.m
//  QinQinBao
//
//  Created by 董徐维 on 15/6/24.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "CommonOrderCell.h"

@interface CommonOrderCell ()

@property (strong, nonatomic) IBOutlet UILabel *titleLab;

@property (strong, nonatomic) IBOutlet UILabel *statusLab;

@property (weak, nonatomic) IBOutlet UILabel *servicePriceLab;

@property (weak, nonatomic) IBOutlet UILabel *serviceManLab;

@property (weak, nonatomic) IBOutlet UILabel *companyLab;

//时间UILabel
@property (weak, nonatomic) IBOutlet UILabel *serviceTimeLab;

//时间标题UILabel
@property (weak, nonatomic) IBOutlet UILabel *timeTitleLab;

//底部四个按钮
@property (weak, nonatomic) IBOutlet UIButton *oneBtn;

@property (weak, nonatomic) IBOutlet UIButton *twoBtn;

@property (weak, nonatomic) IBOutlet UIButton *threeBtn;

@property (weak, nonatomic) IBOutlet UIButton *fourBtn;

@end

@implementation CommonOrderCell


+(CommonOrderCell *) commonOrderCell
{
    CommonOrderCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"CommonOrderCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
        
    void (^setBtnBlock)(UIButton *btn) = ^(UIButton *btn){
        btn.layer.borderColor = HMColor(230, 230, 230).CGColor;
        btn.layer.cornerRadius = 6;
        btn.layer.borderWidth = 1;
    };
    
    setBtnBlock(self.oneBtn);
    setBtnBlock(self.twoBtn);
    setBtnBlock(self.threeBtn);
    setBtnBlock(self.fourBtn);
    
}

-(void)setItem:(OrderModel *)item
{
    _item = item;
    
    self.titleLab.text = item.icontent;
    self.serviceManLab.text = item.wname;
    self.companyLab.text = item.orgname;
    
    NSString *priceStr = [NSString stringWithFormat:@"￥%@",item.wprice];
    self.servicePriceLab.text = priceStr;
    
    NSDate *tempDate = [self.formatterIn dateFromString:item.wtime];
    NSString *serviceTimeStr = [self.formatterOut stringFromDate:tempDate];
    self.serviceTimeLab.text = serviceTimeStr;
    
    //tid 43为理疗服务  44为健康检测
    self.timeTitleLab.text = @"预约时间";
    if ([item.tid isEqualToString:@"44"]) {
        self.serviceTimeLab.text = item.wtime;
        self.timeTitleLab.text = @"下单时间";
    }
    
    //设置状态描述和可点击按钮
    [self setStatusAndButtons];
}

/**
 *  设置Cell的状态描述和相应的点击按钮
 */
-(void)setStatusAndButtons
{
    //默认按钮都隐藏
    self.oneBtn.hidden = YES;
    self.twoBtn.hidden = YES;
    self.threeBtn.hidden = YES;
    self.fourBtn.hidden = YES;
    
    //获取状态描述和按钮标题
    NSDictionary *dict = [self.item getOrderStatusAndButtonTitle];
    
    self.statusLab.text = dict[kStatusDesc];
    NSArray *btnTitles = dict[kButtonTitles];
    
    for (NSString *title in btnTitles) {
        [self showButtonWithTitle:title];
    }
}

- (IBAction)oneBtnClick:(id)sender
{
    self.deleteClick(sender);
}

- (IBAction)twoBtnClick:(id)sender
{
    self.deleteClick(sender);
}

- (IBAction)threeBtnClick:(id)sender
{
    self.deleteClick(sender);
}

- (IBAction)fourBtnClick:(id)sender
{
    self.deleteClick(sender);
}


/**
 *  显示一个操作按钮,从右侧开始显示
 *
 *  @param title 新显示按钮的标题
 */
-(void)showButtonWithTitle:(NSString *)title
{
    if (self.oneBtn.hidden) {
        [self.oneBtn setTitle:title forState:UIControlStateNormal];
        self.oneBtn.hidden = NO;
        return;
    }
    
    if (self.twoBtn.hidden) {
        [self.twoBtn setTitle:title forState:UIControlStateNormal];
        self.twoBtn.hidden = NO;
        return;
    }
    
    if (self.threeBtn.hidden) {
        [self.threeBtn setTitle:title forState:UIControlStateNormal];
        self.threeBtn.hidden = NO;
        return;
    }
    
    if (self.fourBtn.hidden) {
        [self.fourBtn setTitle:title forState:UIControlStateNormal];
        self.fourBtn.hidden = NO;
        return;
    }

}

@end
