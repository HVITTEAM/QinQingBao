//
//  ShoppingCarController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/7.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "MTShoppingCarController.h"
#import "MTHeardView.h"
#import "RecommendView.h"


#import "ShopCarModel.h"
#import "ShopCarModelTotal.h"

@interface MTShoppingCarController () <UITableViewDataSource,UITableViewDelegate,MTShoppingCarCellDelegate,MTShoppingCartEndViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *carDataArrList;
@property(nonatomic,strong)UIToolbar *toolbar;
@property (nonatomic , strong) UIBarButtonItem *previousBarButton;
@property(nonatomic,strong) MTShoppingCartEndView *endView;

@end

@implementation MTShoppingCarController

-(instancetype)init
{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"购物车";
    [self getShopCarData];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.endView];
    
    //获取数据
//    _vm = [[MTShopViewModel alloc]init];
//    
//    __weak typeof (MTShoppingCarController) *waks = self;
//    __weak typeof (NSMutableArray)* carDataArrList =self.carDataArrList;
//    __weak typeof (UITableView ) *tableView = self.tableView;
//    
//    //设置价格改变block
//    [_vm getShopData:^(NSArray *commonArry, NSArray *kuajingArry) {
//        [carDataArrList addObject:commonArry];
//        [tableView reloadData];
//        [waks numPrice];
//    } priceBlock:^{
//        [waks numPrice];
//    }];
    
//    [self finshBarView];
//    [self loadNotificationCell];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edits:)];
}

-(void)getShopCarData
{
    [CommonRemoteHelper RemoteWithUrl:URL_Cart_list parameters: @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                  @"client" : @"ios"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     NSDictionary *dict1 = [dict objectForKey:@"datas"];
                                     
                                     ShopCarModelTotal *result = [ShopCarModelTotal objectWithKeyValues:dict1];
                                     
                                     self.carDataArrList = result.cart_list;
                                     [self.tableView reloadData];
                                     if (result.cart_list.count == 0)
                                     {
                                         [NoticeHelper AlertShow:@"暂无数据!" view:self.view];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"出错了....");
                                 }];
}


-(void)finshBarView
{
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, MTScreenH, MTScreenW, 44)];
    // _toolbar.frame = CGRectMake(0, 0, MTScreenW, 44);
    [_toolbar setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.previousBarButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(previousButtonIsClicked:)];
    NSArray *barButtonItems = @[flexBarButton,self.previousBarButton];
    _toolbar.items = barButtonItems;
    [self.view addSubview:_toolbar];
}

- (void) previousButtonIsClicked:(id)sender
{
    [self.view endEditing:YES];
}


-(void)loadNotificationCell
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
}

/**
 * 计算价钱
 **/
- (void)numPrice
{
    //是否全部选择
//    BOOL isAllSelected = YES;
//    NSInteger goodsCount = 0;
//    NSArray *lists =   [_endView.Lab.text componentsSeparatedByString:@"￥"];
//    float num = 0.00;
//    for (int i=0; i<self.carDataArrList.count; i++) {
//        NSArray *list = [self.carDataArrList objectAtIndex:i];
//        for (int j = 0; j<list.count-1; j++) {
//            MTShoppIngCarModel *model = [list objectAtIndex:j];
//            NSInteger count = [model.count integerValue];
//            float sale = [model.item_info.sale_price floatValue];
//            if (model.isSelect && ![model.item_info.sale_state isEqualToString:@"3"] )
//            {
//                num = count*sale+ num;
//                goodsCount ++;
//            }
//            if (!model.isSelect)
//                isAllSelected = NO;
//        }
//    }
    
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@￥%.2f",lists[0],num]];
//    
//    // 设置富文本样式
//    [attributedString addAttribute:NSForegroundColorAttributeName
//                             value:[UIColor colorWithRGB:@"333333"]
//                             range:NSMakeRange(0, 3)];
//    
//    _endView.Lab.attributedText = attributedString;
//    
//    _endView.pushBt.enabled = num > 0;
//    if (goodsCount > 0)
//        [_endView.pushBt setTitle:[NSString stringWithFormat:@"结算(%ld)",(long)goodsCount] forState:UIControlStateNormal];
//    else
//        [_endView.pushBt setTitle:@"结算" forState:UIControlStateNormal];
//    
//    if (!self.isEdit)
//        _endView.selectedAllbt.selected = isAllSelected;
//    else
//        _endView.selectedAllbt.selected = isAllSelected;
}

