//
//  GoodsSelectedViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/10.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "GoodsSelectedViewController.h"
#import "MTChangeCountView.h"
#import "GoodsSpecCollectionView.h"
#import "GoodsTypeModel.h"

static CGFloat BUTTONHEIGHT = 50;

@interface GoodsSelectedViewController ()<UITextFieldDelegate>
{
    NSMutableArray *dataProvider;
    UIImageView *imgview;
    UILabel *numLab;
    UIImageView *line;
    //参数是否全部选择了
    BOOL allSelected;
    UILabel *desLab;
    //选择的参数ID集合
    NSMutableArray *selectedIDarr;
    
    UILabel *priceLab;
    UILabel *kucunLab;
    
}
@property(nonatomic,strong)MTChangeCountView *changeView;
@property(nonatomic,assign)NSInteger choosedCount;

@end

@implementation GoodsSelectedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.view.height = MTScreenH *0.6;
    
    self.choosedCount = 1;
    
    [self initData];
}

//解析各项数据源
-(void)initData
{
    dataProvider = [[NSMutableArray alloc] init];
    
    NSArray *keys_specname = [self.specnameDict allKeys];
    for (int i = 0; i < keys_specname.count; i++)
    {
        id key = [keys_specname objectAtIndex:i];
        id value = [self.specnameDict objectForKey:key];
        GoodsTypeModel *model = [[GoodsTypeModel alloc] init];
        model.key = key;
        model.value = value;
        
        NSMutableArray *datas = [[NSMutableArray alloc] init];
        NSDictionary *dict = [self.specvalueDict objectForKey:key];
        NSArray *keys_specname1 = [dict allKeys];
        for (int j = 0; j < keys_specname1.count; j++)
        {
            id key1 = [keys_specname1 objectAtIndex:j];
            id value1 = [dict objectForKey:key1];
            GoodsTypeModel *model1 = [[GoodsTypeModel alloc] init];
            model1.key = key1;
            model1.value = value1;
            [datas addObject:model1];
        }
        model.datas = datas;
        [dataProvider addObject:model];
    }
    [self initView];
}

