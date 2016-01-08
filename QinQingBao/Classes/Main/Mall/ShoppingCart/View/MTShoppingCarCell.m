//
//  MTShoppingCarCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/7.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "MTShoppingCarCell.h"
#import "MTShoppingCarController.h"
static CGFloat CELL_HEIGHT = 100;

@interface MTShoppingCarCell () <UITextFieldDelegate>


@property(nonatomic,strong)UIButton *selectBt;
@property(nonatomic,strong)UIImageView *shoppingImgView;
@property(nonatomic,strong)UIImageView *spuImgView;
@property(nonatomic,strong)UILabel *title ;
@property(nonatomic,strong)MTChangeCountView *changeView;
@property(nonatomic,strong)UILabel *priceLab;
@property(nonatomic,strong)UILabel *sizeLab;

@property(nonatomic,assign)CGRect tableVieFrame;


@property(nonatomic,strong)UILabel *soldoutLab;

@end

@implementation MTShoppingCarCell


- (void)prepareForReuse
{
    [super prepareForReuse];
    _soldoutLab.hidden=YES;
    [_shoppingImgView sd_setImageWithURL:nil];
    [_changeView removeFromSuperview];
    _spuImgView.image = nil;
    _changeView = nil;
    _sizeLab.text = nil;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier tableView:(UITableView *)tableView
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        _tableView = tableView;
        [self initCellView];
    }
    return self;
}
- (void)initCellView
{
    
    
    UIImage *btimg = [UIImage imageNamed:@"ic_cb_normal.png"];
    UIImage *selectImg = [UIImage imageNamed:@"ic_cb_checked"];
    
    _selectBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, btimg.size.width+20, CELL_HEIGHT)];
    [_selectBt addTarget:self action:@selector(clickSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_selectBt setImage:btimg forState:UIControlStateNormal];
    [_selectBt setImage:selectImg forState:UIControlStateSelected];
    [self.contentView addSubview:_selectBt];
    
    
    
    _shoppingImgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_selectBt.frame)+7, 12, 70, 70)];
    [self.contentView addSubview:_shoppingImgView];
    
    _spuImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [_shoppingImgView addSubview:_spuImgView];
    
    
    _title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_shoppingImgView.frame)+10, 10, MTScreenW-CGRectGetMaxX(_shoppingImgView.frame)-15, 21)];
    _title.font=[UIFont systemFontOfSize:15];
    _title.textColor=[UIColor colorWithRGB:@"666666"];
    
    [self.contentView addSubview:_title];
    
    
    _sizeLab = [[UILabel alloc] initWithFrame:CGRectMake(_title.frame.origin.x, CGRectGetMaxY(_title.frame), 200, 17)];
    _sizeLab.font=[UIFont systemFontOfSize:12];
    _sizeLab.textColor=[UIColor colorWithRGB:@"666666"];
    [self.contentView addSubview:_sizeLab];
    
    
    
    _soldoutLab = [[UILabel alloc]initWithFrame:CGRectMake(_title.frame.origin.x, CGRectGetMaxY(_sizeLab.frame)+15, 100, 17)];
    _soldoutLab.hidden =YES;
    _soldoutLab.text=@"无货";
    _soldoutLab.font =  [UIFont systemFontOfSize:14];
    _soldoutLab.textColor=[UIColor colorWithRGB:@"666666"];
    [self.contentView addSubview:_soldoutLab];
    
    
    _priceLab = [[UILabel alloc]initWithFrame:CGRectMake(MTScreenW-18-100, CGRectGetMaxY(_sizeLab.frame)+5+5, 100, 17)];
    _priceLab.textAlignment=NSTextAlignmentRight;
    _priceLab.textColor=[UIColor colorWithRGB:@"FF0000"];
    [self.contentView addSubview:_priceLab];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _changeView.numberFD = textField;
    if ([self isPureInt:_changeView.numberFD.text]) {
        if ([_changeView.numberFD.text integerValue]<0) {
            _changeView.numberFD.text=@"1";
        }
        
    }
    else
    {
        _changeView.numberFD.text=@"1";
    }
    
    
    if ([_changeView.numberFD.text isEqualToString:@""] || [_changeView.numberFD.text isEqualToString:@"0"]) {
        self.choosedCount = 1;
        _changeView.numberFD.text=@"1";
        
    }
    NSString *numText = _changeView.numberFD.text;
    if ([numText intValue]>[_model.item_info.stock_quantity  intValue]) {
        _changeView.numberFD.text=[NSString stringWithFormat:@"%zi",[_model.item_info.stock_quantity  intValue]];
        
        
    }
    
    if ([numText intValue] >99) {
        //  [SVProgressHUD showErrorWithStatus:@"最多支持购买99个"];
        _changeView.numberFD.text = @"99";
    }
    
    _changeView.addButton.enabled=YES;
    _changeView.subButton.enabled=YES;
    self.choosedCount = [_changeView.numberFD.text integerValue];
    _model.count = _changeView.numberFD.text;
    _model.isSelect = _selectBt.selected;
    
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}




