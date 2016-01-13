//
//  GoodsSelectedViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/10.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "GoodsSelectedViewController.h"
#import "MTChangeCountView.h"

static CGFloat BUTTONHEIGHT = 50;
static CGFloat VIEWHEIGHT;
static CGFloat PADDINGBOTTON = 120;


@interface GoodsSelectedViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)MTChangeCountView *changeView;
@property(nonatomic,assign)NSInteger choosedCount;

@end

@implementation GoodsSelectedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.choosedCount = 1;
    
    VIEWHEIGHT = MTScreenH *0.4;
    
    [self initView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    
    [self.view addGestureRecognizer:tapGesture];
}

- (void)tapGesture:(UITapGestureRecognizer *)gesture
{
    //    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initView
{
    //    UIView *backGroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    //    backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    //    backGroundView.opaque = NO;
    //    [UIView animateWithDuration:0.2 animations:^{
    //        backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    //    }];
    
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, MTScreenH - VIEWHEIGHT, MTScreenW, VIEWHEIGHT)];
    bgview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgview];
    
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, VIEWHEIGHT - BUTTONHEIGHT, MTScreenW, BUTTONHEIGHT)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    sureBtn.backgroundColor = [UIColor colorWithRGB:@"dd2726"];
    [sureBtn setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bgview addSubview:sureBtn];
    
    UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMinY(sureBtn.frame) - PADDINGBOTTON, 100, 30)];
    numLab.text = @"购买数量:";
    numLab.textColor = [UIColor colorWithRGB:@"333333"];
    numLab.font = [UIFont systemFontOfSize:16];
    [bgview addSubview:numLab];
    
    _changeView = [[MTChangeCountView alloc] initWithFrame:CGRectMake(MTScreenW - 120, CGRectGetMinY(sureBtn.frame) - PADDINGBOTTON, 160, 35) chooseCount:1 totalCount: 20];
    
    [_changeView.subButton addTarget:self action:@selector(subButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _changeView.numberFD.delegate = self;
    
    [_changeView.addButton addTarget:self action:@selector(addButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [bgview addSubview:_changeView];
    
    UILabel *typeLab = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMinY(numLab.frame) - 80, 100, 30)];
    typeLab.text = @"规格:";
    typeLab.textColor = [UIColor colorWithRGB:@"333333"];
    typeLab.font = [UIFont systemFontOfSize:16];
    [bgview addSubview:typeLab];
    
    UIButton *typevalue = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMinY(numLab.frame) - 50, 40, 23)];
    [typevalue setTitle:@"标配" forState:UIControlStateNormal];
    [typevalue.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [typevalue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [typevalue setBackgroundColor:[UIColor redColor]];
    //    [typevalue setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    //    [typevalue setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateSelected];
    typevalue.layer.cornerRadius = 10;
    [bgview addSubview:typevalue];
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(typevalue.frame) + 10, MTScreenW, 0.5)];
    line.backgroundColor=[UIColor colorWithRGB:@"e2e2e2"];
    [bgview addSubview:line];
    
    UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(numLab.frame) + 10, MTScreenW, 0.5)];
    line1.backgroundColor=[UIColor colorWithRGB:@"e2e2e2"];
    [bgview addSubview:line1];
    
    //    [UIView beginAnimations:nil context:nil];
    //    [UIView animateWithDuration:0.3 animations:^{
    //        bgview.y = MTScreenH *0.4;
    //    } completion:^(BOOL finished) {
    //
    //    }];
    
    UIImage *btimg = [UIImage imageNamed:@"btn_dismissItem_highlighted"];
    UIImage *selectImg = [UIImage imageNamed:@"btn_dismissItem"];
    UIButton *dismissBtn = [[UIButton alloc]initWithFrame:CGRectMake(MTScreenW - 30, 5, 15, 15)];
    [dismissBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [dismissBtn setImage:btimg forState:UIControlStateNormal];
    [dismissBtn setImage:selectImg forState:UIControlStateSelected];
    [bgview addSubview:dismissBtn];
}

//减
- (void)subButtonPressed:(id)sender
{
    
    if (self.choosedCount >1) {
        [self deleteCar];
    }
    
    self.choosedCount --;
    
    if (self.choosedCount==0) {
        self.choosedCount= 1;
        _changeView.subButton.enabled=NO;
    }
    else
    {
        _changeView.addButton.enabled=YES;
        
    }
    _changeView.numberFD.text=[NSString stringWithFormat:@"%zi",self.choosedCount];
}

//加
- (void)addButtonPressed:(id)sender
{
    if (self.choosedCount<99) {
        [self addCar];
    }
    
    self.choosedCount ++;
    if (self.choosedCount>0) {
        _changeView.subButton.enabled=YES;
    }
    
    //    if ([_model.item_info.stock_quantity integerValue]<self.choosedCount) {
    //        self.choosedCount  = [_model.item_info.stock_quantity  intValue];
    //        _changeView.addButton.enabled = NO;
    //    }
    //    else
    //    {
    //        _changeView.subButton.enabled = YES;
    //    }
    
    if(self.choosedCount>=99)
    {
        self.choosedCount  = 99;
        _changeView.addButton.enabled = NO;
    }
    
    _changeView.numberFD.text=[NSString stringWithFormat:@"%zi",self.choosedCount];
    
    //    _model.count = _changeView.numberFD.text;
    //
    //    _model.isSelect=_selectBt.selected;
}

-(void)addCar
{
    
}

-(void)deleteCar
{
    
    
}

//确定
-(void)sureClick:(UIButton *)sender
{
    if (self.type == OrderTypeAdd2cart)
    {
        [CommonRemoteHelper RemoteWithUrl:URL_Cart_add parameters: @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                     @"goods_id" : self.goodsID,
                                                                     @"client" : @"ios",
                                                                     @"quantity" : _changeView.numberFD.text}
                                     type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                         
                                         id codeNum = [dict objectForKey:@"code"];
                                         if([codeNum isKindOfClass:[NSString class]])
                                         {
                                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                             [alertView show];
                                         }
                                         else
                                         {
                                             self.submitClick(YES);
                                             [self back];
                                         }
                                         
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"出错了....");
                                         [NoticeHelper AlertShow:@"添加失败!" view:self.view];
                                     }];
        
    }
    else
    {
        self.orderClick(_changeView.numberFD.text);
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)back
{
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end