-(MTShoppingCartEndView *)endView
{
    if (!_endView) {
        _endView = [[MTShoppingCartEndView alloc]initWithFrame:CGRectMake(0, MTScreenH - [MTShoppingCartEndView getViewHeight], MTScreenW, [MTShoppingCartEndView getViewHeight])];
        _endView.delegate=self;
        
        
    }
    return _endView;
}

#pragma mark MTShoppingCartEndViewDelegate 全选操作

- (void)clickALLEnd:(UIButton *)bt
{
    //全选 也可以在 VM里面 写  这次在Controller里面写了
//    bt.selected = !bt.selected;
//    
//    BOOL btselected = bt.selected;
//    
//    NSString *checked = @"";
//    if (btselected) {
//        checked = @"YES";
//    }
//    else
//    {
//        checked = @"NO";
//    }
//    
//    if (self.isEdit) {
//        //取消
//        for (int i =0; i<_carDataArrList.count; i++) {
//            NSArray *dataList = [_carDataArrList objectAtIndex:i];
//            NSMutableDictionary *dic = [dataList lastObject];
//            
//            [dic setObject:checked forKey:@"checked"];
//            for (int j=0; j<dataList.count-1; j++) {
//                MTShoppIngCarModel *model = (MTShoppIngCarModel *)[dataList objectAtIndex:j];
//                if (![model.item_info.sale_state isEqualToString:@"3"]) {
//                    model.isSelect=btselected;
//                }
//            }
//        }
//    }
//    else
//    {
//        //编辑
//        for (int i =0; i<_carDataArrList.count; i++) {
//            NSArray *dataList = [_carDataArrList objectAtIndex:i];
//            NSMutableDictionary *dic = [dataList lastObject];
//            [dic setObject:checked forKey:@"checked"];
//            for (int j=0; j<dataList.count-1; j++) {
//                MTShoppIngCarModel *model = (MTShoppIngCarModel *)[dataList objectAtIndex:j];
//                model.isSelect=btselected;
//            }
//        }
//    }
//    [_tableView reloadData];
}

/**
 * 结算按钮触发事件
 **/
- (void)clickRightBT:(UIButton *)bt
{
//    if(bt.tag==19)
//    {
//        //删除
//        for (int i = 0; i<_carDataArrList.count; i++) {
//            NSMutableArray *arry = [_carDataArrList objectAtIndex:i];
//            for (int j=0 ; j<arry.count-1; j++) {
//                MTShoppIngCarModel *model = [ arry objectAtIndex:j];
//                if (model.isSelect==YES) {
//                    [arry removeObjectAtIndex:j];
//                    continue;
//                }
//            }
//            if (arry.count<=1) {
//                [_carDataArrList removeObjectAtIndex:i];
//            }
//        }
//        [_tableView reloadData];
//    }
//    else if (bt.tag==18)
//    {
//        //结算
//        NSLog(@"结算去支付");
//    }
}
- (void)edits:(UIBarButtonItem *)item
{
//    self.isEdit = !self.isEdit;
//    if (self.isEdit) {
//        item.title = @"取消";
//        for (int i=0; i<_carDataArrList.count; i++) {
//            NSArray *list = [_carDataArrList objectAtIndex:i];
//            for (int j = 0; j<list.count-1; j++) {
//                MTShoppIngCarModel *model = [list objectAtIndex:j];
//                if ([model.item_info.sale_state isEqualToString:@"3"]) {
//                    model.isSelect=NO;
//                }
//                else
//                {
//                    model.isSelect=YES;
//                }
//            }
//        }
//    }
//    else{
//        item.title = @"编辑";
//        for (int i=0; i<_carDataArrList.count; i++) {
//            NSArray *list = [_carDataArrList objectAtIndex:i];
//            for (int j = 0; j<list.count-1; j++) {
//                MTShoppIngCarModel *model = [list objectAtIndex:j];
//                model.isSelect = YES;
//            }
//        }
//        
//    }
//    
//    _endView.isEdit = self.isEdit;
//    [_vm pitchOn:_carDataArrList];
//    [_tableView reloadData];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH-[MTShoppingCartEndView getViewHeight]) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.userInteractionEnabled=YES;
        _tableView.dataSource = self;
        _tableView.scrollsToTop=YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithRGB:@"e2e2e2"];
        
        RecommendView *footView = [[RecommendView alloc] init];
        footView.frame = CGRectMake(0, 0, MTScreenW, 350);
        footView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = footView;
    }
    return _tableView;
}