- (void)setModel:(MTShoppIngCarModel *)model
{
    _model = model;
    _selectBt.selected=model.isSelect;
    if (_changeView.numberFD.text) {
        self.choosedCount = [_changeView.numberFD.text integerValue];
    }
    else{
        self.choosedCount =[model.count integerValue] ;
    }
    
    
    _shoppingImgView.layer.cornerRadius = 2;
    _shoppingImgView.layer.borderWidth = 1;
    _shoppingImgView.layer.borderColor = [UIColor colorWithRGB:@"e2e2e2"].CGColor;
    [_shoppingImgView sd_setImageWithURL:[NSURL URLWithString:model.item_info.icon] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    
    
    //    if ([model.item_info.is_spu intValue] == 1) {
    //        UIImage *img = [UIImage imageNamed:@"spuIcon"];
    //        _spuImgView.image = img;
    //      //  _spuImgView.size = img.size;
    //        _priceLab.text=[NSString stringWithFormat:@"￥%@",model.item_info.sale_price];
    //    } else {
    
    UIImage *level = [UIImage imageNamed:@"level2"];
    if (model.item_info.type == 5) {
        _spuImgView.image = [UIImage imageNamed:@"level3"];
        //   _spuImgView.size = level.size;
    } else if (model.item_info.type == 6) {
        //  _spuImgView.size = level.size;
        _spuImgView.image = level;
    }
    
    if (![model.item_size isEqualToString:@"SINGLE"])
        _sizeLab.text = [NSString stringWithFormat:@"规格:%@",model.item_size];
    
    NSInteger strlength = model.item_info.sale_price.length;
    NSString *string                            = [NSString stringWithFormat:@"￥%@",model.item_info.sale_price];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    // 设置富文本样式
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:10.f]
                             range:NSMakeRange(0, 1)];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:14.f]
                             range:NSMakeRange(1, strlength)];
    _priceLab.attributedText = attributedString;
    
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:10.f]
                             range:NSMakeRange(strlength - 2, 3)];
    _priceLab.attributedText = attributedString;
//    _priceLab.text=[NSString stringWithFormat:@"￥%@",model.item_info.sale_price];
    //    }
    
    _title.text= model.item_info.full_name;
    
    
    if ([model.item_info.sale_state isEqualToString:@"3"]) {
        _soldoutLab.hidden=NO;
        _selectBt.enabled=NO;
        
        if (self.isEdit) {
            //编辑状态
            _selectBt.enabled=YES;
        }
    }
    else{
        _selectBt.enabled=YES;
        _changeView = [[MTChangeCountView alloc] initWithFrame:CGRectMake(_title.frame.origin.x, CGRectGetMaxY(_sizeLab.frame)+5, 160, 35) chooseCount:self.choosedCount totalCount: [model.item_info.stock_quantity integerValue]];
        
        [_changeView.subButton addTarget:self action:@selector(subButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        _changeView.numberFD.delegate = self;
        
        [_changeView.addButton addTarget:self action:@selector(addButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_changeView];
    }
    
}
//加
- (void)addButtonPressed:(id)sender
{
    
    if (self.choosedCount<99) {
        [self addCar];
    }
    
    ++self.choosedCount ;
    if (self.choosedCount>0) {
        _changeView.subButton.enabled=YES;
    }
    
    
    if ([_model.item_info.stock_quantity integerValue]<self.choosedCount) {
        self.choosedCount  = [_model.item_info.stock_quantity  intValue];
        _changeView.addButton.enabled = NO;
    }
    else
    {
        _changeView.subButton.enabled = YES;
    }
    
    if(self.choosedCount>=99)
    {
        self.choosedCount  = 99;
        _changeView.addButton.enabled = NO;
    }
    
    _changeView.numberFD.text=[NSString stringWithFormat:@"%zi",self.choosedCount];
    
    _model.count = _changeView.numberFD.text;
    
    _model.isSelect=_selectBt.selected;
}

-(void)addCar
{
    
}

-(void)clickSelect:(UIButton *)bt
{
    //  _selectBt.selected = !_selectBt.selected;
    if (!_soldoutLab.hidden && !self.isEdit) {
        return;
    }
    _selectBt.selected = !_selectBt.selected;
    _model.isSelect = _selectBt.selected;
    
    if (_changeView.numberFD.text!=nil) {
        _model.count = _changeView.numberFD.text;
    }
    
    [self.delegate singleClick:_model row:self.row];
}

//减
- (void)subButtonPressed:(id)sender
{
    
    if (self.choosedCount >1) {
        [self deleteCar];
    }
    
    -- self.choosedCount ;
    
    if (self.choosedCount==0) {
        self.choosedCount= 1;
        _changeView.subButton.enabled=NO;
    }
    else
    {
        _changeView.addButton.enabled=YES;
        
    }
    _changeView.numberFD.text=[NSString stringWithFormat:@"%zi",self.choosedCount];
    
    _model.count = _changeView.numberFD.text;
    
    _model.isSelect=_selectBt.selected;
    
    
    
}

-(void)deleteCar
{
    
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


+(CGFloat)getHeight
{
    return CELL_HEIGHT;
}

@end
