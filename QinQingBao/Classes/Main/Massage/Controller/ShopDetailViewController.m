//
//  ShopDetailViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/4/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ShopDetailViewController.h"
#import "BuyRightnowView.h"
#import "ShopHeadView.h"
#import "EvaluationNoneCell.h"
#import "ParagraphTextCell.h"
#import "ImageCell.h"

#import "MassageModel.h"

#import "ShopOrderViewController.h"
#import "CCLocationManager.h"

#import "EvaluationCell.h"
#import "EvaluationTotal.h"

#import "QueryAllEvaluationController.h"

@interface ShopDetailViewController ()
{
    NSArray *imgUrlArray;
    
    NSMutableArray *evaArr;
    
    MassageModel *dataItem;
}

@property (nonatomic, retain) BuyRightnowView *headView;

@end

@implementation ShopDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableSkin];
    
    [self getDadaProvider];
    
    [self getAlleva];
    
    if (![SharedAppUtil defaultCommonUtil].lat  || ![SharedAppUtil defaultCommonUtil].lat )
    {
        [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            NSLog(@"%f %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude);
            [SharedAppUtil defaultCommonUtil].lat = [NSString stringWithFormat:@"%f",locationCorrrdinate.latitude];
            [SharedAppUtil defaultCommonUtil].lon = [NSString stringWithFormat:@"%f",locationCorrrdinate.longitude];
            [self getDadaProvider];
        }];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    self.title = @"服务详情";

    [super viewDidAppear:animated];
}

/**
 *  获取服务评价
 */
-(void)getAlleva
{
    evaArr = [[NSMutableArray alloc] init];
    [CommonRemoteHelper RemoteWithUrl:URL_Get_dis_cont parameters: @{@"iid" : self.iid,
                                                                     @"page" : @10,
                                                                     @"p" : @1,
                                                                     @"client" : @"ios"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     EvaluationTotal *result = [EvaluationTotal objectWithKeyValues:dict];
                                     evaArr = result.datas;
                                     [self.tableView reloadData];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                 }];
}


-(void)getDadaProvider
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_get_iteminfo_by_iid parameters:@{@"iid" : self.iid}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         dataItem = [MassageModel objectWithKeyValues:[dict objectForKey:@"datas"]];
                                         [self setHeadData];
                                         if ([dataItem.introduce_url isKindOfClass:[NSArray class]])
                                             imgUrlArray = dataItem.introduce_url;
                                         else
                                             imgUrlArray = @[];
                                         self.headView.orderRightnow.enabled = YES;
                                         [self.tableView reloadData];
                                     }
                                     [HUD removeFromSuperview];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [NoticeHelper AlertShow:@"获取失败!" view:self.view];
                                     [HUD removeFromSuperview];
                                 }];
    
    if (self.shopItem == nil)
    {
        [CommonRemoteHelper RemoteWithUrl:URL_get_orginfo_by_iid parameters:@{@"iid" : self.iid,
                                                                                 @"lat" : [SharedAppUtil defaultCommonUtil].lat ? [SharedAppUtil defaultCommonUtil].lat : @"",
                                                                                 @"lon" : [SharedAppUtil defaultCommonUtil].lon ? [SharedAppUtil defaultCommonUtil].lon :@""}
                                     type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                         
                                         id codeNum = [dict objectForKey:@"code"];
                                         if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                         {
                                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                             [alertView show];
                                         }
                                         else
                                         {
                                             self.shopItem = [ServiceItemModel objectWithKeyValues:[dict objectForKey:@"datas"]];
                                         }
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"发生错误！%@",error);
                                         [NoticeHelper AlertShow:@"获取失败!" view:self.view];
                                     }];
    }
}

-(void)initTableSkin
{
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"ShopHeadView" owner:nil options:nil];
    self.tableView.tableHeaderView = [nibs lastObject];
    self.tableView.tableHeaderView.backgroundColor = HMGlobalBg;
}

/**
 *  设置头部数据
 */