- (void)initView
{
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.height - BUTTONHEIGHT, MTScreenW, BUTTONHEIGHT)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    sureBtn.backgroundColor = [UIColor colorWithRGB:@"dd2726"];
    [sureBtn setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:sureBtn];
    
    //图片
    imgview = [[UIImageView alloc] initWithFrame:CGRectMake(10, -20, 100, 100)];
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"",_goodsInfo.goods_image_url]];
    [imgview sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
    [self.view addSubview:imgview];
    
    priceLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgview.frame) + 10, imgview.y + 25, 120, 23)];
    priceLab.text = [NSString stringWithFormat:@"￥%@",_goodsInfo.goods_price];
    priceLab.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:priceLab];
    
    kucunLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgview.frame) + 10, CGRectGetMaxY(priceLab.frame), 120, 23)];
    kucunLab.text = [NSString stringWithFormat:@"库存%@件",_goodsInfo.goods_discount];
    kucunLab.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:kucunLab];
    
    desLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgview.frame) + 10, CGRectGetMaxY(kucunLab.frame), 190, 23)];
    NSString *str = @"请选择";
    for (GoodsTypeModel *item in dataProvider)
    {
        str = [NSString stringWithFormat:@"%@%@ ",str,item.value];
    }
    desLab.text = str;
    desLab.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:desLab];
    
    UIImageView *topline = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgview.frame) + 9.5, MTScreenW, 0.5)];
    topline.backgroundColor=[UIColor colorWithRGB:@"e2e2e2"];
    [self.view addSubview:topline];
    
    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imgview.frame) + 10, MTScreenH, self.view.height - 90 - 50)];
    [self.view addSubview:contentView];
    
    GoodsSpecCollectionView *view = [[GoodsSpecCollectionView alloc] initWithFrame:CGRectMake(20, 0, MTScreenW - 40, 50)];
    view.dataProvider  = dataProvider;
    __weak __typeof(GoodsSpecCollectionView *)weakview = view;
    view.loadViewRepleteBlock = ^(void){
        CGSize size = {MTScreenW, weakview.height + 60};
        contentView.contentSize = size;
        weakview.y = 0;
        numLab.y =  CGRectGetMaxY(view.frame) + 15;
        _changeView.y = CGRectGetMaxY(view.frame) + 15;
        line.y = CGRectGetMinY(numLab.frame) - 5;
    };
    view.selectedBlock = ^(NSMutableArray *dataArr)
    {
        selectedIDarr = [[NSMutableArray alloc] init];
        allSelected = YES;
        weakview.y = 0;
        NSString *str = @"请选择";
        NSString *str1 = @"已选:";
        
        for (GoodsTypeModel *item in dataArr)
        {
            if (item.selected)
            {
                for (GoodsTypeModel *item1 in item.datas)
                {
                    if (item1.selected)
                    {
                        str1 = [NSString stringWithFormat:@"%@'%@' ",str1,item1.value];
                        [selectedIDarr addObject:item1.key];
                    }
                }
            }
            else if (!item.selected)
            {
                allSelected = NO;
                str = [NSString stringWithFormat:@"%@%@ ",str,item.value];
            }
        }
        if (allSelected)
        {
            [self refleshGoodsData];
            desLab.text = str1;
        }
        else
            desLab.text = str;
    };
    [contentView addSubview:view];
    
    numLab = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(view.frame) + 10, 100, 30)];
    numLab.text = @"购买数量:";
    numLab.textColor = [UIColor colorWithRGB:@"333333"];
    numLab.font = [UIFont systemFontOfSize:16];
    [contentView addSubview:numLab];
    
    _changeView = [[MTChangeCountView alloc] initWithFrame:CGRectMake(MTScreenW - 120, CGRectGetMaxY(view.frame) + 10, 160, 35) chooseCount:1 totalCount: 20];
    
    [_changeView.subButton addTarget:self action:@selector(subButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _changeView.numberFD.delegate = self;
    
    [_changeView.addButton addTarget:self action:@selector(addButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [contentView addSubview:_changeView];
    
    line = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(numLab.frame) - 10, MTScreenW, 0.5)];
    line.backgroundColor=[UIColor colorWithRGB:@"e2e2e2"];
    [contentView addSubview:line];
    
    UIImage *btimg = [UIImage imageNamed:@"btn_dismissItem_highlighted"];
    UIImage *selectImg = [UIImage imageNamed:@"btn_dismissItem"];
    UIButton *dismissBtn = [[UIButton alloc]initWithFrame:CGRectMake(MTScreenW - 30, 20, 15, 15)];
    [dismissBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [dismissBtn setImage:btimg forState:UIControlStateNormal];
    [dismissBtn setImage:selectImg forState:UIControlStateSelected];
    [self.view addSubview:dismissBtn];
}

-(void)selectedHandler:(UIButton *)sender
{
    sender.selected = !sender.selected;
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
    if (self.choosedCount<99)
    {
        [self addCar];
    }
    
    self.choosedCount ++;
    if (self.choosedCount>0) {
        _changeView.subButton.enabled=YES;
    }
    
    if(self.choosedCount>=99)
    {
        self.choosedCount  = 99;
        _changeView.addButton.enabled = NO;
    }
    
    _changeView.numberFD.text=[NSString stringWithFormat:@"%zi",self.choosedCount];
}

-(void)addCar
{
    
}

-(void)deleteCar
{
    
}

/**当参数全部选择之后,重新刷新数据**/
-(void)refleshGoodsData
{
    NSMutableArray *targetPool = [[NSMutableArray alloc] init];
    
    NSArray *keys_specname = [self.speclistDict allKeys];
    for (int i = 0; i < keys_specname.count; i++)
    {
        id key = [keys_specname objectAtIndex:i];
        id value = [self.speclistDict objectForKey:key];
        
        NSArray *arr = [key componentsSeparatedByString:@"|"];
        
        if ([selectedIDarr indexOfObject:arr[0]] > 0 &&[selectedIDarr indexOfObject:arr[1]] > 0 &&
            [selectedIDarr indexOfObject:arr[2]] > 0 &&[selectedIDarr indexOfObject:arr[3]] > 0)
        {
            [self getGoodsDetailInfo:value];
            break;
        }
    }
}


-(void)getGoodsDetailInfo:(NSString *)goodsID
{
    GoodsHeadViewController *vc = (GoodsHeadViewController*)self.parentVC;
    vc.goodsID = goodsID;
    self.goodsID = goodsID;
    [CommonRemoteHelper RemoteWithUrl:URL_Goods_details parameters:@{@"goods_id" : goodsID}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     NSDictionary *dict1 =  [dict objectForKey:@"datas"];
                                     self.goodsInfo = [GoodsInfoModel objectWithKeyValues:[dict1 objectForKey:@"goods_info"]];
                                     priceLab.text = [NSString stringWithFormat:@"￥%@",_goodsInfo.goods_price];
                                     kucunLab.text = [NSString stringWithFormat:@"库存%@件",_goodsInfo.goods_discount];
                                     NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"",_goodsInfo.goods_image_url]];
                                     [imgview sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];

                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [NoticeHelper AlertShow:@"获取失败!" view:self.view];
                                 }];
}

//确定
-(void)sureClick:(UIButton *)sender
{
//    if (!allSelected)
//    {
//        return [NoticeHelper AlertShow:desLab.text view:nil];
//    }
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
    }
}

-(void)back
{
    [self.parentVC dismissSemiModalView];
}



@end