- (void)endViewHidden
{
    if (_carDataArrList.count==0) {
        self.endView.hidden=YES;
    }
    else
    {
        self.endView.hidden=NO;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    [self endViewHidden];
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.carDataArrList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return 50;
    }
    else
    {
        return 40;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MTHeardView * heardView =[[MTHeardView alloc]initWithFrame:CGRectMake(0, 0, MTScreenW, 40) section:section carDataArrList:_carDataArrList block:^(UIButton *bt) {
        
    }];
    heardView.backgroundColor=[UIColor whiteColor];
    return heardView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *shoppingCaridentis = @"MTShoppingCarCells";
    MTShoppingCarCell *cell = [tableView dequeueReusableCellWithIdentifier:shoppingCaridentis];
    if (!cell)
    {
        cell = [[MTShoppingCarCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shoppingCaridentis tableView:tableView];
        cell.delegate=self;
    }
    if (self.carDataArrList.count>0)
    {
        [cell setModel:[self.carDataArrList objectAtIndex:indexPath.row]];
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
//        if (list.count-2 !=indexPath.row) {
//            UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(45, [MTShoppingCarCell getHeight]-0.5, MTScreenW-45, 0.5)];
//            line.backgroundColor=[UIColor colorWithRGB:@"e2e2e2"];
//            [cell addSubview:line];
//        }
    }
    return cell;
}

#pragma mark MTShoppingCarCellDelegate 左边勾选操作代理

//- (void)singleClick:(MTShoppIngCarModel *)models row:(NSInteger)row
//{
//    [_vm pitchOn:_carDataArrList];
//    if (models.type==1) {
//        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
//        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
//    }
//    else if(models.type==2)
//    {
//        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
//    }
//}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
//        NSMutableArray *list = [_carDataArrList objectAtIndex:indexPath.section];
//        
//        MTShoppIngCarModel *model = [ list objectAtIndex:indexPath.row];
//        model.isSelect=NO;
//        [list removeObjectAtIndex:indexPath.row];
//        
//        if (list.count==1) {
//            
//            
//            [_carDataArrList removeObjectAtIndex:indexPath.section];
//            
//        }
//        
//        [_tableView reloadData];
        
    }
}

- (void)keyboardWillShow:(NSNotification *)notif {
    if (self.view.hidden == YES) {
        return;
    }
    
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat y = rect.origin.y;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    NSArray *subviews = [self.view subviews];
    for (UIView *sub in subviews) {
        CGFloat maxY = CGRectGetMaxY(sub.frame);
        if ([sub isKindOfClass:[UITableView class]]) {
            
            sub.frame = CGRectMake(0, 0, sub.frame.size.width, MTScreenH-_toolbar.frame.size.height-rect.size.height);
            sub.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0, sub.frame.size.height/2);
            
        }else{
            if (maxY > y - 2) {
                sub.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0, sub.center.y - maxY + y );
            }
        }
    }
    [UIView commitAnimations];
}

- (void)keyboardShow:(NSNotification *)notif {
    if (self.view.hidden == YES) {
        return;
    }
}

- (void)keyboardWillHide:(NSNotification *)notif {
    if (self.view.hidden == YES) {
        return;
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    NSArray *subviews = [self.view subviews];
    for (UIView *sub in subviews) {
        if (sub.center.y < CGRectGetHeight(self.view.frame)/2.0) {
            sub.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0, CGRectGetHeight(self.view.frame)/2.0);
        }
    }
    _toolbar.frame=CGRectMake(0, MTScreenH, MTScreenW, _toolbar.frame.size.height);
    _endView.frame = CGRectMake(0, self.view.frame.size.height-_endView.frame.size.height, MTScreenW, _endView.frame.size.height);
    
    self.tableView.frame=CGRectMake(0, 0, self.tableView.frame.size.width, MTScreenH-[MTShoppingCartEndView getViewHeight]);
    [UIView commitAnimations];
}

- (void)keyboardHide:(NSNotification *)notif {
    if (self.view.hidden == YES) {
        return;
    }
}
@end