-(void)setHeadData
{
    ShopHeadView *headview = (ShopHeadView *)self.tableView.tableHeaderView;
    [headview setHeadUrl:dataItem.item_url title:dataItem.iname sellNum:dataItem.sell time:dataItem.price_time];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(!self.headView)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"BuyRightnowView" owner:self options:nil];
        self.headView = [nib lastObject];
    }
    __weak typeof(self) weakSelf = self;
    __weak typeof(dataItem) item = dataItem;
    
    [self.headView setPrice:dataItem.price_mem time:dataItem.price_time markPrice:dataItem.price];
    
    self.headView.submitClick = ^(UIButton *button){
        if (![SharedAppUtil defaultCommonUtil].userVO )
            return [MTNotificationCenter postNotificationName:MTNeedLogin object:nil userInfo:nil];
        ShopOrderViewController *view = [[ShopOrderViewController alloc] init];
        view.dataItem = item;
        view.title = item.iname;
        view.shopItem = weakSelf.shopItem;
        [weakSelf.navigationController pushViewController:view animated:YES];
    };
    return self.headView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger count = imgUrlArray ? imgUrlArray.count : 0;
    return count + 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 6)
    {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.height;
    }
    else
    {
        NSString *strUrl = imgUrlArray[indexPath.row - 6];
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:strUrl];
        if (!image)
            image = [UIImage imageNamed:@"placeholderDetail"];
        CGFloat scale = image.size.width / image.size.height;
        CGFloat cellHeight = MTScreenW / scale;
        return cellHeight;
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 5)
        return 50;
    else
        return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.row == 0)
    {
        if (evaArr.count != 0)
        {
            EvaluationCell *evacell = [tableView dequeueReusableCellWithIdentifier:@"MTEvaCell"];
            
            if(evacell == nil)
                evacell = [EvaluationCell evaluationCell];
            
            [evacell setdataWithScore:dataItem.wgrade count:@"100"];
            [evacell setEvaItem:evaArr[0]];
            evacell.queryClick  = ^(UIButton *btn){
                [self queryAllevaluation];
            };
            cell = evacell;
        }
        else
        {
            EvaluationNoneCell *evanoneCell = [tableView dequeueReusableCellWithIdentifier:@"MTEvanoneCell"];
            if(evanoneCell == nil)
                evanoneCell = [EvaluationNoneCell evanoneCell];
            [evanoneCell setScore:[NSString stringWithFormat:@"%.1f",[dataItem.wgrade floatValue]]];
            cell = evanoneCell;
        }
    }
    else if (indexPath.row == 1)
    {
        UITableViewCell *commoncell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonCell"];
        if(commoncell == nil)
            commoncell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MTCommonCell"];
        commoncell.textLabel.text = @"项目介绍";
        cell = commoncell;
    }
    else
    {
        ParagraphTextCell *paragraphTextCell = [tableView dequeueReusableCellWithIdentifier:@"MTParagraphTextCell"];
        if(paragraphTextCell == nil)
            paragraphTextCell = [ParagraphTextCell paragraphTextCell];
        switch (indexPath.row)
        {
            case 2:
                [paragraphTextCell setTitle:@"功效" withValue:dataItem.effect];
                cell = paragraphTextCell;
                break;
            case 3:
                [paragraphTextCell setTitle:@"药材" withValue:dataItem.medicines];
                cell = paragraphTextCell;
                break;
            case 4:
                [paragraphTextCell setTitle:@"流程" withValue:dataItem.process];
                cell = paragraphTextCell;
                break;
            case 5:
                [paragraphTextCell setTitle:@"人群" withValue:dataItem.appropriate_population];
                cell = paragraphTextCell;
                break;
            default:
            {
                ImageCell *imgcell = [tableView dequeueReusableCellWithIdentifier:@"MTImageCell"];
                if (!imgcell)
                    imgcell = [[[NSBundle mainBundle] loadNibNamed:@"ImageCell" owner:nil options:nil] lastObject];
                NSString *strUrl;
                if (imgUrlArray.count>0)
                    strUrl = imgUrlArray[indexPath.row - 6];
                UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:strUrl];
                if (!image)
                {
                    image = [UIImage imageNamed:@"placeholderDetail"];
                    [self loadImageWithIndexpath:indexPath url:strUrl];
                }
                imgcell.imgView.image = image;
                cell = imgcell;
            }
                break;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)loadImageForVisibleCells
{
    NSArray *visiableIndexPathes = [self.tableView indexPathsForVisibleRows];
    
    for(NSIndexPath *indexpath in visiableIndexPathes)
    {
        NSString *strUrl = imgUrlArray[indexpath.row -6];
        [self loadImageWithIndexpath:indexpath url:strUrl];
    }
}


/**
 *  下载图片
 *
 *  @param idx    cell序列
 *  @param urlStr url
 */
-(void)loadImageWithIndexpath:(NSIndexPath *)idx url:(NSString *)urlStr
{
    if (imgUrlArray.count>0)
    {
        NSURL *imageurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Img,urlStr]];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:imageurl options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            if (image) {
                [[SDImageCache sharedImageCache] storeImage:image forKey:urlStr toDisk:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadRowsAtIndexPaths:@[idx] withRowAnimation:UITableViewRowAnimationNone];
                });
            }else{
                NSLog(@"%d=========%@",(int)idx.row,@"下载失败");
            }
        }];
    }
}

/**
 *  获取全部评价
 */
-(void)queryAllevaluation
{
    QueryAllEvaluationController *queryAlleva = [[QueryAllEvaluationController alloc] init];
    queryAlleva.itemId = dataItem.iid;
    [self.navigationController pushViewController:queryAlleva animated:YES];
}
@end
